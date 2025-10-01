-- Football Tournament Database Setup
-- Run this script in Oracle SQL Developer or similar tool

-- Drop existing tables if they exist (for development)
DROP TABLE Goal;
DROP TABLE CleanSheet;
DROP TABLE TournamentMatch;
DROP TABLE Match;
DROP TABLE Ranking;
DROP TABLE Player;
DROP TABLE Team;
DROP TABLE Tournament;
-- Create Tournament table
-- Create Tournament table


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

-- Create Matches table (renamed because MATCH is reserved in MySQL)
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

-- ✅ Now your INSERTs will also work in MySQL

-- ✅ Now your INSERTs will also work in MySQL


INSERT INTO Tournament VALUES (1, 'FIFA World Cup 2022', 2022, 'Qatar');
INSERT INTO Tournament VALUES (2, 'UEFA Champions League 2023-24', 2024, 'Various');
INSERT INTO Tournament VALUES (3, 'Premier League 2023-24', 2024, 'England');
INSERT INTO Tournament VALUES (4, 'La Liga 2023-24', 2024, 'Spain');

-- Insert Teams (Real clubs and national teams)
INSERT INTO Team VALUES (1, 'Manchester City', 'Pep Guardiola', 1880, 'Premier League', 'Etihad Stadium');
INSERT INTO Team VALUES (2, 'Real Madrid', 'Carlo Ancelotti', 1902, 'La Liga', 'Santiago Bernabéu');
INSERT INTO Team VALUES (3, 'FC Barcelona', 'Xavi Hernández', 1899, 'La Liga', 'Spotify Camp Nou');
INSERT INTO Team VALUES (4, 'Bayern Munich', 'Thomas Tuchel', 1900, 'Bundesliga', 'Allianz Arena');
INSERT INTO Team VALUES (5, 'Paris Saint-Germain', 'Luis Enrique', 1970, 'Ligue 1', 'Parc des Princes');
INSERT INTO Team VALUES (6, 'Liverpool', 'Jürgen Klopp', 1892, 'Premier League', 'Anfield');
INSERT INTO Team VALUES (7, 'Argentina', 'Lionel Scaloni', 1893, 'CONMEBOL', 'Estadio Monumental');
INSERT INTO Team VALUES (8, 'France', 'Didier Deschamps', 1904, 'UEFA', 'Stade de France');
INSERT INTO Team VALUES (9, 'Brazil', 'Dorival Junior', 1914, 'CONMEBOL', 'Maracanã');
INSERT INTO Team VALUES (10, 'England', 'Gareth Southgate', 1863, 'UEFA', 'Wembley Stadium');

-- Insert Players for Manchester City
INSERT INTO Player VALUES (1, 'Ederson', DATE '1993-08-17', 'Goalkeeper', 1);
INSERT INTO Player VALUES (2, 'Kyle Walker', DATE '1990-05-28', 'Defender', 1);
INSERT INTO Player VALUES (3, 'Rúben Dias', DATE '1997-05-14', 'Defender', 1);
INSERT INTO Player VALUES (4, 'Kevin De Bruyne', DATE '1991-06-28', 'Midfielder', 1);
INSERT INTO Player VALUES (5, 'Erling Haaland', DATE '2000-07-21', 'Forward', 1);
INSERT INTO Player VALUES (6, 'Phil Foden', DATE '2000-05-28', 'Midfielder', 1);
INSERT INTO Player VALUES (7, 'Bernardo Silva', DATE '1994-08-10', 'Midfielder', 1);

-- Insert Players for Real Madrid
INSERT INTO Player VALUES (8, 'Thibaut Courtois', DATE '1992-05-11', 'Goalkeeper', 2);
INSERT INTO Player VALUES (9, 'Dani Carvajal', DATE '1992-01-11', 'Defender', 2);
INSERT INTO Player VALUES (10, 'David Alaba', DATE '1992-06-24', 'Defender', 2);
INSERT INTO Player VALUES (11, 'Luka Modrić', DATE '1985-09-09', 'Midfielder', 2);
INSERT INTO Player VALUES (12, 'Jude Bellingham', DATE '2003-06-29', 'Midfielder', 2);
INSERT INTO Player VALUES (13, 'Vinícius Júnior', DATE '2000-07-12', 'Forward', 2);
INSERT INTO Player VALUES (14, 'Rodrygo', DATE '2001-01-09', 'Forward', 2);

