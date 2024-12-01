<?php
session_start();
include 'config/conexion.php';

header('Content-Type: application/json');

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $correo = $_POST['correo'];
    $contrasena = $_POST['contrasena'];

    $sql = "SELECT usuario_id, contrasena FROM usuarios WHERE correo = ?";
    $stmt = $conexion->prepare($sql);
    $stmt->bind_param("s", $correo);
    $stmt->execute();
    $stmt->store_result();
    $stmt->bind_result($usuario_id, $hashed_password);
    $stmt->fetch();

    if ($stmt->num_rows > 0 && password_verify($contrasena, $hashed_password)) {
        $_SESSION['usuario_id'] = $usuario_id;
        echo json_encode(["status" => "success", "message" => "Login successful"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Correo o contraseña incorrectos."]);
    }

    $stmt->close();
}
$conexion->close();
?>
