-- Football Tournament Database Setup (MySQL Compatible)
-- Run this script in phpMyAdmin after creating the database

-- Drop existing tables if they exist
DROP TABLE IF EXISTS Goal;
DROP TABLE IF EXISTS CleanSheet;
DROP TABLE IF EXISTS TournamentMatch;
DROP TABLE IF EXISTS Game;
DROP TABLE IF EXISTS Ranking;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS Tournament;

-- Create Tournament table
CREATE TABLE Tournament (
    tournament_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    host_country VARCHAR(50) NOT NULL
);

-- Create Team table
CREATE TABLE Team (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    coach_name VARCHAR(50),
    founded_year INT,
    league_name VARCHAR(50),
    home_stadium VARCHAR(100)
);

-- Create Player table
CREATE TABLE Player (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    position VARCHAR(20),
    team_id INT,
    CONSTRAINT fk_player_team FOREIGN KEY (team_id) REFERENCES Team(team_id) ON DELETE SET NULL
);

-- Create Game table (matches)
CREATE TABLE Game (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    date_match DATE NOT NULL,
    location VARCHAR(100),
    team1_id INT NOT NULL,
    team2_id INT NOT NULL,
    score_team1 INT DEFAULT 0,
    score_team2 INT DEFAULT 0,
    CONSTRAINT fk_match_team1 FOREIGN KEY (team1_id) REFERENCES Team(team_id),
    CONSTRAINT fk_match_team2 FOREIGN KEY (team2_id) REFERENCES Team(team_id),
    CONSTRAINT chk_different_teams CHECK (team1_id <> team2_id)
);

-- Create TournamentMatch junction table
CREATE TABLE TournamentMatch (
    tournament_id INT,
    game_id INT,
    PRIMARY KEY (tournament_id, game_id),
    CONSTRAINT fk_tm_tournament FOREIGN KEY (tournament_id) REFERENCES Tournament(tournament_id) ON DELETE CASCADE,
    CONSTRAINT fk_tm_game FOREIGN KEY (game_id) REFERENCES Game(game_id) ON DELETE CASCADE
);

-- Create Goal table
CREATE TABLE Goal (
    goal_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT NOT NULL,
    scorer_id INT,
    assist_id INT,
    minute_scored INT,
    CONSTRAINT fk_goal_game FOREIGN KEY (game_id) REFERENCES Game(game_id) ON DELETE CASCADE,
    CONSTRAINT fk_goal_scorer FOREIGN KEY (scorer_id) REFERENCES Player(player_id) ON DELETE SET NULL,
    CONSTRAINT fk_goal_assist FOREIGN KEY (assist_id) REFERENCES Player(player_id) ON DELETE SET NULL
);

-- Create CleanSheet table
CREATE TABLE CleanSheet (
    cs_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT NOT NULL,
    goalkeeper_id INT,
    CONSTRAINT fk_cs_game FOREIGN KEY (game_id) REFERENCES Game(game_id) ON DELETE CASCADE,
    CONSTRAINT fk_cs_goalkeeper FOREIGN KEY (goalkeeper_id) REFERENCES Player(player_id) ON DELETE SET NULL
);

-- Create Ranking table
CREATE TABLE Ranking (
    ranking_id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT NOT NULL,
    tournament_id INT,
    games_played INT DEFAULT 0,
    wins INT DEFAULT 0,
    draws INT DEFAULT 0,
    losses INT DEFAULT 0,
    goals_for INT DEFAULT 0,
    goals_against INT DEFAULT 0,
    points INT DEFAULT 0,
    CONSTRAINT fk_ranking_team FOREIGN KEY (team_id) REFERENCES Team(team_id) ON DELETE CASCADE,
    CONSTRAINT fk_ranking_tournament FOREIGN KEY (tournament_id) REFERENCES Tournament(tournament_id) ON DELETE CASCADE,
    CONSTRAINT uk_team_tournament UNIQUE (team_id, tournament_id)
);

