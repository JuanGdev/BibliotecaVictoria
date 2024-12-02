<?php
include 'config/conexion.php';

header('Content-Type: application/json');

session_start();

if (!isset($_SESSION['usuario_id'])) {
    error_log("El usuario no está autenticado.");
    echo json_encode(["status" => "error", "message" => "El usuario no está autenticado."]);
    exit();
}

$data = json_decode(file_get_contents('php://input'), true);
error_log("Received data: " . print_r($data, true)); // Add this line to log the received data

if (isset($data['libro_id'])) {
    $libro_id = $data['libro_id'];
    $usuario_id = $_SESSION['usuario_id'];

    $sql = "INSERT INTO historialprestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, fecha_limite, estado_prestamo) VALUES (?, ?, NULL, NULL, NULL, 'pendiente')";
    $stmt = $conexion->prepare($sql);
    $stmt->bind_param("ii", $libro_id, $usuario_id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Préstamo creado exitosamente."]);
    } else {
        error_log("Error al ejecutar la consulta: " . $stmt->error);
        echo json_encode(["status" => "error", "message" => "Error al crear el préstamo."]);
    }

    $stmt->close();
} else {
    error_log("No se proporcionó el ID del libro.");
    echo json_encode(["status" => "error", "message" => "No se proporcionó el ID del libro."]);
}

$conexion->close();
?>
