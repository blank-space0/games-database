# Query 1)
# Allows us to view the most common genres overall
SELECT ge.Name AS Genre, COUNT(*) AS GameCount
FROM GameGenres gg
JOIN Genres ge ON gg.GenreID = ge.GenreID
GROUP BY ge.Name
ORDER BY GameCount DESC;

# Query 2)
# Most popular games by platform
SELECT p.Name AS Platform, ge.Name AS Genre, COUNT(*) AS GameCount
FROM GamePlatforms gp
JOIN Platforms p ON gp.PlatformID = p.PlatformID
JOIN GameGenres gg ON gp.GameID = gg.GameID
JOIN Genres ge ON gg.GenreID = ge.GenreID
GROUP BY p.Name, ge.Name
ORDER BY p.Name, GameCount DESC;

# Query 3)
# Average score per platform
SELECT p.Name AS Platform, ROUND(AVG(g.MobyScore), 2) AS AvgScore
FROM Games g
JOIN GamePlatforms gp ON g.GameID = gp.GameID
JOIN Platforms p ON gp.PlatformID = p.PlatformID
WHERE g.MobyScore IS NOT NULL
GROUP BY p.Name
ORDER BY AvgScore DESC;

# Query 4)
# Games released per year
SELECT ReleaseYear, COUNT(*) AS GamesReleased
FROM Games
GROUP BY ReleaseYear
ORDER BY ReleaseYear;

# Query 5) 
# Top 10 highest rated games
SELECT Title, ReleaseYear, MobyScore
FROM Games
WHERE MobyScore IS NOT NULL
ORDER BY MobyScore DESC
LIMIT 10;

# Query 6)
# Games with most genres
SELECT g.Title, COUNT(*) AS GenreCount
FROM Games g
JOIN GameGenres gg ON g.GameID = gg.GameID
GROUP BY g.GameID
ORDER BY GenreCount DESC
LIMIT 10;

# Query 7: Best game per console based on MobyScore
SELECT 
    p.Name AS Platform, 
    g.Title, 
    g.MobyScore
FROM 
    Games g
JOIN GamePlatforms gp ON g.GameID = gp.GameID
JOIN Platforms p ON gp.PlatformID = p.PlatformID
JOIN (
    SELECT gp.PlatformID, MAX(g.MobyScore) AS MaxScore
    FROM Games g
    JOIN GamePlatforms gp ON g.GameID = gp.GameID
    WHERE g.MobyScore IS NOT NULL
    GROUP BY gp.PlatformID
) AS max_scores
  ON gp.PlatformID = max_scores.PlatformID AND g.MobyScore = max_scores.MaxScore
ORDER BY p.Name;

# Query 9: Total games per console in each console group
SELECT console_group, Name AS Platform, COUNT(DISTINCT gp.GameID) AS GameCount
FROM Platforms p
JOIN GamePlatforms gp ON p.PlatformID = gp.PlatformID
GROUP BY console_group, Name
ORDER BY console_group;

# Query 10: All games for a specific platform
SELECT g.Title, g.ReleaseYear, g.MobyScore
FROM Games g
JOIN GamePlatforms gp ON g.GameID = gp.GameID
JOIN Platforms p ON gp.PlatformID = p.PlatformID
WHERE p.Name = 'PlayStation 2'  -- Change this to any platform like 'PlayStation' or 'N64'
ORDER BY g.Title;

# Query 11: Searching for a specific title (Mario, Sonic, etc)
SELECT g.Title, g.ReleaseYear, g.MobyScore, p.Name AS Platform
FROM Games g
JOIN GamePlatforms gp ON g.GameID = gp.GameID
JOIN Platforms p ON gp.PlatformID = p.PlatformID
WHERE g.Title LIKE '%hearts%';  -- Case-insensitive substring search

# Query 12: Searching for a game using the game search view
SELECT *
FROM GameSearchView
WHERE Title LIKE '%kingdom%';

# Query 13: Search for games in that specific year
SELECT *
FROM GameSearchView
WHERE ReleaseYear = 1997
ORDER BY Title;

# Query 14: Display competitors for that console generation
SELECT 
    p1.Name AS Platform,
    p2.Name AS Competitor
FROM Platforms p1
JOIN Platforms p2 ON p1.CompetitorID = p2.PlatformID
WHERE p1.PlatformID < p2.PlatformID;





