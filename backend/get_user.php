
<?php
include 'config/conexion.php';

$usuario_id = $_GET['id'];

$sql = "SELECT * FROM usuarios WHERE usuario_id = $usuario_id";
$result = $conexion->query($sql);

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    echo json_encode($user);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Usuario no encontrado']);
}

$conexion->close();
?>