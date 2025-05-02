import csv
import os
import mysql.connector

# Configuration: database connection parameters
DB_CONFIG = {
    'user': 'root',
    'host': 'localhost',
    'database': 'games',
    'password': 'Ventus01$'
}

def get_platform_name(filename):
    """
    Extract platform name from filename.
    E.g. "All_PlayStation_2_Games_May_2025.csv" -> "PlayStation 2".
    """
    prefix = "All_"
    suffix = "_Games_May_2025.csv"
    name = filename
    if name.startswith(prefix):
        name = name[len(prefix):]
    if name.endswith(suffix):
        name = name[:-len(suffix)]
    # Replace underscores with space (e.g. "PlayStation_2" -> "PlayStation 2")
    return name.replace('_', ' ').strip()

def ensure_platform(cursor, platform):
    """
    Ensure the platform exists in Platforms table. Return its PlatformID.
    """
    cursor.execute("SELECT PlatformID FROM Platforms WHERE Name = %s", (platform,))
    row = cursor.fetchone()
    if row:
        return row[0]
    # Insert new platform
    cursor.execute("INSERT IGNORE INTO Platforms (Name) VALUES (%s)", (platform,))
    # If inserted a new row, get its ID; else fetch again
    if cursor.lastrowid:
        return cursor.lastrowid
    cursor.execute("SELECT PlatformID FROM Platforms WHERE Name = %s", (platform,))
    row = cursor.fetchone()
    return row[0] if row else None

def ensure_genre(cursor, genre):
    """
    Ensure the genre exists in Genres table. Return its GenreID.
    """
    cursor.execute("SELECT GenreID FROM Genres WHERE Name = %s", (genre,))
    row = cursor.fetchone()
    if row:
        return row[0]
    cursor.execute("INSERT IGNORE INTO Genres (Name) VALUES (%s)", (genre,))
    if cursor.lastrowid:
        return cursor.lastrowid
    cursor.execute("SELECT GenreID FROM Genres WHERE Name = %s", (genre,))
    row = cursor.fetchone()
    return row[0] if row else None

def get_or_create_game(cursor, title, year, score, url):
    """
    Get GameID for a given title+year, inserting if necessary. Return GameID.
    """
    cursor.execute(
        "SELECT GameID FROM Games WHERE Title = %s AND ReleaseYear = %s",
        (title, year)
    )
    row = cursor.fetchone()
    if row:
        return row[0]
    # Insert new game
    cursor.execute(
        "INSERT IGNORE INTO Games (Title, ReleaseYear, MobyScore, URL) VALUES (%s, %s, %s, %s)",
        (title, year, score, url)
    )
    if cursor.lastrowid:
        return cursor.lastrowid
    # If INSERT IGNORE skipped (perhaps due to duplicate unique key), fetch again
    cursor.execute(
        "SELECT GameID FROM Games WHERE Title = %s AND ReleaseYear = %s",
        (title, year)
    )
    row = cursor.fetchone()
    return row[0] if row else None

def import_games_from_csv(csv_path):
    """
    Import games from a single CSV file into the database.
    """
    filename = os.path.basename(csv_path)
    platform_name = get_platform_name(filename)
    
    # Connect to DB
    db = mysql.connector.connect(**DB_CONFIG)
    cursor = db.cursor()
    
    # Ensure platform exists, get PlatformID
    platform_id = ensure_platform(cursor, platform_name)
    if not platform_id:
        print(f"Error: could not get PlatformID for {platform_name}.")
        cursor.close()
        db.close()
        return

    with open(csv_path, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            # Clean and extract data
            title = row['Title'].strip()
            year = row['Release Year'].strip()
            # If year is empty or not integer, skip
            if not year.isdigit():
                print(f"Skipping game with invalid year: {title}")
                continue
            year = int(year)
            # MobyScore may be numeric (float or int), attempt conversion
            score_str = row['Moby Score'].strip()
            try:
                moby_score = float(score_str) if score_str else None
            except ValueError:
                moby_score = None
            url = row['URL'].strip()
            
            # Insert or retrieve GameID
            game_id = get_or_create_game(cursor, title, year, moby_score, url)
            if not game_id:
                print(f"Skipped game (no ID): {title} ({year})")
                continue
            
            # Link game to platform (junction table)
            cursor.execute(
                "INSERT IGNORE INTO GamePlatforms (GameID, PlatformID) VALUES (%s, %s)",
                (game_id, platform_id)
            )
            
            # Process genres (assume 'Genres' column is comma-separated)
            genres_field = row['Genres'].strip()
            if genres_field:
                # Split by comma (adjust delimiter as needed)
                genre_list = [g.strip() for g in genres_field.split(',') if g.strip()]
                for genre_name in genre_list:
                    genre_id = ensure_genre(cursor, genre_name)
                    if not genre_id:
                        print(f"Warning: failed to get GenreID for {genre_name}")
                        continue
                    # Link game to genre
                    cursor.execute(
                        "INSERT IGNORE INTO GameGenres (GameID, GenreID) VALUES (%s, %s)",
                        (game_id, genre_id)
                    )
    # Commit after processing this file
    db.commit()
    cursor.close()
    db.close()

if __name__ == "__main__":
    # List of CSV filenames to import
    csv_files = [
        "All_PlayStation_Games_May_2025.csv",
        "All_PlayStation_2_Games_May_2025.csv",
        "All_Nintendo_64_Games_May_2025.csv",
        "All_SNES_Games_May_2025.csv",
        "All_Genesis_Games_May_2025.csv",
        "All_Dreamcast_Games_May_2025.csv"
    ]
    # Determine script directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    for fname in csv_files:
        path = os.path.join(script_dir, fname)
        if os.path.isfile(path):
            print(f"Importing from {fname}...")
            import_games_from_csv(path)
        else:
            print(f"File not found: {fname}")