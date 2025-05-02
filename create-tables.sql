USE games;

CREATE TABLE Platforms (
  PlatformID INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  UNIQUE (Name)
);

CREATE TABLE Genres (
  GenreID INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  UNIQUE (Name)
);

CREATE TABLE Games (
  GameID INT AUTO_INCREMENT PRIMARY KEY,
  Title VARCHAR(255) NOT NULL,
  ReleaseYear YEAR,
  MobyScore DECIMAL(4,2),
  URL VARCHAR(512),
  UNIQUE (Title, ReleaseYear)
);

CREATE TABLE GamePlatforms (
  GameID INT NOT NULL,
  PlatformID INT NOT NULL,
  PRIMARY KEY (GameID, PlatformID),
  FOREIGN KEY (GameID) REFERENCES Games(GameID),
  FOREIGN KEY (PlatformID) REFERENCES Platforms(PlatformID)
);

CREATE TABLE GameGenres (
  GameID INT NOT NULL,
  GenreID INT NOT NULL,
  PRIMARY KEY (GameID, GenreID),
  FOREIGN KEY (GameID) REFERENCES Games(GameID),
  FOREIGN KEY (GenreID) REFERENCES Genres(GenreID)
);