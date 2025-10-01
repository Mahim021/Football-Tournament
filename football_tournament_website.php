<?php
$host = "localhost";
$user = "root"; // default XAMPP MySQL user
$pass = "";
$db = "football_tournament_db";

// Connect
$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) die("Connection failed: " . $conn->connect_error);

?>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Football Tournament Management System</title>
  <link rel="stylesheet" href="./styles.css" />
</head>

<body>
  <header class="header">
    <div class="container">
      <h1>Football Tournament Manager</h1>
      <p>Comprehensive SQL Database Management System</p>
    </div>
  </header>

  <nav class="navbar">
    <div class="container">
      <ul class="nav-menu">
        <li>
          <a href="#" class="nav-link active" data-tab="dashboard">Dashboard</a>
        </li>
        <li>
          <a href="https://wikipedia.com" class="nav-link" data-tab="tournaments">Tournaments</a>
        </li>
        <li><a href="#" class="nav-link" data-tab="teams">Teams</a></li>
        <li><a href="#" class="nav-link" data-tab="players">Players</a></li>
        <li><a href="#" class="nav-link" data-tab="matches">Matches</a></li>
        <li>
          <a href="#" class="nav-link" data-tab="statistics">Statistics</a>
        </li>
      </ul>
    </div>
  </nav>

  <main class="container">
    <!-- Dashboard Tab -->
    <section id="dashboard" class="tab-content active">
      <div class="stats-grid">
        <div class="stat-card">
          
          <?php
          $sql = "SELECT COUNT(*) AS tournament_count FROM Tournament";
          // SQL query(Aggregate function COUNT)

          $result = $conn->query($sql);
          $tournament_count = 0;
          if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $tournament_count = $row['tournament_count'];
          }
          echo "<h3>$tournament_count</h3>";
          ?>
          <p>Active Tournaments</p>
        </div>

        <div class="stat-card">
          <?php
          $sql = "SELECT COUNT(*) AS team_count FROM Team";
          // SQL query(Aggregate function COUNT)
          $result = $conn->query($sql);
          $team_count = 0;
          if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $team_count = $row['team_count'];
          }
          echo "<h3>$team_count</h3>";
          ?>
          <p>Registered Teams</p>
        </div>

        <div class="stat-card">
          
          <?php
          $sql = "SELECT COUNT(*) AS player_count FROM Player";
          // SQL query(Aggregate function COUNT)
          $result = $conn->query($sql);
          $player_count = 0;
          if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $player_count = $row['player_count'];
          }
          echo "<h3>$player_count</h3>";
          ?>
          <p>Total Players</p>
        </div>

        <div class="stat-card">
          
          <?php
          $sql = "SELECT COUNT(*) AS game_count FROM Game";
          // SQL query(Aggregate function COUNT)
          $result = $conn->query($sql);
          $game_count = 0;
          if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $game_count = $row['game_count'];
          }
          echo "<h3>$game_count</h3>";
          ?>
          <p>Games Played</p>
        </div>
      </div>

      <div class="card">
        <h2>Database Schema Overview</h2>
        <p>
          This system manages a comprehensive football tournament database
          with the following entities:
        </p>
        <ul>
          <li>
            <strong>Tournament:</strong> Manages tournament information (name,
            year, host country)
          </li>
          <li>
            <strong>Team:</strong> Stores team details (name, coach, founded
            year, league, stadium)
          </li>
          <li><strong>Player:</strong> Player information linked to teams</li>
          <li>
            <strong>Match:</strong> Match details with scores and
            participating teams
          </li>
          <li>
            <strong>Goal:</strong> Goal tracking with scorer and assist
            information
          </li>
          <li><strong>Ranking:</strong> Team standings and statistics</li>
        </ul>
      </div>

      <div class="card">
        <h2>Recent Matches</h2>
        <div class="match-list">
          <div class="match-item">
            <span class="teams">Argentina vs Brazil</span>
            <span class="score">1 - 0</span>
            <span class="details">Copa America 2024 • Hard Rock Stadium</span>
          </div>
          <div class="match-item">
            <span class="teams">France vs Spain</span>
            <span class="score">2 - 1</span>
            <span class="details">UEFA Euro 2024 • Allianz Arena</span>
          </div>
        </div>
      </div>
    </section>

    <!-- Tournaments Tab -->
    <section id="tournaments" class="tab-content">
      <div class="card">
        <h2>Tournament Management</h2>
        <form class="form-grid">
          <div class="form-group">
            <label>Tournament Name</label>
            <input type="text" placeholder="Enter tournament name" />
          </div>
          <div class="form-group">
            <label>Year</label>
            <input type="number" placeholder="2024" />
          </div>
          <div class="form-group">
            <label>Host Country</label>
            <input type="text" placeholder="Enter host country" />
          </div>
        </form>
        <button class="btn btn-primary">Add Tournament</button>
      </div>

      <div class="card">
        <h2>Active Tournaments</h2>
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>Tournament</th>
                <th>Year</th>
                <th>Host Country</th>
                <th>Actions</th>
              </tr>
            </thead>

            <?php
            $sql = "SELECT * FROM Tournament";
            $result = $conn->query($sql);
            if ($result->num_rows > 0) {
              while ($row = $result->fetch_assoc()) {
                echo "<tr>
                      <td>{$row['name']}</td>
                      <td>{$row['year']}</td>
                      <td>{$row['host_country']}</td>
                      <td>
                        <button class='btn btn-sm'>Edit</button>
                        <button class='btn btn-danger btn-sm'>Delete</button>
                      </td>
                    </tr>";
              }
            }
            ?>
          </table>
        </div>
      </div>
    </section>

    <!-- Teams Tab -->
    <section id="teams" class="tab-content">
      <div class="card">
        <h2>Team Management</h2>
        <form class="form-grid">
          <div class="form-group">
            <label>Team Name</label>
            <input type="text" placeholder="Enter team name" />
          </div>
          <div class="form-group">
            <label>Coach Name</label>
            <input type="text" placeholder="Enter coach name" />
          </div>
          <div class="form-group">
            <label>Founded Year</label>
            <input type="number" placeholder="1900" />
          </div>
          <div class="form-group">
            <label>League</label>
            <input type="text" placeholder="Enter league" />
          </div>
        </form>
        <button class="btn btn-primary">Add Team</button>
      </div>

      <div class="card">
        <h2>Teams List</h2>
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>Team</th>
                <th>Coach</th>
                <th>Founded</th>
                <th>League</th>
                <th>Stadium</th>
                <th>Actions</th>
              </tr>
            </thead>

            <?php
            $sql = "SELECT * FROM Team";
            $result = $conn->query($sql);
            if ($result->num_rows > 0) {
              while ($row = $result->fetch_assoc()) {
                echo "<tr>
                      <td>{$row['name']}</td>
                      <td>{$row['coach_name']}</td>
                      <td>{$row['founded_year']}</td>
                      <td>{$row['league_name']}</td>
                      <td>{$row['home_stadium']}</td>
                      <td>
                        <button class='btn btn-sm'>Edit</button>
                        <button class='btn btn-danger btn-sm'>Delete</button>
                      </td>
                    </tr>";
              }
            }
            ?>
          </table>
        </div>
      </div>
    </section>

    <!-- Players Tab -->
    <section id="players" class="tab-content">
      <div class="card">
        <h2>Player Management</h2>
        <form class="form-grid">
          <div class="form-group">
            <label>Player Name</label>
            <input type="text" placeholder="Enter player name" />
          </div>
          <div class="form-group">
            <label>Position</label>
            <select>
              <option>Select Position</option>
              <option>Goalkeeper</option>
              <option>Defender</option>
              <option>Midfielder</option>
              <option>Forward</option>
            </select>
          </div>
          <div class="form-group">
            <label>Team</label>
            <select>
              <option>Select Team</option>
              <option>Argentina</option>
              <option>Brazil</option>
              <option>France</option>
            </select>
          </div>
          <div class="form-group">
            <label>Date of Birth</label>
            <input type="date" />
          </div>
        </form>
        <button class="btn btn-primary">Add Player</button>
      </div>

      <div class="card">
        <h2>Players List</h2>
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>Player</th>
                <th>Date of birth</th>
                <th>Position</th>
                <th>Team ID</th>
                <th>Actions</th>
              </tr>
            </thead>
            
            <?php
            $sql = "SELECT * FROM Player";
            $result = $conn->query($sql);
            if ($result->num_rows > 0) {
              while ($row = $result->fetch_assoc()) {
                echo "<tr>
                      <td>{$row['name']}</td>
                      <td>{$row['date_of_birth']}</td>
                      <td>{$row['position']}</td>
                      <td>{$row['team_id']}</td>
                      <td>
                        <button class='btn btn-sm'>Edit</button>
                        <button class='btn btn-danger btn-sm'>Delete</button>
                      </td>
                    </tr>";
              }
            }
            ?>

          </table>
        </div>
      </div>
    </section>

    <!-- Matches Tab -->
    <section id="matches" class="tab-content">
      <div class="card">
        <h2>Match Management</h2>
        <form class="form-grid">
          <div class="form-group">
            <label>Match Date</label>
            <input type="datetime-local" />
          </div>
          <div class="form-group">
            <label>Location</label>
            <input type="text" placeholder="Enter venue" />
          </div>
          <div class="form-group">
            <label>Team 1</label>
            <select>
              <option>Select Team 1</option>
              <option>Argentina</option>
              <option>Brazil</option>
              <option>France</option>
            </select>
          </div>
          <div class="form-group">
            <label>Team 2</label>
            <select>
              <option>Select Team 2</option>
              <option>Argentina</option>
              <option>Brazil</option>
              <option>France</option>
            </select>
          </div>
        </form>
        <button class="btn btn-primary">Schedule Match</button>
      </div>
    </section>

    <!-- Statistics Tab -->
    <section id="statistics" class="tab-content">
      <div class="card">
        <h2>Tournament Statistics</h2>
        <div class="stats-grid">
          <div class="stat-card secondary">
            <h3>7</h3>
            <p>Total Goals</p>
          </div>
          <div class="stat-card secondary">
            <h3>2.33</h3>
            <p>Avg Goals/Match</p>
          </div>
          <div class="stat-card secondary">
            <h3>1</h3>
            <p>Clean Sheets</p>
          </div>
        </div>
      </div>

      <div class="card">
        <h2>Standings</h2>
        <div class="table-container">
          <table class="data-table">
            <thead>
              <tr>
                <th>Team</th>
                <th>Tournament</th>
                <th>Goals</th>
                <th>Tournament</th>
              </tr>
            </thead>
            
            <?php
            
            ?>

          </table>
        </div>
      </div>
    </section>
  </main>

  <script src="./script.js">
    console.log("Football Tournament Management System Loaded");
  </script>
</body>

</html>