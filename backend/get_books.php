<?php
include 'config/conexion.php';

$sql = "SELECT * FROM libros";
$result = $conexion->query($sql);

$books = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $books[] = $row;
    }
}

echo json_encode($books);
$conexion->close();
?>