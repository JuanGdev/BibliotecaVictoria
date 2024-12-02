
<?php
include 'config.php';

header('Content-Type: application/json');

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $nombre = $_POST['nombre'];
    $apellidos = $_POST['apellidos'];
    $fecha_nacimiento = $_POST['fecha_nacimiento'];
    $telefono = $_POST['telefono'];
    $direccion = $_POST['direccion'];
    $correo = $_POST['correo'];
    $contrasena = password_hash($_POST['contrasena'], PASSWORD_DEFAULT);
    $fecha_registro = date("Y-m-d");
    $estatus = 'Registrado';
    $registro_caducado = 0;
    $tipo_usuario = 'usuario';

    $sql = "INSERT INTO usuarios (nombre, apellidos, fecha_nacimiento, telefono, direccion, correo, contrasena, fecha_registro, estatus, registro_caducado, tipo_usuario) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    $stmt = $conexion->prepare($sql);
    $stmt->bind_param("sssssssssis", $nombre, $apellidos, $fecha_nacimiento, $telefono, $direccion, $correo, $contrasena, $fecha_registro, $estatus, $registro_caducado, $tipo_usuario);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Registro exitoso."]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error al registrar el usuario."]);
    }

    $stmt->close();
}
$conexion->close();
?>