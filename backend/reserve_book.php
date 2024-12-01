<?php
session_start();
include 'config/conexion.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!isset($_SESSION['usuario_id'])) {
        echo json_encode(["status" => "error", "message" => "Usuario no autenticado."]);
        exit();
    }

    $usuario_id = $_SESSION['usuario_id'];
    $data = json_decode(file_get_contents('php://input'), true);

    if (empty($data['libro_ids']) || !is_array($data['libro_ids'])) {
        echo json_encode(["status" => "error", "message" => "No se proporcionaron libros para reservar."]);
        exit();
    }

    $fecha_prestamo = date('Y-m-d');
    $fecha_limite = date('Y-m-d', strtotime('+7 days'));
    $estado_prestamo = 'pendiente';

    $conexion->begin_transaction();

    try {
        $sql = "INSERT INTO historialprestamos (usuario_id, libro_id, fecha_prestamo, fecha_devolucion, fecha_limite, estado_prestamo) VALUES (?, ?, ?, ?, ?, ?)";
        $stmt = $conexion->prepare($sql);

        foreach ($data['libro_ids'] as $libro_id) {
            $fecha_devolucion = date('Y-m-d', strtotime($fecha_prestamo . ' + 7 days'));
            $stmt->bind_param("iissss", $usuario_id, $libro_id, $fecha_prestamo, $fecha_devolucion, $fecha_limite, $estado_prestamo);
            $stmt->execute();
        }

        $conexion->commit();
        echo json_encode(["status" => "success", "message" => "Préstamo realizado con éxito."]);
    } catch (Exception $e) {
        $conexion->rollback();
        echo json_encode(["status" => "error", "message" => "Error al realizar el préstamo: " . $e->getMessage()]);
    }

    $stmt->close();
}
$conexion->close();
?>