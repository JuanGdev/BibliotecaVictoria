<?php
include 'config/conexion.php';

header('Content-Type: application/json');

$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['id'], $data['fecha_prestamo'], $data['fecha_limite'], $data['estado'])) {
    $id = $data['id'];
    $fecha_prestamo = $data['fecha_prestamo'];
    $fecha_devolucion = $data['fecha_devolucion'] ?? null;
    $fecha_limite = $data['fecha_limite'];
    $estado = $data['estado'];

    $sql = "UPDATE historialprestamos SET fecha_prestamo = ?, fecha_devolucion = ?, fecha_limite = ?, estado_prestamo = ? WHERE prestamo_id = ?";
    $stmt = $conexion->prepare($sql);
    $stmt->bind_param("ssssi", $fecha_prestamo, $fecha_devolucion, $fecha_limite, $estado, $id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Préstamo actualizado correctamente."]);
    } else {
        error_log("Error executing query: " . $stmt->error);
        http_response_code(500);
        echo json_encode(["status" => "error", "message" => "Error al actualizar el préstamo."]);
    }

    $stmt->close();
} else {
    error_log("Incomplete data: " . json_encode($data));
    http_response_code(400);
    echo json_encode(["status" => "error", "message" => "Datos incompletos."]);
}

$conexion->close();
?>