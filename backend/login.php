<?php
session_start();
include 'config/conexion.php';

$email = $_POST['email'];
$password = $_POST['password'];

$sql = "SELECT * FROM usuarios WHERE correo = '$email'";
$result = $conexion->query($sql);

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    if ($password === $user['contrasena']) {
        $_SESSION['user'] = $user;
        echo json_encode(['status' => 'success', 'message' => 'Login exitoso', 'user' => $user, 'user_type' => $user['tipo_usuario']]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Correo o contraseña incorrectos']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Correo o contraseña incorrectos']);
}

$conexion->close();
?>
