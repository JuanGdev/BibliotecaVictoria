
<?php
include 'config/conexion.php';

$sql = "SELECT * FROM libros";
$result = $conexion->query($sql);

$books = array();
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $books[] = $row;
    }
}

header('Content-Type: application/json');
echo json_encode($books);

$conexion->close();
?>