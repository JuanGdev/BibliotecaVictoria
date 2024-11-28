
<?php
include 'config/conexion.php';

$libro_id = $_GET['id'];

$sql = "SELECT * FROM libros WHERE libro_id = $libro_id";
$result = $conexion->query($sql);

if ($result->num_rows > 0) {
    $book = $result->fetch_assoc();
    echo json_encode($book);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Libro no encontrado']);
}

$conexion->close();
?>