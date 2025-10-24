<?php
/**
 * API for handling SQL queries
 * Simple backend for Football Tournament Database
 */

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Database configuration
define('DB_HOST', 'localhost');
define('DB_NAME', 'football_tournament_db');
define('DB_USER', 'root');
define('DB_PASS', '');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

try {
    // Create database connection
    $conn = new PDO(
        "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4",
        DB_USER,
        DB_PASS
    );
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

} catch(PDOException $e) {
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}

// Get action from URL
$action = $_GET['action'] ?? '';

// Get JSON input
$input = json_decode(file_get_contents('php://input'), true);

try {
    if ($action === 'query') {
        $query = $input['query'] ?? '';
        
        if (empty($query)) {
            throw new Exception('No query provided');
        }
        
        // Execute query
        $stmt = $conn->prepare($query);
        $stmt->execute();
        
        // Fetch results
        $results = $stmt->fetchAll();
        
        echo json_encode($results);
        
    } else {
        echo json_encode(['error' => 'Invalid action']);
    }
    
} catch(PDOException $e) {
    echo json_encode(['error' => 'Query error: ' . $e->getMessage()]);
} catch(Exception $e) {
    echo json_encode(['error' => $e->getMessage()]);
}
?>
