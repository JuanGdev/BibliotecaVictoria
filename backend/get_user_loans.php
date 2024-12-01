<?php
session_start();
include 'config/conexion.php';

header('Content-Type: application/json');

if (isset($_SESSION['usuario_id'])) {
    $usuario_id = $_SESSION['usuario_id'];

    $sql = "SELECT historialprestamos.prestamo_id AS id, 
            libros.libro_id,  // Add this line
            CONCAT(libros.titulo, ' - ', libros.autor) AS libro, 
            historialprestamos.fecha_prestamo, historialprestamos.fecha_devolucion, 
            historialprestamos.fecha_limite, historialprestamos.estado_prestamo AS estado 
            FROM historialprestamos 
            JOIN libros ON historialprestamos.libro_id = libros.libro_id
            WHERE historialprestamos.usuario_id = ?";
    $stmt = $conexion->prepare($sql);
    $stmt->bind_param("i", $usuario_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $loans = [];
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $loans[] = $row;
        }
    }
    echo json_encode($loans);

    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Usuario no autenticado."]);
}
$conexion->close();
?>