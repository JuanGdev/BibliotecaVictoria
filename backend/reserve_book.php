<?php
session_start();
include 'config/conexion.php';

header('Content-Type: application/json');

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_SESSION['usuario_id'])) {
    $usuario_id = $_SESSION['usuario_id'];
    $libro_id = $_POST['libro_id'];
    $fecha_prestamo = date("Y-m-d");
    $fecha_devolucion = date("Y-m-d", strtotime($fecha_prestamo . ' + 7 days'));
    $fecha_limite = $_POST['fecha_limite'];
    $estado_prestamo = 'pendiente';

    $sql = "INSERT INTO historialprestamos (usuario_id, libro_id, fecha_prestamo, fecha_devolucion, fecha_limite, estado_prestamo) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $conexion->prepare($sql);
    $stmt->bind_param("iissss", $usuario_id, $libro_id, $fecha_prestamo, $fecha_devolucion, $fecha_limite, $estado_prestamo);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Reserva realizada con éxito."]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error al realizar la reserva."]);
    }

    $stmt->close();
}
$conexion->close();
?>