
<?php
include 'config/conexion.php';

header('Content-Type: application/json');

if (isset($_GET['prestamo_id'])) {
    $prestamo_id = $_GET['prestamo_id'];

    $sql = "DELETE FROM historialprestamos WHERE prestamo_id = ?";
    $stmt = $conexion->prepare($sql);
    $stmt->bind_param("i", $prestamo_id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Préstamo eliminado correctamente."]);
    } else {
        error_log("Error executing query: " . $stmt->error);
        http_response_code(500);
        echo json_encode(["status" => "error", "message" => "Error al eliminar el préstamo."]);
    }

    $stmt->close();
} else {
    error_log("No se proporcionó el ID del préstamo.");
    http_response_code(400);
    echo json_encode(["status" => "error", "message" => "No se proporcionó el ID del préstamo."]);
}

$conexion->close();
?>