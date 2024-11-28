
<?php
include 'config/conexion.php';

$libro_id = $_GET['id'];

$sql = "DELETE FROM libros WHERE libro_id = $libro_id";
if ($conexion->query($sql) === TRUE) {
    echo json_encode(['status' => 'success', 'message' => 'Libro eliminado exitosamente']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error al eliminar libro']);
}

$conexion->close();
?>