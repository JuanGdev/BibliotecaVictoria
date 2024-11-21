
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
  `registro_caducado` tinyint(1) DEFAULT '0'
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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
