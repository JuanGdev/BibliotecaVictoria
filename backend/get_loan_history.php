<?php
include 'config/conexion.php';

header('Content-Type: application/json');

$sql = "SELECT prestamo_id AS id, usuario_id AS usuario, libro_id AS libro, fecha_prestamo, fecha_devolucion, fecha_limite, estado_prestamo AS estado FROM historialprestamos";
$result = $conexion->query($sql);

$loanHistory = [];

if ($result) {
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $loanHistory[] = $row;
        }
    }
    echo json_encode($loanHistory);
} else {
    error_log("Database query error: " . $conexion->error);
    http_response_code(500);
    echo json_encode(["status" => "error", "message" => "Error al consultar la base de datos."]);
}

$conexion->close();
?>