-- Insert Players for FC Barcelona
INSERT INTO Player VALUES (15, 'Marc-André ter Stegen', DATE '1992-04-30', 'Goalkeeper', 3);
INSERT INTO Player VALUES (16, 'João Cancelo', DATE '1994-05-27', 'Defender', 3);
INSERT INTO Player VALUES (17, 'Ronald Araújo', DATE '1999-03-07', 'Defender', 3);
INSERT INTO Player VALUES (18, 'Pedri', DATE '2002-11-25', 'Midfielder', 3);
INSERT INTO Player VALUES (19, 'Gavi', DATE '2004-08-05', 'Midfielder', 3);
INSERT INTO Player VALUES (20, 'Robert Lewandowski', DATE '1988-08-21', 'Forward', 3);
INSERT INTO Player VALUES (21, 'Lamine Yamal', DATE '2007-07-13', 'Forward', 3);

-- Insert Players for Bayern Munich
INSERT INTO Player VALUES (22, 'Manuel Neuer', DATE '1986-03-27', 'Goalkeeper', 4);
INSERT INTO Player VALUES (23, 'Joshua Kimmich', DATE '1995-02-08', 'Defender', 4);
INSERT INTO Player VALUES (24, 'Matthijs de Ligt', DATE '1999-08-12', 'Defender', 4);
INSERT INTO Player VALUES (25, 'Jamal Musiala', DATE '2003-02-26', 'Midfielder', 4);
INSERT INTO Player VALUES (26, 'Thomas Müller', DATE '1989-09-13', 'Midfielder', 4);
INSERT INTO Player VALUES (27, 'Harry Kane', DATE '1993-07-28', 'Forward', 4);
INSERT INTO Player VALUES (28, 'Leroy Sané', DATE '1996-01-11', 'Forward', 4);

-- Insert Players for Paris Saint-Germain
INSERT INTO Player VALUES (29, 'Gianluigi Donnarumma', DATE '1999-02-25', 'Goalkeeper', 5);
INSERT INTO Player VALUES (30, 'Achraf Hakimi', DATE '1998-11-04', 'Defender', 5);
INSERT INTO Player VALUES (31, 'Marquinhos', DATE '1994-05-14', 'Defender', 5);
INSERT INTO Player VALUES (32, 'Warren Zaïre-Emery', DATE '2006-03-08', 'Midfielder', 5);
INSERT INTO Player VALUES (33, 'Vitinha', DATE '2000-02-13', 'Midfielder', 5);
INSERT INTO Player VALUES (34, 'Kylian Mbappé', DATE '1998-12-20', 'Forward', 5);
INSERT INTO Player VALUES (35, 'Ousmane Dembélé', DATE '1997-05-15', 'Forward', 5);

-- Insert Players for Liverpool
INSERT INTO Player VALUES (36, 'Alisson Becker', DATE '1992-10-02', 'Goalkeeper', 6);
INSERT INTO Player VALUES (37, 'Virgil van Dijk', DATE '1991-07-08', 'Defender', 6);
INSERT INTO Player VALUES (38, 'Trent Alexander-Arnold', DATE '1998-10-07', 'Defender', 6);
INSERT INTO Player VALUES (39, 'Mohamed Salah', DATE '1992-06-15', 'Forward', 6);
INSERT INTO Player VALUES (40, 'Darwin Núñez', DATE '1999-06-24', 'Forward', 6);
INSERT INTO Player VALUES (41, 'Dominik Szoboszlai', DATE '2000-10-25', 'Midfielder', 6);
INSERT INTO Player VALUES (42, 'Luis Díaz', DATE '1997-01-13', 'Forward', 6);

