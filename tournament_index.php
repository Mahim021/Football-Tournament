<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Football Tournament Manager</title>
<link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="container">
    <header>
        <h1>⚽ Football Tournament Manager</h1>
        <nav>
            <button class="nav-btn active" onclick="showSection('teams')">Teams</button>
            <button class="nav-btn" onclick="showSection('players')">Players</button>
            <button class="nav-btn" onclick="showSection('matches')">Matches</button>
            <button class="nav-btn" onclick="showSection('standings')">Standings</button>
            <button class="nav-btn" onclick="showSection('statistics')">Statistics</button>
        </nav>
    </header>

    <!-- Teams Section -->
    <section id="teams-section" class="content-section active">
        <h2>All Teams</h2>
        <div class="filter-bar">
            <input type="text" id="teamSearch" placeholder="Search teams..." onkeyup="searchTeams()">
            <select id="leagueFilter" onchange="filterByLeague()">
                <option value="">All Leagues</option>
            </select>
        </div>
        <div id="teams-content" class="data-container"></div>
    </section>

    <!-- Players Section -->
    <section id="players-section" class="content-section">
        <h2>All Players</h2>
        <div class="filter-bar">
            <input type="text" id="playerSearch" placeholder="Search players..." onkeyup="searchPlayers()">
            <select id="positionFilter" onchange="filterByPosition()">
                <option value="">All Positions</option>
                <option value="Forward">Forwards</option>
                <option value="Midfielder">Midfielders</option>
                <option value="Defender">Defenders</option>
                <option value="Goalkeeper">Goalkeepers</option>
            </select>
            <select id="teamFilterPlayers" onchange="filterPlayersByTeam()">
                <option value="">All Teams</option>
            </select>
        </div>
        <div id="players-content" class="data-container"></div>
    </section>

    <!-- Matches Section -->
    <section id="matches-section" class="content-section">
        <h2>Recent Matches</h2>
        <div class="filter-bar">
            <select id="tournamentFilter" onchange="filterByTournament()">
                <option value="">All Tournaments</option>
            </select>
        </div>
        <div id="matches-content" class="data-container"></div>
    </section>

    <!-- Standings Section -->
    <section id="standings-section" class="content-section">
        <h2>Team Standings</h2>
        <div id="standings-content" class="data-container"></div>
    </section>

    <!-- Statistics Section -->
    <section id="statistics-section" class="content-section">
        <h2>Tournament Statistics</h2>
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Top Scorers</h3>
                <div id="topScorers"></div>
            </div>
            <div class="stat-card">
                <h3>Best Goalkeepers</h3>
                <div id="bestGK"></div>
            </div>
            <div class="stat-card">
                <h3>Youngest Players</h3>
                <div id="youngPlayers"></div>
            </div>
            <div class="stat-card">
                <h3>Match Statistics</h3>
                <div id="matchStats"></div>
            </div>
        </div>
    </section>
</div>

<script src="script.js"></script>
</body>
</html>
