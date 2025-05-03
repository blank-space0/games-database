# Game search view
CREATE VIEW GameSearchView AS
SELECT 
    g.GameID,
    g.Title,
    g.ReleaseYear,
    g.MobyScore,
    p.Name AS Platform,
    GROUP_CONCAT(DISTINCT ge.Name ORDER BY ge.Name SEPARATOR ', ') AS Genres
FROM Games g
JOIN GamePlatforms gp ON g.GameID = gp.GameID
JOIN Platforms p ON gp.PlatformID = p.PlatformID
LEFT JOIN GameGenres gg ON g.GameID = gg.GameID
LEFT JOIN Genres ge ON gg.GenreID = ge.GenreID
GROUP BY g.GameID, g.Title, g.ReleaseYear, g.MobyScore, p.Name;

# Competitor column
ALTER TABLE Platforms ADD CompetitorID INT;

# Referential key
ALTER TABLE Platforms
ADD CONSTRAINT fk_competitor
FOREIGN KEY (CompetitorID) REFERENCES Platforms(PlatformID);

# Competitor mappings:
# SNES VS Genesis
UPDATE Platforms p1
JOIN Platforms p2 ON p2.Name = 'Genesis'
SET p1.CompetitorID = p2.PlatformID
WHERE p1.Name = 'SNES';

UPDATE Platforms p1
JOIN Platforms p2 ON p2.Name = 'SNES'
SET p1.CompetitorID = p2.PlatformID
WHERE p1.Name = 'Genesis';

# PlayStation VS Nintendo 64
UPDATE Platforms p1
JOIN Platforms p2 ON p2.Name = 'Nintendo 64'
SET p1.CompetitorID = p2.PlatformID
WHERE p1.Name = 'PlayStation';

UPDATE Platforms p1
JOIN Platforms p2 ON p2.Name = 'PlayStation'
SET p1.CompetitorID = p2.PlatformID
WHERE p1.Name = 'Nintendo 64';


# Dreamcast VS PlayStation 2
UPDATE Platforms p1
JOIN Platforms p2 ON p2.Name = 'PlayStation 2'
SET p1.CompetitorID = p2.PlatformID
WHERE p1.Name = 'Dreamcast';

UPDATE Platforms p1
JOIN Platforms p2 ON p2.Name = 'Dreamcast'
SET p1.CompetitorID = p2.PlatformID
WHERE p1.Name = 'PlayStation 2';

# Creating VS view:
CREATE VIEW PlatformRivalriesView AS
SELECT 
    p1.Name AS Platform,
    p2.Name AS Competitor
FROM Platforms p1
JOIN Platforms p2 ON p1.CompetitorID = p2.PlatformID
WHERE p1.PlatformID < p2.PlatformID;

