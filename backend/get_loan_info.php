<?php
include 'config/conexion.php';

header('Content-Type: application/json');

if (isset($_GET['prestamo_id'])) {
    $prestamo_id = $_GET['prestamo_id'];

    $sql = "SELECT prestamo_id AS id, fecha_prestamo, fecha_devolucion, fecha_limite, estado_prestamo AS estado FROM historialprestamos WHERE prestamo_id = ?";
    $stmt = $conexion->prepare($sql);
    $stmt->bind_param("i", $prestamo_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $loan = $result->fetch_assoc();
        echo json_encode($loan);
    } else {
        echo json_encode(["status" => "error", "message" => "El préstamo no existe."]);
    }

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "No se proporcionó el ID del préstamo."]);
}
$conexion->close();
?>