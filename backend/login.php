<?php
session_start();
include 'config/conexion.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $correo = $_POST['email'];
    $contrasena = $_POST['password'];

    try {
        $sql = "SELECT usuario_id, nombre, apellidos, direccion, correo, contrasena, tipo_usuario FROM usuarios WHERE correo = ?";
        $stmt = $conexion->prepare($sql);
        $stmt->bind_param("s", $correo);
        $stmt->execute();
        $stmt->store_result();
        $stmt->bind_result($usuario_id, $nombre, $apellidos, $direccion, $correo, $hashed_password, $tipo_usuario);
        $stmt->fetch();

        if ($stmt->num_rows > 0) {
            if (password_verify($contrasena, $hashed_password)) {
                $_SESSION['usuario_id'] = $usuario_id;
                $_SESSION['nombre'] = $nombre;
                $_SESSION['apellidos'] = $apellidos;
                $_SESSION['direccion'] = $direccion;
                $_SESSION['correo'] = $correo;

                $user = [
                    "usuario_id" => $usuario_id,
                    "nombre" => $nombre,
                    "apellidos" => $apellidos,
                    "direccion" => $direccion,
                    "correo" => $correo,
                    "tipo_usuario" => $tipo_usuario
                ];

                if ($correo === 'adminBibliotecaVictoria@gmail.com' && $contrasena === 'Admin1234') {
                    echo json_encode(["status" => "success", "message" => "Login successful", "tipo_usuario" => 'admin', "user" => $user]);
                } else {
                    echo json_encode(["status" => "success", "message" => "Login successful", "tipo_usuario" => $tipo_usuario, "user" => $user]);
                }
            } else {
                echo json_encode(["status" => "error", "message" => "Correo o contraseña incorrectos."]);
            }
        } else {
            echo json_encode(["status" => "error", "message" => "Correo o contraseña incorrectos."]);
        }

        $stmt->close();
    } catch (Exception $e) {
        echo json_encode(["status" => "error", "message" => "Error en el servidor: " . $e->getMessage()]);
    }
}
$conexion->close();
?>