-- Insert Players for Argentina (National Team)
INSERT INTO Player VALUES (43, 'Emiliano Martínez', DATE '1992-09-02', 'Goalkeeper', 7);
INSERT INTO Player VALUES (44, 'Nicolás Otamendi', DATE '1988-02-12', 'Defender', 7);
INSERT INTO Player VALUES (45, 'Cristian Romero', DATE '1998-04-27', 'Defender', 7);
INSERT INTO Player VALUES (46, 'Lionel Messi', DATE '1987-06-24', 'Forward', 7);
INSERT INTO Player VALUES (47, 'Ángel Di María', DATE '1988-02-14', 'Forward', 7);
INSERT INTO Player VALUES (48, 'Enzo Fernández', DATE '2001-01-17', 'Midfielder', 7);
INSERT INTO Player VALUES (49, 'Julián Álvarez', DATE '2000-01-31', 'Forward', 7);

-- Insert Players for France (National Team)
INSERT INTO Player VALUES (50, 'Mike Maignan', DATE '1995-07-03', 'Goalkeeper', 8);
INSERT INTO Player VALUES (51, 'Theo Hernández', DATE '1997-10-06', 'Defender', 8);
INSERT INTO Player VALUES (52, 'Ibrahima Konaté', DATE '1999-05-25', 'Defender', 8);
INSERT INTO Player VALUES (53, 'Antoine Griezmann', DATE '1991-03-21', 'Forward', 8);
INSERT INTO Player VALUES (54, 'Olivier Giroud', DATE '1986-09-30', 'Forward', 8);
INSERT INTO Player VALUES (55, 'Eduardo Camavinga', DATE '2002-11-10', 'Midfielder', 8);
INSERT INTO Player VALUES (56, 'Randal Kolo Muani', DATE '1998-12-05', 'Forward', 8);

-- Insert Players for Brazil (National Team)
INSERT INTO Player VALUES (57, 'Alisson Becker', DATE '1992-10-02', 'Goalkeeper', 9);
INSERT INTO Player VALUES (58, 'Danilo', DATE '1991-07-15', 'Defender', 9);
INSERT INTO Player VALUES (59, 'Marquinhos', DATE '1994-05-14', 'Defender', 9);
INSERT INTO Player VALUES (60, 'Casemiro', DATE '1992-02-23', 'Midfielder', 9);
INSERT INTO Player VALUES (61, 'Neymar Jr', DATE '1992-02-05', 'Forward', 9);
INSERT INTO Player VALUES (62, 'Vinícius Júnior', DATE '2000-07-12', 'Forward', 9);
INSERT INTO Player VALUES (63, 'Rodrygo', DATE '2001-01-09', 'Forward', 9);

-- Insert Players for England (National Team)
INSERT INTO Player VALUES (64, 'Jordan Pickford', DATE '1994-03-07', 'Goalkeeper', 10);
INSERT INTO Player VALUES (65, 'Harry Maguire', DATE '1993-03-05', 'Defender', 10);
INSERT INTO Player VALUES (66, 'John Stones', DATE '1994-05-28', 'Defender', 10);
INSERT INTO Player VALUES (67, 'Jude Bellingham', DATE '2003-06-29', 'Midfielder', 10);
INSERT INTO Player VALUES (68, 'Harry Kane', DATE '1993-07-28', 'Forward', 10);
INSERT INTO Player VALUES (69, 'Bukayo Saka', DATE '2001-09-05', 'Forward', 10);
INSERT INTO Player VALUES (70, 'Phil Foden', DATE '2000-05-28', 'Midfielder', 10);

-- Insert Sample Matches (Champions League fixtures)
INSERT INTO GAME VALUES (1, DATE '2024-04-09', 'Santiago Bernabéu', 2, 4, 2, 2);
INSERT INTO GAME VALUES (2, DATE '2024-04-10', 'Etihad Stadium', 1, 3, 3, 2);
INSERT INTO GAME VALUES (3, DATE '2024-04-16', 'Allianz Arena', 4, 2, 1, 2);
INSERT INTO GAME VALUES (4, DATE '2024-04-17', 'Spotify Camp Nou', 3, 1, 1, 4);
INSERT INTO GAME VALUES (5, DATE '2024-03-10', 'Anfield', 6, 1, 1, 1);
INSERT INTO GAME VALUES (6, DATE '2024-03-16', 'Etihad Stadium', 1, 6, 2, 1);
INSERT INTO GAME VALUES (7, DATE '2022-12-18', 'Lusail Stadium', 7, 8, 3, 3);
INSERT INTO GAME VALUES (8, DATE '2022-12-14', 'Al Bayt Stadium', 9, 8, 0, 1);

