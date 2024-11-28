<?php
$servername = "localhost";
$username = "root";
$password = "root"; // Add your MySQL root password here
$dbname = "biblioteca";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM espacios";
$result = $conn->query($sql);

$espacios = array();
while ($row = $result->fetch_assoc()) {
    $espacios[] = $row;
}

$conn->close();

header('Content-Type: application/json');
echo json_encode($espacios);
?>