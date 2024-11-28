
<?php
include 'config/conexion.php';

$libro_id = $_POST['libro_id'];
$titulo = $_POST['titulo'];
$autor = $_POST['autor'];
$genero = $_POST['genero'];
$editorial = $_POST['editorial'];
$edicion = $_POST['edicion'];
$isbn = $_POST['isbn'];
$ano_publicacion = $_POST['ano_publicacion'];
$idioma = $_POST['idioma'];
$estado = $_POST['estado'];
$cantidad = $_POST['cantidad'];

$sql = "UPDATE libros SET titulo='$titulo', autor='$autor', genero='$genero', editorial='$editorial', edicion='$edicion', ISBN='$isbn', ano_publicacion='$ano_publicacion', idioma='$idioma', estado='$estado', cantidad='$cantidad' WHERE libro_id='$libro_id'";
if ($conexion->query($sql) === TRUE) {
    echo json_encode(['status' => 'success', 'message' => 'Libro actualizado exitosamente']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error al actualizar libro']);
}

$conexion->close();
?>