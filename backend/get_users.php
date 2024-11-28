
<?php
include 'config/conexion.php';

$sql = "SELECT * FROM usuarios";
$result = $conexion->query($sql);

$users = [];
while ($row = $result->fetch_assoc()) {
    $users[] = $row;
}

echo json_encode(['users' => $users]);

$conexion->close();
?>