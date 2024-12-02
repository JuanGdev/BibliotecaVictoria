<?php
include 'config/conexion.php';

header('Content-Type: application/json');

if (isset($_GET['libro_id'])) {
    $libro_id = $_GET['libro_id'];

    $sql = "SELECT libro_id, titulo, autor FROM libros WHERE libro_id = ?";
    $stmt = $conexion->prepare($sql);
    $stmt->bind_param("i", $libro_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $book = $result->fetch_assoc();
        echo json_encode($book);
    } else {
        echo json_encode(["status" => "error", "message" => "El libro no existe."]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "No se proporcionó el ID del libro."]);
}
$conexion->close();
?>