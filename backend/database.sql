-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 21, 2024 at 12:40 AM
-- Server version: 5.7.24
-- PHP Version: 8.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `biblioteca`
--

-- --------------------------------------------------------

--
-- Table structure for table `espacios`
--

CREATE TABLE `espacios` (
  `espacio_id` int(11) NOT NULL,
  `tipo_espacio` enum('sala','auditorio','cubiculo','aula') DEFAULT NULL,
  `capacidad` int(11) DEFAULT NULL,
  `descripcion` text,
  `equipamiento` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `eventos`
--

CREATE TABLE `eventos` (
  `evento_id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `nombre_evento` varchar(100) DEFAULT NULL,
  `descripcion` text,
  `cantidad_asistentes` int(11) DEFAULT NULL,
  `fecha_evento` date DEFAULT NULL,
  `hora_inicio` time DEFAULT NULL,
  `hora_fin` time DEFAULT NULL,
  `aprobado` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `historialprestamos`
--

CREATE TABLE `historialprestamos` (
  `prestamo_id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `libro_id` int(11) DEFAULT NULL,
  `fecha_prestamo` date DEFAULT NULL,
  `fecha_devolucion` date DEFAULT NULL,
  `fecha_limite` date DEFAULT NULL,
  `estado_prestamo` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `libros`
--

CREATE TABLE `libros` (
  `libro_id` int(11) NOT NULL,
  `titulo` varchar(100) DEFAULT NULL,
  `autor` varchar(50) DEFAULT NULL,
  `genero` varchar(30) DEFAULT NULL,
  `editorial` varchar(50) DEFAULT NULL,
  `edicion` varchar(30) DEFAULT NULL,
  `ISBN` varchar(20) DEFAULT NULL,
  `ano_publicacion` year(4) DEFAULT NULL,
  `idioma` varchar(30) DEFAULT NULL,
  `estado` enum('disponible','prestado','dañado','extraviado') DEFAULT NULL,
  `prologo` text,
  `autor_prologo` text,
  `cantidad` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `penalizaciones`
--

CREATE TABLE `penalizaciones` (
  `penalizacion_id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `prestamo_id` int(11) DEFAULT NULL,
  `tipo_penalizacion` enum('multa','suspension') DEFAULT NULL,
  `monto` decimal(10,2) DEFAULT NULL,
  `fecha_penalizacion` date DEFAULT NULL,
  `estado_penalizacion` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `reservasespacios`
--

CREATE TABLE `reservasespacios` (
  `reserva_id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `espacio_id` int(11) DEFAULT NULL,
  `fecha_reserva` date DEFAULT NULL,
  `hora_inicio` time DEFAULT NULL,
  `hora_fin` time DEFAULT NULL,
  `estatus_reserva` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `usuarios`
--

CREATE TABLE `usuarios` (
  `usuario_id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellidos` varchar(50) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `direccion` text,
  `identificacion` varchar(20) DEFAULT NULL,
  `comprobante_domicilio` varchar(200) DEFAULT NULL,
  `fecha_registro` date DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `estatus` enum('Registrado','Baja','Vetado') DEFAULT NULL,
  `registro_caducado` tinyint(1) DEFAULT '0',
  `contrasena` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `espacios`
--
ALTER TABLE `espacios`
  ADD PRIMARY KEY (`espacio_id`);

--
-- Indexes for table `eventos`
--
ALTER TABLE `eventos`
  ADD PRIMARY KEY (`evento_id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indexes for table `historialprestamos`
--
ALTER TABLE `historialprestamos`
  ADD PRIMARY KEY (`prestamo_id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `libro_id` (`libro_id`);

--
-- Indexes for table `libros`
--
ALTER TABLE `libros`
  ADD PRIMARY KEY (`libro_id`);

--
-- Indexes for table `penalizaciones`
--
ALTER TABLE `penalizaciones`
  ADD PRIMARY KEY (`penalizacion_id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `prestamo_id` (`prestamo_id`);

--
-- Indexes for table `reservasespacios`
--
ALTER TABLE `reservasespacios`
  ADD PRIMARY KEY (`reserva_id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `espacio_id` (`espacio_id`);

--
-- Indexes for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`usuario_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `eventos`
--
ALTER TABLE `eventos`
  ADD CONSTRAINT `eventos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`usuario_id`);

--
-- Constraints for table `historialprestamos`
--
ALTER TABLE `historialprestamos`
  ADD CONSTRAINT `historialprestamos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`usuario_id`),
  ADD CONSTRAINT `historialprestamos_ibfk_2` FOREIGN KEY (`libro_id`) REFERENCES `libros` (`libro_id`);

--
-- Constraints for table `penalizaciones`
--
ALTER TABLE `penalizaciones`
  ADD CONSTRAINT `penalizaciones_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`usuario_id`),
  ADD CONSTRAINT `penalizaciones_ibfk_2` FOREIGN KEY (`prestamo_id`) REFERENCES `historialprestamos` (`prestamo_id`);

--
-- Constraints for table `reservasespacios`
--
ALTER TABLE `reservasespacios`
  ADD CONSTRAINT `reservasespacios_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`usuario_id`),
  ADD CONSTRAINT `reservasespacios_ibfk_2` FOREIGN KEY (`espacio_id`) REFERENCES `espacios` (`espacio_id`);

--
-- Insert new books into `libros` table
--
INSERT INTO `libros` (`libro_id`, `titulo`, `autor`, `genero`, `editorial`, `edicion`, `ISBN`, `ano_publicacion`, `idioma`, `estado`, `prologo`, `autor_prologo`, `cantidad`) VALUES
(1, 'Regina. 2 de octubre no se olvida', 'Autor 1', 'Ficción', 'Editorial 1', '1ra', '1234567890', 2021, 'Español', 'disponible', 'Prólogo del libro 1', 'Autor del prólogo 1', 5),
(2, 'La rosa blanca', 'Autor 2', 'Ficción', 'Editorial 2', '2da', '0987654321', 2020, 'Español', 'disponible', 'Prólogo del libro 2', 'Autor del prólogo 2', 3),
(3, 'La rebelión de los colgados', 'Autor 3', 'Ficción', 'Editorial 3', '3ra', '1122334455', 2019, 'Español', 'disponible', 'Prólogo del libro 3', 'Autor del prólogo 3', 4),
(4, 'El origen de las especies', 'Autor 4', 'Ciencia', 'Editorial 4', '4ta', '2233445566', 2018, 'Español', 'disponible', 'Prólogo del libro 4', 'Autor del prólogo 4', 2),
(5, 'Breve historia del tiempo', 'Autor 5', 'Ciencia', 'Editorial 5', '5ta', '3344556677', 2017, 'Español', 'disponible', 'Prólogo del libro 5', 'Autor del prólogo 5', 6),
(6, 'Cosmos', 'Autor 6', 'Ciencia', 'Editorial 6', '6ta', '4455667788', 2016, 'Español', 'disponible', 'Prólogo del libro 6', 'Autor del prólogo 6', 7),
(7, 'Sapiens', 'Autor 7', 'Historia', 'Editorial 7', '7ma', '5566778899', 2015, 'Español', 'disponible', 'Prólogo del libro 7', 'Autor del prólogo 7', 5),
(8, 'Guerra y paz', 'Autor 8', 'Historia', 'Editorial 8', '8va', '6677889900', 2014, 'Español', 'disponible', 'Prólogo del libro 8', 'Autor del prólogo 8', 3),
(9, 'El diario de Ana Frank', 'Autor 9', 'Historia', 'Editorial 9', '9na', '7788990011', 2013, 'Español', 'disponible', 'Prólogo del libro 9', 'Autor del prólogo 9', 4),
(10, 'El señor de los anillos', 'Autor 10', 'Fantasía', 'Editorial 10', '10ma', '8899001122', 2012, 'Español', 'disponible', 'Prólogo del libro 10', 'Autor del prólogo 10', 2),
(11, 'Harry Potter', 'Autor 11', 'Fantasía', 'Editorial 11', '11va', '9900112233', 2011, 'Español', 'disponible', 'Prólogo del libro 11', 'Autor del prólogo 11', 6),
(12, 'Crónicas de Narnia', 'Autor 12', 'Fantasía', 'Editorial 12', '12va', '0011223344', 2010, 'Español', 'disponible', 'Prólogo del libro 12', 'Autor del prólogo 12', 7),
(13, 'El código Da Vinci', 'Autor 13', 'Misterio', 'Editorial 13', '13va', '1122334455', 2009, 'Español', 'disponible', 'Prólogo del libro 13', 'Autor del prólogo 13', 5),
(14, 'Sherlock Holmes', 'Autor 14', 'Misterio', 'Editorial 14', '14va', '2233445566', 2008, 'Español', 'disponible', 'Prólogo del libro 14', 'Autor del prólogo 14', 3),
(15, 'La chica del tren', 'Autor 15', 'Misterio', 'Editorial 15', '15va', '3344556677', 2007, 'Español', 'disponible', 'Prólogo del libro 15', 'Autor del prólogo 15', 4),
(16, 'Steve Jobs', 'Autor 16', 'Biografía', 'Editorial 16', '16va', '4455667788', 2006, 'Español', 'disponible', 'Prólogo del libro 16', 'Autor del prólogo 16', 2),
(17, 'El diario de Ana Frank', 'Autor 17', 'Biografía', 'Editorial 17', '17va', '5566778899', 2005, 'Español', 'disponible', 'Prólogo del libro 17', 'Autor del prólogo 17', 6),
(18, 'Long Walk to Freedom', 'Autor 18', 'Biografía', 'Editorial 18', '18va', '6677889900', 2004, 'Español', 'disponible', 'Prólogo del libro 18', 'Autor del prólogo 18', 7);

-- Add contrasena column to usuarios table
ALTER TABLE `usuarios`
  ADD `contrasena` varchar(255) NOT NULL AFTER `correo`;

-- Insert a new user into `usuarios` table
INSERT INTO `usuarios` (`usuario_id`, `nombre`, `apellidos`, `fecha_nacimiento`, `telefono`, `direccion`, `identificacion`, `comprobante_domicilio`, `fecha_registro`, `correo`, `contrasena`, `estatus`, `registro_caducado`) VALUES
(1, 'Juan', 'Aguilera', '1990-01-01', '1234567890', 'Calle Falsa 123', 'ABC123456', 'comprobante.jpg', '2024-01-01', 'juan@example.com', 'password123', 'Registrado', 0);

COMMIT;