-- Insert Tournaments
INSERT INTO Tournament (tournament_id, name, year, host_country) VALUES 
(1, 'FIFA World Cup 2022', 2022, 'Qatar'),
(2, 'UEFA Champions League 2023-24', 2024, 'Various'),
(3, 'Premier League 2023-24', 2024, 'England'),
(4, 'La Liga 2023-24', 2024, 'Spain');

-- Insert Teams
INSERT INTO Team (team_id, name, coach_name, founded_year, league_name, home_stadium) VALUES
(1, 'Manchester City', 'Pep Guardiola', 1880, 'Premier League', 'Etihad Stadium'),
(2, 'Real Madrid', 'Carlo Ancelotti', 1902, 'La Liga', 'Santiago Bernabéu'),
(3, 'FC Barcelona', 'Xavi Hernández', 1899, 'La Liga', 'Spotify Camp Nou'),
(4, 'Bayern Munich', 'Thomas Tuchel', 1900, 'Bundesliga', 'Allianz Arena'),
(5, 'Paris Saint-Germain', 'Luis Enrique', 1970, 'Ligue 1', 'Parc des Princes'),
(6, 'Liverpool', 'Jürgen Klopp', 1892, 'Premier League', 'Anfield'),
(7, 'Argentina', 'Lionel Scaloni', 1893, 'CONMEBOL', 'Estadio Monumental'),
(8, 'France', 'Didier Deschamps', 1904, 'UEFA', 'Stade de France'),
(9, 'Brazil', 'Dorival Junior', 1914, 'CONMEBOL', 'Maracanã'),
(10, 'England', 'Gareth Southgate', 1863, 'UEFA', 'Wembley Stadium');

-- Insert Players for Manchester City
INSERT INTO Player (player_id, name, date_of_birth, position, team_id) VALUES
(1, 'Ederson', '1993-08-17', 'Goalkeeper', 1),
(2, 'Kyle Walker', '1990-05-28', 'Defender', 1),
(3, 'Rúben Dias', '1997-05-14', 'Defender', 1),
(4, 'Kevin De Bruyne', '1991-06-28', 'Midfielder', 1),
(5, 'Erling Haaland', '2000-07-21', 'Forward', 1),
(6, 'Phil Foden', '2000-05-28', 'Midfielder', 1),
(7, 'Bernardo Silva', '1994-08-10', 'Midfielder', 1);

-- Insert Players for Real Madrid
INSERT INTO Player (player_id, name, date_of_birth, position, team_id) VALUES
(8, 'Thibaut Courtois', '1992-05-11', 'Goalkeeper', 2),
(9, 'Dani Carvajal', '1992-01-11', 'Defender', 2),
(10, 'David Alaba', '1992-06-24', 'Defender', 2),
(11, 'Luka Modrić', '1985-09-09', 'Midfielder', 2),
(12, 'Jude Bellingham', '2003-06-29', 'Midfielder', 2),
(13, 'Vinícius Júnior', '2000-07-12', 'Forward', 2),
(14, 'Rodrygo', '2001-01-09', 'Forward', 2);

-- Insert Players for FC Barcelona
INSERT INTO Player (player_id, name, date_of_birth, position, team_id) VALUES
(15, 'Marc-André ter Stegen', '1992-04-30', 'Goalkeeper', 3),
(16, 'João Cancelo', '1994-05-27', 'Defender', 3),
(17, 'Ronald Araújo', '1999-03-07', 'Defender', 3),
(18, 'Pedri', '2002-11-25', 'Midfielder', 3),
(19, 'Gavi', '2004-08-05', 'Midfielder', 3),
(20, 'Robert Lewandowski', '1988-08-21', 'Forward', 3),
(21, 'Lamine Yamal', '2007-07-13', 'Forward', 3);

