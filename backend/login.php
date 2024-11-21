<?php
include 'config/conexion.php';

$email = $_POST['email'];
$password = $_POST['password'];

$sql = "SELECT * FROM usuarios WHERE correo = '$email' AND contrasena = '$password'";
$result = $conexion->query($sql);

if ($result->num_rows > 0) {
    echo json_encode(['status' => 'success', 'message' => 'Login exitoso']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Correo o contraseña incorrectos']);
}

$conexion->close();
?>
