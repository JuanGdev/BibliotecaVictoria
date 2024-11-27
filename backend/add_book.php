<?php
include 'config/conexion.php';

$titulo = $_POST['titulo'];
$autor = $_POST['autor'];
$genero = $_POST['genero'];
$editorial = $_POST['editorial'];
$edicion = $_POST['edicion'];
$isbn = $_POST['isbn'];
$ano_publicacion = $_POST['ano_publicacion'];
$idioma = $_POST['idioma'];
$estado = $_POST['estado'];
$prologo = $_POST['prologo'];
$autor_prologo = $_POST['autor_prologo'];
$cantidad = $_POST['cantidad'];

$sql = "INSERT INTO libros (titulo, autor, genero, editorial, edicion, ISBN, ano_publicacion, idioma, estado, prologo, autor_prologo, cantidad) 
        VALUES ('$titulo', '$autor', '$genero', '$editorial', '$edicion', '$isbn', '$ano_publicacion', '$idioma', '$estado', '$prologo', '$autor_prologo', '$cantidad')";

if ($conexion->query($sql) === TRUE) {
    echo json_encode(['status' => 'success', 'message' => 'Libro agregado exitosamente']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error al agregar el libro: ' . $conexion->error]);
}

$conexion->close();
?>