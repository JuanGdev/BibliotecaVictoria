
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
$nombre_espacio = $_POST['nombre_espacio'];
$tipo_espacio = $_POST['tipo_espacio'];
$capacidad = $_POST['capacidad'];
$ubicacion = $_POST['ubicacion'];
$descripcion = $_POST['descripcion'];
$equipamiento = $_POST['equipamiento'];
$disponibilidad = $_POST['disponibilidad'];

$sql = "UPDATE espacios SET nombre_espacio='$nombre_espacio', tipo_espacio='$tipo_espacio', capacidad=$capacidad, ubicacion='$ubicacion', descripcion='$descripcion', equipamiento='$equipamiento', disponibilidad='$disponibilidad' WHERE espacio_id=$espacio_id";

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