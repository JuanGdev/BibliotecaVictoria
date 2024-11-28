
<?php
include 'config/conexion.php';

$usuario_id = $_POST['usuario_id'];
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

$sql = "UPDATE usuarios SET nombre='$nombre', apellidos='$apellidos', fecha_nacimiento='$fecha_nacimiento', telefono='$telefono', direccion='$direccion', identificacion='$identificacion', comprobante_domicilio='$comprobante_domicilio', fecha_registro='$fecha_registro', correo='$correo', estatus='$estatus', registro_caducado='$registro_caducado', contrasena='$contrasena', tipo_usuario='$tipo_usuario' WHERE usuario_id='$usuario_id'";
if ($conexion->query($sql) === TRUE) {
    echo json_encode(['status' => 'success', 'message' => 'Usuario actualizado exitosamente']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error al actualizar usuario']);
}

$conexion->close();
?>