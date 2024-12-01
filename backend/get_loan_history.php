<?php
include 'config/conexion.php';

header('Content-Type: application/json');

$sql = "SELECT historialprestamos.prestamo_id AS id, historialprestamos.usuario_id AS usuario, 
        CONCAT(libros.titulo, ' - ', libros.autor) AS libro, historialprestamos.fecha_prestamo, 
        historialprestamos.fecha_devolucion, historialprestamos.fecha_limite, historialprestamos.estado_prestamo AS estado 
        FROM historialprestamos 
        JOIN libros ON historialprestamos.libro_id = libros.libro_id";
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