-- FIFA World Cup 2022
INSERT INTO TournamentMatch VALUES (1, 7); -- Argentina vs France (final)
INSERT INTO TournamentMatch VALUES (1, 8); -- Brazil vs France (semifinal)

-- UEFA Champions League 2023-24
INSERT INTO TournamentMatch VALUES (2, 1); -- Real Madrid vs Bayern
INSERT INTO TournamentMatch VALUES (2, 2); -- Man City vs Barcelona
INSERT INTO TournamentMatch VALUES (2, 3); -- Bayern vs Real Madrid
INSERT INTO TournamentMatch VALUES (2, 4); -- Barcelona vs Man City

-- Premier League 2023-24
INSERT INTO TournamentMatch VALUES (3, 5); -- Liverpool vs Man City
INSERT INTO TournamentMatch VALUES (3, 6); -- Man City vs Liverpool;

-- Insert Goals for matches
INSERT INTO Goal VALUES (1, 1, 13, 14, 24);
INSERT INTO Goal VALUES (2, 1, 27, NULL, 53);
INSERT INTO Goal VALUES (3, 1, 14, 13, 65);
INSERT INTO Goal VALUES (4, 1, 28, NULL, 82);
INSERT INTO Goal VALUES (5, 2, 5, 4, 12);
INSERT INTO Goal VALUES (6, 2, 20, NULL, 33);
INSERT INTO Goal VALUES (7, 2, 6, 7, 51);
INSERT INTO Goal VALUES (8, 2, 21, NULL, 67);
INSERT INTO Goal VALUES (9, 2, 5, 6, 78);
INSERT INTO Goal VALUES (10, 7, 46, 47, 23);
INSERT INTO Goal VALUES (11, 7, 47, NULL, 36);
INSERT INTO Goal VALUES (12, 7, 34, 56, 80);
INSERT INTO Goal VALUES (13, 7, 34, NULL, 81);
INSERT INTO Goal VALUES (14, 7, 46, NULL, 108);
INSERT INTO Goal VALUES (15, 7, 34, NULL, 118);

-- Insert Clean Sheets
INSERT INTO CleanSheet VALUES (1, 3, 22);
INSERT INTO CleanSheet VALUES (2, 5, 36);
INSERT INTO CleanSheet VALUES (3, 8, 50);

-- Insert initial rankings for Champions League
INSERT INTO Ranking VALUES (1, 2, 1, 6, 4, 2, 0, 15, 8, 14);
INSERT INTO Ranking VALUES (2, 2, 2, 6, 3, 2, 1, 12, 9, 11);
INSERT INTO Ranking VALUES (3, 2, 4, 6, 3, 1, 2, 10, 8, 10);
INSERT INTO Ranking VALUES (4, 2, 3, 6, 2, 1, 3, 9, 12, 7);
INSERT INTO Ranking VALUES (5, 3, 1, 28, 20, 5, 3, 65, 25, 65);
INSERT INTO Ranking VALUES (6, 3, 6, 28, 18, 7, 3, 60, 28, 61);

-- Check total counts
SELECT 'Tournaments' as type, COUNT(*) as count FROM Tournament
UNION ALL
SELECT 'Teams', COUNT(*) FROM Team
UNION ALL
SELECT 'Players', COUNT(*) FROM Player
UNION ALL
SELECT 'Game', COUNT(*) FROM Game
UNION ALL
SELECT 'Goals', COUNT(*) FROM Goal
UNION ALL
SELECT 'Clean Sheets', COUNT(*) FROM CleanSheet
UNION ALL
SELECT 'Rankings', COUNT(*) FROM Ranking;