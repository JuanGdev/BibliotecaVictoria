<?php
include 'config.php';

$libro_id = $_GET['libro_id'];
$sql = "SELECT titulo, autor, editorial, ano_publicacion, edicion, ISBN, sinopsis, cantidad FROM libros WHERE libro_id = ?";
$stmt = $conexion->prepare($sql);
$stmt->bind_param("i", $libro_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode($row);
} else {
    echo json_encode([]);
}

$stmt->close();
$conexion->close();
?>