-- Insert Players for Bayern Munich
INSERT INTO Player (player_id, name, date_of_birth, position, team_id) VALUES
(22, 'Manuel Neuer', '1986-03-27', 'Goalkeeper', 4),
(23, 'Joshua Kimmich', '1995-02-08', 'Defender', 4),
(24, 'Matthijs de Ligt', '1999-08-12', 'Defender', 4),
(25, 'Jamal Musiala', '2003-02-26', 'Midfielder', 4),
(26, 'Thomas Müller', '1989-09-13', 'Midfielder', 4),
(27, 'Harry Kane', '1993-07-28', 'Forward', 4),
(28, 'Leroy Sané', '1996-01-11', 'Forward', 4);

-- Insert Players for Paris Saint-Germain
INSERT INTO Player (player_id, name, date_of_birth, position, team_id) VALUES
(29, 'Gianluigi Donnarumma', '1999-02-25', 'Goalkeeper', 5),
(30, 'Achraf Hakimi', '1998-11-04', 'Defender', 5),
(31, 'Marquinhos', '1994-05-14', 'Defender', 5),
(32, 'Warren Zaïre-Emery', '2006-03-08', 'Midfielder', 5),
(33, 'Vitinha', '2000-02-13', 'Midfielder', 5),
(34, 'Kylian Mbappé', '1998-12-20', 'Forward', 5),
(35, 'Ousmane Dembélé', '1997-05-15', 'Forward', 5);

-- Insert Players for Liverpool
INSERT INTO Player (player_id, name, date_of_birth, position, team_id) VALUES
(36, 'Alisson Becker', '1992-10-02', 'Goalkeeper', 6),
(37, 'Virgil van Dijk', '1991-07-08', 'Defender', 6),
(38, 'Trent Alexander-Arnold', '1998-10-07', 'Defender', 6),
(39, 'Mohamed Salah', '1992-06-15', 'Forward', 6),
(40, 'Darwin Núñez', '1999-06-24', 'Forward', 6),
(41, 'Dominik Szoboszlai', '2000-10-25', 'Midfielder', 6),
(42, 'Luis Díaz', '1997-01-13', 'Forward', 6);

-- Insert Players for Argentina
INSERT INTO Player (player_id, name, date_of_birth, position, team_id) VALUES
(43, 'Emiliano Martínez', '1992-09-02', 'Goalkeeper', 7),
(44, 'Nicolás Otamendi', '1988-02-12', 'Defender', 7),
(45, 'Cristian Romero', '1998-04-27', 'Defender', 7),
(46, 'Lionel Messi', '1987-06-24', 'Forward', 7),
(47, 'Ángel Di María', '1988-02-14', 'Forward', 7),
(48, 'Enzo Fernández', '2001-01-17', 'Midfielder', 7),
(49, 'Julián Álvarez', '2000-01-31', 'Forward', 7);

-- Insert Players for France
INSERT INTO Player (player_id, name, date_of_birth, position, team_id) VALUES
(50, 'Mike Maignan', '1995-07-03', 'Goalkeeper', 8),
(51, 'Theo Hernández', '1997-10-06', 'Defender', 8),
(52, 'Ibrahima Konaté', '1999-05-25', 'Defender', 8),
(53, 'Antoine Griezmann', '1991-03-21', 'Forward', 8),
(54, 'Olivier Giroud', '1986-09-30', 'Forward', 8),
(55, 'Eduardo Camavinga', '2002-11-10', 'Midfielder', 8),
(56, 'Randal Kolo Muani', '1998-12-05', 'Forward', 8);

-- Insert Players for Brazil
INSERT INTO Player (player_id, name, date_of_birth, position, team_id) VALUES
(57, 'Alisson', '1992-10-02', 'Goalkeeper', 9),
(58, 'Danilo', '1991-07-15', 'Defender', 9),
(59, 'Marquinhos', '1994-05-14', 'Defender', 9),
(60, 'Casemiro', '1992-02-23', 'Midfielder', 9),
(61, 'Neymar Jr', '1992-02-05', 'Forward', 9),
(62, 'Vinícius Jr', '2000-07-12', 'Forward', 9),
(63, 'Rodrygo', '2001-01-09', 'Forward', 9);

