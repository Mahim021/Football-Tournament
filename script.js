/**
 * FOOTBALL TOURNAMENT DATABASE - SQL JOIN QUERIES DEMONSTRATION
 * Lab 06: Advanced SQL Joins Implementation
 * 
 * This file contains various types of SQL JOIN operations as per Lab 06 requirements:
 * 
 * JOIN TYPES IMPLEMENTED:
 * =======================
 * 1. INNER JOIN - Returns only matching records from both tables
 *    - Used in: loadMatches() - Multiple INNER JOINs with same table (team)
 *    - Used in: loadStandings() - Join ranking with team
 *    - Used in: loadTopScorers() - Three-way join (goal -> player -> team)
 *    - Used in: loadBestGoalkeepers() - Three-way join (cleansheet -> player -> team)
 * 
 * 2. LEFT OUTER JOIN (LEFT JOIN) - Returns all records from left table and matched from right
 *    - Used in: loadPlayers() - Get all players with optional team info
 *    - Used in: filterByPosition() - Filter players while keeping team info
 *    - Used in: filterPlayersByTeam() - Filter by team with player info
 *    - Used in: loadYoungestPlayers() - Include players without teams (free agents)
 *    - Used in: loadMatches() - Get tournament info (optional)
 * 
 * 3. AGGREGATE FUNCTIONS WITH JOINS:
 *    - COUNT() - Count goals, clean sheets, matches
 *    - AVG() - Calculate average goals per match
 *    - MAX() - Find highest scoring match
 *    - SUM() - Total goals in all matches
 *    - GROUP BY - Group results by player, team, etc.
 * 
 * 4. MULTIPLE TABLE JOINS:
 *    - Two-table joins: player-team, ranking-team, game-team
 *    - Three-table joins: goal-player-team, cleansheet-player-team
 *    - Self-join concept: Joining team table twice (t1, t2) for home/away teams
 * 
 * 5. MIXED JOIN TYPES:
 *    - INNER JOIN + LEFT JOIN in same query (loadMatches function)
 *    - Ensures critical data exists while optional data can be NULL
 * 
 * ADDITIONAL SQL CONCEPTS:
 * ========================
 * - WHERE clauses with joins for filtering
 * - ORDER BY for sorting results
 * - LIMIT for restricting result count
 * - Calculated columns (goal_difference = goals_for - goals_against)
 * - Column aliases (AS keyword)
 * - DISTINCT for unique values
 */

