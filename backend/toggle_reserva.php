<?php
$servername = "localhost";
$username = "root";
$password = "root"; // Add your MySQL root password here
$dbname = "biblioteca";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$action = $_GET['action'];
$espacio_id = $_GET['espacio_id'];

if ($action === 'reservar') {
    $sql = "UPDATE espacios SET disponibilidad='ocupado' WHERE espacio_id=$espacio_id";
} else if ($action === 'liberar') {
    $sql = "UPDATE espacios SET disponibilidad='disponible' WHERE espacio_id=$espacio_id";
}

$response = array();
if ($conn->query($sql) === TRUE) {
    $response['success'] = true;
} else {
    $response['success'] = false;
}

$conn->close();

header('Content-Type: application/json');
echo json_encode($response);
?>