-- Insert Players for England
INSERT INTO Player (player_id, name, date_of_birth, position, team_id) VALUES
(64, 'Jordan Pickford', '1994-03-07', 'Goalkeeper', 10),
(65, 'Harry Maguire', '1993-03-05', 'Defender', 10),
(66, 'John Stones', '1994-05-28', 'Defender', 10),
(67, 'Jude Bellingham', '2003-06-29', 'Midfielder', 10),
(68, 'Harry Kane', '1993-07-28', 'Forward', 10),
(69, 'Bukayo Saka', '2001-09-05', 'Forward', 10),
(70, 'Phil Foden', '2000-05-28', 'Midfielder', 10);

-- Insert Matches
INSERT INTO Game (game_id, date_match, location, team1_id, team2_id, score_team1, score_team2) VALUES
(1, '2024-04-09', 'Santiago Bernabéu', 2, 4, 2, 2),
(2, '2024-04-10', 'Etihad Stadium', 1, 3, 3, 2),
(3, '2024-04-16', 'Allianz Arena', 4, 2, 1, 2),
(4, '2024-04-17', 'Spotify Camp Nou', 3, 1, 1, 4),
(5, '2024-03-10', 'Anfield', 6, 1, 1, 1),
(6, '2024-03-16', 'Etihad Stadium', 1, 6, 2, 1),
(7, '2022-12-18', 'Lusail Stadium', 7, 8, 3, 3),
(8, '2022-12-14', 'Al Bayt Stadium', 9, 8, 0, 1);

-- Insert Tournament Matches
INSERT INTO TournamentMatch (tournament_id, game_id) VALUES
(1, 7), (1, 8),
(2, 1), (2, 2), (2, 3), (2, 4),
(3, 5), (3, 6);

-- Insert Goals
INSERT INTO Goal (goal_id, game_id, scorer_id, assist_id, minute_scored) VALUES
(1, 1, 13, 14, 24),
(2, 1, 27, NULL, 53),
(3, 1, 14, 13, 65),
(4, 1, 28, NULL, 82),
(5, 2, 5, 4, 12),
(6, 2, 20, NULL, 33),
(7, 2, 6, 7, 51),
(8, 2, 21, NULL, 67),
(9, 2, 5, 6, 78),
(10, 7, 46, 47, 23),
(11, 7, 47, NULL, 36),
(12, 7, 34, 56, 80),
(13, 7, 34, NULL, 81),
(14, 7, 46, NULL, 108),
(15, 7, 34, NULL, 118);

-- Insert Clean Sheets
INSERT INTO CleanSheet (cs_id, game_id, goalkeeper_id) VALUES
(1, 3, 22),
(2, 5, 36),
(3, 8, 50);

-- Insert Rankings
INSERT INTO Ranking (ranking_id, team_id, tournament_id, games_played, wins, draws, losses, goals_for, goals_against, points) VALUES
(1, 2, 2, 6, 4, 2, 0, 15, 8, 14),
(2, 1, 2, 6, 3, 2, 1, 12, 9, 11),
(3, 4, 2, 6, 3, 1, 2, 10, 8, 10),
(4, 3, 2, 6, 2, 1, 3, 9, 12, 7),
(5, 1, 3, 28, 20, 5, 3, 65, 25, 65),
(6, 6, 3, 28, 18, 7, 3, 60, 28, 61);

-- Verify data insertion
SELECT 'Tournaments' as TableName, COUNT(*) as RecordCount FROM Tournament
UNION ALL
SELECT 'Teams', COUNT(*) FROM Team
UNION ALL
SELECT 'Players', COUNT(*) FROM Player
UNION ALL
SELECT 'Games', COUNT(*) FROM Game
UNION ALL
SELECT 'Goals', COUNT(*) FROM Goal
UNION ALL
SELECT 'Clean Sheets', COUNT(*) FROM CleanSheet
UNION ALL
SELECT 'Rankings', COUNT(*) FROM Ranking;