let allTeams = [];
let allPlayers = [];
let allMatches = [];
document.addEventListener("DOMContentLoaded", function () {
  console.log("App loaded");
  loadTeams();
  loadLeaguesFilter();
  loadTeamsFilter();
  loadTournamentsFilter();
});
function showSection(e) {
  console.log("Switch to:", e);
  document
    .querySelectorAll(".content-section")
    .forEach((e) => e.classList.remove("active"));
  document
    .querySelectorAll(".nav-btn")
    .forEach((e) => e.classList.remove("active"));
  let t = document.getElementById(e + "-section");
  t && t.classList.add("active");
  event.target.classList.add("active");
  switch (e) {
    case "teams":
      loadTeams();
      break;
    case "players":
      loadPlayers();
      break;
    case "matches":
      loadMatches();
      break;
    case "standings":
      loadStandings();
      break;
    case "statistics":
      loadStatistics();
  }
}
function loadTeams() {
  // SQL Query Type: Simple SELECT
  // Purpose: Retrieve all teams without any joins
  executeQuery("SELECT * FROM team ORDER BY name", function (e) {
    console.log("Teams:", e.length);
    allTeams = e;
    displayTeams(e);
  });
}
function displayTeams(e) {
  let t = document.getElementById("teams-content");
  if (!e || 0 === e.length) {
    t.innerHTML = '<div class="empty-state"><p>No teams found</p></div>';
    return;
  }
  let a = "";
  e.forEach((e) => {
    a += `<div class="card"><div class="card-header"><div class="card-title">${
      e.name || "N/A"
    }</div><div class="card-badge">${
      e.league_name || "N/A"
    }</div></div><div class="card-details"><p><strong>Coach:</strong> ${
      e.coach_name || "N/A"
    }</p><p><strong>Founded:</strong> ${
      e.founded_year || "N/A"
    }</p><p><strong>Stadium:</strong> ${
      e.home_stadium || "N/A"
    }</p></div></div>`;
  });
  t.innerHTML = a;
}
function loadLeaguesFilter() {
  // SQL Query Type: SELECT DISTINCT (no join needed)
  // Lab 06: DISTINCT keyword to get unique league names
  // Purpose: Get all unique leagues for filter dropdown
  executeQuery(
    "SELECT DISTINCT league_name FROM team WHERE league_name IS NOT NULL ORDER BY league_name",
    function (e) {
      let t = document.getElementById("leagueFilter");
      t &&
        e.forEach((e) => {
          let a = document.createElement("option");
          a.value = e.league_name;
          a.textContent = e.league_name;
          t.appendChild(a);
        });
    }
  );
}
function searchTeams() {
  let e = document.getElementById("teamSearch").value.toLowerCase(),
    t = allTeams.filter(
      (t) =>
        (t.name && t.name.toLowerCase().includes(e)) ||
        (t.coach_name && t.coach_name.toLowerCase().includes(e))
    );
  displayTeams(t);
}
function filterByLeague() {
  let e = document.getElementById("leagueFilter").value;
  if (!e) {
    displayTeams(allTeams);
    return;
  }
  executeQuery(
    `SELECT * FROM team WHERE league_name='${e}' ORDER BY name`,
    displayTeams
  );
}
function loadPlayers() {
  // SQL Query Type: LEFT OUTER JOIN (LEFT JOIN)
  // Lab 06: Join Type 1 - LEFT JOIN
  // Purpose: Get all players with their team names. Players without teams (NULL team_id) are also included.
  // Syntax: LEFT JOIN returns all records from left table (player) and matched records from right table (team)
  // Result: If player has no team, team_name will be NULL
  executeQuery(
    "SELECT p.*, t.name as team_name FROM player p LEFT JOIN team t ON p.team_id = t.team_id ORDER BY p.name",
    function (e) {
      console.log("Players:", e.length);
      allPlayers = e;
      displayPlayers(e);
    }
  );
}
function displayPlayers(e) {
  let t = document.getElementById("players-content");
  if (!e || 0 === e.length) {
    t.innerHTML = '<div class="empty-state"><p>No players found</p></div>';
    return;
  }
  let a = "";
  e.forEach((e) => {
    let t = calculateAge(e.date_of_birth);
    a += `<div class="card"><div class="card-header"><div class="card-title">${
      e.name || "N/A"
    }</div><div class="card-badge">${
      e.position || "N/A"
    }</div></div><div class="card-details"><p><strong>Team:</strong> ${
      e.team_name || "Free Agent"
    }</p><p><strong>Age:</strong> ${t} years</p><p><strong>Birth:</strong> ${formatDate(
      e.date_of_birth
    )}</p></div></div>`;
  });
  t.innerHTML = a;
}
function filterByPosition() {
  let e = document.getElementById("positionFilter").value;
  if (!e) {
    displayPlayers(allPlayers);
    return;
  }
  // SQL Query Type: LEFT OUTER JOIN with WHERE clause
  // Lab 06: LEFT JOIN with filtering
  // Purpose: Filter players by position while maintaining left join to show team info
  executeQuery(
    `SELECT p.*, t.name as team_name FROM player p LEFT JOIN team t ON p.team_id = t.team_id WHERE p.position = '${e}' ORDER BY p.name`,
    displayPlayers
  );
}
function searchPlayers() {
  let e = document.getElementById("playerSearch").value.toLowerCase(),
    t = allPlayers.filter(
      (t) =>
        (t.name && t.name.toLowerCase().includes(e)) ||
        (t.team_name && t.team_name.toLowerCase().includes(e))
    );
  displayPlayers(t);
}
function loadTeamsFilter() {
  // SQL Query Type: Simple SELECT for dropdown population
  // Purpose: Load team names for filter dropdown
  executeQuery("SELECT team_id, name FROM team ORDER BY name", function (e) {
    let t = document.getElementById("teamFilterPlayers");
    t &&
      e.forEach((e) => {
        let a = document.createElement("option");
        a.value = e.team_id;
        a.textContent = e.name;
        t.appendChild(a);
      });
  });
}
function filterPlayersByTeam() {
  let e = document.getElementById("teamFilterPlayers").value;
  if (!e) {
    displayPlayers(allPlayers);
    return;
  }
  // SQL Query Type: LEFT OUTER JOIN with WHERE clause
  // Lab 06: LEFT JOIN with team filtering
  // Purpose: Show all players from a specific team
  executeQuery(
    `SELECT p.*, t.name as team_name FROM player p LEFT JOIN team t ON p.team_id = t.team_id WHERE p.team_id = ${e} ORDER BY p.name`,
    displayPlayers
  );
}
function loadMatches() {
  // SQL Query Type: MULTIPLE INNER JOINs + LEFT JOIN
  // Lab 06: Join Type 2 - INNER JOIN (Multiple times)
  // Lab 06: Join Type 3 - Mixed INNER and LEFT JOIN
  // Purpose: Get match details with team names from both sides
  // - INNER JOIN with team t1: Gets first team's name (team1_id must exist)
  // - INNER JOIN with team t2: Gets second team's name (team2_id must exist)
  // - LEFT JOIN with tournamentmatch: Gets tournament info if match is part of tournament (optional)
  // This demonstrates joining the same table (team) twice with different aliases
  executeQuery(
    "SELECT g.*, t1.name as team1_name, t2.name as team2_name, tm.tournament_id " +
    "FROM game g " +
    "INNER JOIN team t1 ON g.team1_id = t1.team_id " +
    "INNER JOIN team t2 ON g.team2_id = t2.team_id " +
    "LEFT JOIN tournamentmatch tm ON g.game_id = tm.game_id " +
    "ORDER BY g.date_match DESC",
    function (e) {
      console.log("Matches:", e.length);
      allMatches = e;
      displayMatches(e);
    }
  );
}
function displayMatches(e) {
  let t = document.getElementById("matches-content");
  if (!e || 0 === e.length) {
    t.innerHTML = '<div class="empty-state"><p>No matches found</p></div>';
    return;
  }
  let a = "";
  e.forEach((e) => {
    a += `<div class="match-card"><div class="match-header">${formatDate(
      e.date_match
    )}  ${
      e.location || "N/A"
    }</div><div class="match-teams"><div class="team-info"><div class="team-name">${
      e.team1_name
    }</div><div class="team-score">${
      e.score_team1
    }</div></div><div class="match-vs">VS</div><div class="team-info"><div class="team-name">${
      e.team2_name
    }</div><div class="team-score">${e.score_team2}</div></div></div></div>`;
  });
  t.innerHTML = a;
}
function loadTournamentsFilter() {
  // SQL Query Type: Simple SELECT for dropdown
  // Purpose: Load tournament list for match filtering
  executeQuery(
    "SELECT tournament_id, name FROM tournament ORDER BY year DESC",
    function (e) {
      let t = document.getElementById("tournamentFilter");
      t &&
        e.forEach((e) => {
          let a = document.createElement("option");
          a.value = e.tournament_id;
          a.textContent = e.name;
          t.appendChild(a);
        });
    }
  );
}
function filterByTournament() {
  let e = document.getElementById("tournamentFilter").value;
  if (!e) {
    displayMatches(allMatches);
    return;
  }
  let t = allMatches.filter((t) => t.tournament_id == e);
  displayMatches(t);
}
function loadStandings() {
  // SQL Query Type: INNER JOIN with calculated columns
  // Lab 06: Join Type 4 - INNER JOIN with arithmetic operations
  // Purpose: Get team standings with calculated goal difference
  // INNER JOIN ensures only teams with ranking data are shown
  // Calculated field: (goals_for - goals_against) as goal_difference
  executeQuery(
    "SELECT t.name as team_name, r.*, (r.goals_for - r.goals_against) as goal_difference " +
    "FROM ranking r " +
    "INNER JOIN team t ON r.team_id = t.team_id " +
    "ORDER BY r.points DESC, goal_difference DESC",
    function (e) {
      console.log("Standings:", e.length);
      displayStandings(e);
    }
  );
}
function displayStandings(e) {
  let t = document.getElementById("standings-content");
  if (!e || 0 === e.length) {
    t.innerHTML = '<div class="empty-state"><p>No standings</p></div>';
    return;
  }
  let a =
    "<table><thead><tr><th>#</th><th>Team</th><th>Played</th><th>Won</th><th>Draw</th><th>Lost</th><th>GF</th><th>GA</th><th>GD</th><th>Points</th></tr></thead><tbody>";
  e.forEach((e, t) => {
    a += `<tr><td class="rank-col">${t + 1}</td><td><strong>${
      e.team_name
    }</strong></td><td>${e.games_played}</td><td>${e.wins}</td><td>${
      e.draws
    }</td><td>${e.losses}</td><td>${e.goals_for}</td><td>${
      e.goals_against
    }</td><td>${e.goal_difference}</td><td><strong>${
      e.points
    }</strong></td></tr>`;
  });
  a += "</tbody></table>";
  t.innerHTML = a;
}
function loadStatistics() {
  loadTopScorers();
  loadBestGoalkeepers();
  loadYoungestPlayers();
  loadMatchStats();
}
function loadTopScorers() {
  // SQL Query Type: INNER JOIN with aggregate function (COUNT) and GROUP BY
  // Lab 06: Join Type 5 - INNER JOIN with aggregation
  // Purpose: Get top goal scorers with their team information
  // Three-way INNER JOIN:
  // 1. goal -> player: Match goals to player who scored
  // 2. player -> team: Match player to their team
  // GROUP BY: Groups goals by player to count total goals per player
  // COUNT(): Aggregates number of goals for each player
  executeQuery(
    "SELECT p.name as player_name, t.name as team_name, COUNT(g.goal_id) as goals " +
    "FROM goal g " +
    "INNER JOIN player p ON g.scorer_id = p.player_id " +
    "INNER JOIN team t ON p.team_id = t.team_id " +
    "GROUP BY g.scorer_id, p.name, t.name " +
    "ORDER BY goals DESC " +
    "LIMIT 10",
    function (e) {
      let t = document.getElementById("topScorers");
      if (!t) return;
      let a = "";
      e.forEach((e) => {
        a += `<div class="stat-item"><span class="stat-label">${e.player_name} (${e.team_name})</span><span class="stat-value">${e.goals} goals</span></div>`;
      });
      t.innerHTML = a || '<p style="color:#999">No data</p>';
    }
  );
}
function loadBestGoalkeepers() {
  // SQL Query Type: INNER JOIN with COUNT and GROUP BY
  // Lab 06: Join Type 6 - Three-table INNER JOIN with aggregation
  // Purpose: Find goalkeepers with most clean sheets
  // Three-way INNER JOIN:
  // 1. cleansheet -> player: Match clean sheets to goalkeeper
  // 2. player -> team: Match goalkeeper to their team
  // Only goalkeepers with at least one clean sheet are shown (INNER JOIN behavior)
  executeQuery(
    "SELECT p.name as player_name, t.name as team_name, COUNT(cs.cs_id) as clean_sheets " +
    "FROM cleansheet cs " +
    "INNER JOIN player p ON cs.goalkeeper_id = p.player_id " +
    "INNER JOIN team t ON p.team_id = t.team_id " +
    "GROUP BY cs.goalkeeper_id, p.name, t.name " +
    "ORDER BY clean_sheets DESC " +
    "LIMIT 10",
    function (e) {
      let t = document.getElementById("bestGK");
      if (!t) return;
      let a = "";
      e.forEach((e) => {
        a += `<div class="stat-item"><span class="stat-label">${e.player_name} (${e.team_name})</span><span class="stat-value">${e.clean_sheets} CS</span></div>`;
      });
      t.innerHTML = a || '<p style="color:#999">No data</p>';
    }
  );
}
function loadYoungestPlayers() {
  // SQL Query Type: LEFT OUTER JOIN with WHERE and ORDER BY
  // Lab 06: Join Type 7 - LEFT JOIN to include players without teams
  // Purpose: Find youngest players (including free agents)
  // LEFT JOIN ensures players without team_id are still shown
  // WHERE clause filters out players with NULL birth dates
  // ORDER BY date_of_birth DESC puts youngest (most recent birth dates) first
  executeQuery(
    "SELECT p.name as player_name, p.date_of_birth, t.name as team_name " +
    "FROM player p " +
    "LEFT JOIN team t ON p.team_id = t.team_id " +
    "WHERE p.date_of_birth IS NOT NULL " +
    "ORDER BY p.date_of_birth DESC " +
    "LIMIT 10",
    function (e) {
      let t = document.getElementById("youngPlayers");
      if (!t) return;
      let a = "";
      e.forEach((e) => {
        let t = calculateAge(e.date_of_birth);
        a += `<div class="stat-item"><span class="stat-label">${
          e.player_name
        } (${
          e.team_name || "N/A"
        })</span><span class="stat-value">${t} years</span></div>`;
      });
      t.innerHTML = a || '<p style="color:#999">No data</p>';
    }
  );
}
function loadMatchStats() {
  // SQL Query Type: Aggregate functions without JOIN
  // Lab 06: Aggregate Functions - COUNT(), AVG(), MAX(), SUM()
  // Purpose: Calculate overall match statistics
  // COUNT(*): Total number of matches
  // AVG(): Average goals per match
  // MAX(): Highest scoring match
  // SUM(): Total goals scored in all matches
  executeQuery(
    "SELECT COUNT(*) as total_matches, " +
    "AVG(score_team1 + score_team2) as avg_goals, " +
    "MAX(score_team1 + score_team2) as highest_scoring, " +
    "SUM(score_team1 + score_team2) as total_goals " +
    "FROM game",
    function (e) {
      let t = document.getElementById("matchStats");
      if (!t || !e || 0 === e.length) return;
      let a = e[0],
        n = `<div class="stat-item"><span class="stat-label">Total Matches</span><span class="stat-value">${
          a.total_matches
        }</span></div><div class="stat-item"><span class="stat-label">Total Goals</span><span class="stat-value">${
          a.total_goals || 0
        }</span></div><div class="stat-item"><span class="stat-label">Avg Goals/Match</span><span class="stat-value">${parseFloat(
          a.avg_goals || 0
        ).toFixed(
          2
        )}</span></div><div class="stat-item"><span class="stat-label">Highest Scoring</span><span class="stat-value">${
          a.highest_scoring || 0
        } goals</span></div>`;
      t.innerHTML = n;
    }
  );
}
function executeQuery(e, t) {
  console.log("Query:", e);
  fetch("api.php?action=query", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ query: e }),
  })
    .then((e) => e.json())
    .then((e) => {
      if (e.error) {
        console.error("Error:", e.error);
        alert("Database Error: " + e.error);
        return;
      }
      console.log("Result:", e);
      t(e);
    })
    .catch((e) => {
      console.error("Fetch error:", e);
      alert("Connection Error: " + e.message);
    });
}
function calculateAge(e) {
  if (!e) return "N/A";
  let t = new Date(),
    a = new Date(e),
    n = t.getFullYear() - a.getFullYear(),
    r = t.getMonth() - a.getMonth();
  return (r < 0 || (0 === r && t.getDate() < a.getDate())) && n--, n;
}
function formatDate(e) {
  if (!e) return "N/A";
  let t = new Date(e);
  return t.toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
}
