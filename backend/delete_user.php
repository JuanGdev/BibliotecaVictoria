<?php
include 'config/conexion.php';

$user_id = $_GET['id'];

$sql = "DELETE FROM usuarios WHERE usuario_id = $user_id";
if ($conexion->query($sql) === TRUE) {
    echo json_encode(['status' => 'success', 'message' => 'Usuario eliminado exitosamente']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error al eliminar usuario']);
}

$conexion->close();
?>