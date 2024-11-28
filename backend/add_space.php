
<?php
$servername = "localhost";
$username = "root";
$password = "root"; // Add your MySQL root password here
$dbname = "biblioteca";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$nombre_espacio = $_POST['nombre_espacio'];
$tipo_espacio = $_POST['tipo_espacio'];
$capacidad = $_POST['capacidad'];
$ubicacion = $_POST['ubicacion'];
$descripcion = $_POST['descripcion'];
$equipamiento = $_POST['equipamiento'];
$disponibilidad = $_POST['disponibilidad'];

$sql = "INSERT INTO espacios (nombre_espacio, tipo_espacio, capacidad, ubicacion, descripcion, equipamiento, disponibilidad) VALUES ('$nombre_espacio', '$tipo_espacio', $capacidad, '$ubicacion', '$descripcion', '$equipamiento', '$disponibilidad')";

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