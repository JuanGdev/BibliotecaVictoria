<?php
session_start();
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
$usuario_id = $_SESSION['user']['usuario_id']; // Obtener el usuario_id de la sesión

if ($action === 'reservar') {
    $sql = "INSERT INTO reservasespacios (usuario_id, espacio_id, fecha_reserva, hora_inicio, hora_fin, estatus_reserva) VALUES ($usuario_id, $espacio_id, CURDATE(), '09:00:00', '10:00:00', 'reservado')";
} else if ($action === 'liberar') {
    $sql = "DELETE FROM reservasespacios WHERE usuario_id = $usuario_id AND espacio_id = $espacio_id";
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