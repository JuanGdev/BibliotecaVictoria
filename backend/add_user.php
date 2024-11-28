<?php
include 'config/conexion.php';

$nombre = $_POST['nombre'];
$apellidos = $_POST['apellidos'];
$fecha_nacimiento = $_POST['fecha_nacimiento'];
$telefono = $_POST['telefono'];
$direccion = $_POST['direccion'];
$identificacion = $_POST['identificacion'];
$comprobante_domicilio = $_POST['comprobante_domicilio'];
$fecha_registro = $_POST['fecha_registro'];
$correo = $_POST['correo'];
$estatus = $_POST['estatus'];
$registro_caducado = isset($_POST['registro_caducado']) ? 1 : 0;
$contrasena = $_POST['contrasena'];
$tipo_usuario = $_POST['tipo_usuario'];

$sql = "INSERT INTO usuarios (nombre, apellidos, fecha_nacimiento, telefono, direccion, identificacion, comprobante_domicilio, fecha_registro, correo, estatus, registro_caducado, contrasena, tipo_usuario) VALUES ('$nombre', '$apellidos', '$fecha_nacimiento', '$telefono', '$direccion', '$identificacion', '$comprobante_domicilio', '$fecha_registro', '$correo', '$estatus', '$registro_caducado', '$contrasena', '$tipo_usuario')";
if ($conexion->query($sql) === TRUE) {
    echo json_encode(['status' => 'success', 'message' => 'Usuario agregado exitosamente']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error al agregar usuario']);
}

$conexion->close();
?>