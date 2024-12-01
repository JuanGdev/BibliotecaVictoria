<?php
include 'config/conexion.php';
session_start();

header('Content-Type: application/json');

if (!isset($_SESSION['usuario_id'])) {
    echo json_encode(["status" => "error", "message" => "Usuario no autenticado"]);
    exit();
}

$usuario_id = $_SESSION['usuario_id'];

$sql = "SELECT h.prestamo_id, l.titulo, l.autor, h.fecha_prestamo, h.fecha_devolucion, 
        h.fecha_limite, h.estado_prestamo 
        FROM historialprestamos h 
        JOIN libros l ON h.libro_id = l.libro_id 
        WHERE h.usuario_id = ? 
        ORDER BY h.fecha_prestamo DESC";

$stmt = $conexion->prepare($sql);
$stmt->bind_param("i", $usuario_id);
$stmt->execute();
$result = $stmt->get_result();

$loans = [];
while ($row = $result->fetch_assoc()) {
    $loans[] = $row;
}

echo json_encode($loans);

$stmt->close();
$conexion->close();
?>