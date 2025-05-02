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


