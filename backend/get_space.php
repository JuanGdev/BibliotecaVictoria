
<?php
$servername = "localhost";
$username = "root";
$password = "root"; // Add your MySQL root password here
$dbname = "biblioteca";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$espacio_id = $_GET['id'];
$sql = "SELECT * FROM espacios WHERE espacio_id = $espacio_id";
$result = $conn->query($sql);

$espacio = $result->fetch_assoc();

$conn->close();

header('Content-Type: application/json');
echo json_encode($espacio);
?>