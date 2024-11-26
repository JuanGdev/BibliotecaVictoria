SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE DATABASE IF NOT EXISTS biblioteca;
USE biblioteca;

CREATE TABLE `libros` (
  `libro_id` int(11) NOT NULL AUTO_INCREMENT,
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
  `cantidad` int(11) DEFAULT NULL,
  PRIMARY KEY (`libro_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `usuarios` (
  `usuario_id` int(11) NOT NULL AUTO_INCREMENT,
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
  `contrasena` varchar(255) NOT NULL,
  `tipo_usuario` enum('admin', 'usuario') DEFAULT 'usuario',
  PRIMARY KEY (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `historialprestamos` (
  `prestamo_id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  `libro_id` int(11) DEFAULT NULL,
  `fecha_prestamo` date DEFAULT NULL,
  `fecha_devolucion` date DEFAULT NULL,
  `fecha_limite` date DEFAULT NULL,
  `estado_prestamo` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`prestamo_id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `libro_id` (`libro_id`),
  CONSTRAINT `historialprestamos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`usuario_id`),
  CONSTRAINT `historialprestamos_ibfk_2` FOREIGN KEY (`libro_id`) REFERENCES `libros` (`libro_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `penalizaciones` (
  `penalizacion_id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  `prestamo_id` int(11) DEFAULT NULL,
  `tipo_penalizacion` enum('multa','suspension') DEFAULT NULL,
  `monto` decimal(10,2) DEFAULT NULL,
  `fecha_penalizacion` date DEFAULT NULL,
  `estado_penalizacion` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`penalizacion_id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `prestamo_id` (`prestamo_id`),
  CONSTRAINT `penalizaciones_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`usuario_id`),
  CONSTRAINT `penalizaciones_ibfk_2` FOREIGN KEY (`prestamo_id`) REFERENCES `historialprestamos` (`prestamo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `espacios` (
  `espacio_id` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_espacio` enum('sala','auditorio','cubiculo','aula') DEFAULT NULL,
  `capacidad` int(11) DEFAULT NULL,
  `descripcion` text,
  `equipamiento` varchar(100) DEFAULT NULL,
  `disponibilidad` enum('disponible','ocupado') DEFAULT 'disponible',
  PRIMARY KEY (`espacio_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `reservasespacios` (
  `reserva_id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  `espacio_id` int(11) DEFAULT NULL,
  `fecha_reserva` date DEFAULT NULL,
  `hora_inicio` time DEFAULT NULL,
  `hora_fin` time DEFAULT NULL,
  `estatus_reserva` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`reserva_id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `espacio_id` (`espacio_id`),
  CONSTRAINT `reservasespacios_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`usuario_id`),
  CONSTRAINT `reservasespacios_ibfk_2` FOREIGN KEY (`espacio_id`) REFERENCES `espacios` (`espacio_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `eventos` (
  `evento_id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  `nombre_evento` varchar(100) DEFAULT NULL,
  `descripcion` text,
  `cantidad_asistentes` int(11) DEFAULT NULL,
  `fecha_evento` date DEFAULT NULL,
  `hora_inicio` time DEFAULT NULL,
  `hora_fin` time DEFAULT NULL,
  `aprobado` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`evento_id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `eventos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

COMMIT;
INSERT INTO `libros` (`titulo`, `autor`, `genero`, `editorial`, `edicion`, `ISBN`, `ano_publicacion`, `idioma`, `estado`, `prologo`, `autor_prologo`, `cantidad`) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 'Scribner', '1st', '9780743273565', 1925, 'English', 'disponible', 'A story about the Jazz Age', 'None', 5),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 'J.B. Lippincott & Co.', '1st', '9780061120084', 1960, 'English', 'disponible', 'A novel about racial injustice', 'None', 3),
('1984', 'George Orwell', 'Dystopian', 'Secker & Warburg', '1st', '9780451524935', 1949, 'English', 'disponible', 'A story about totalitarianism', 'None', 4),
('Pride and Prejudice', 'Jane Austen', 'Romance', 'T. Egerton', '1st', '9781503290563', 1813, 'English', 'disponible', 'A classic novel about manners', 'None', 2),
('Moby Dick', 'Herman Melville', 'Adventure', 'Harper & Brothers', '1st', '9781503280786', 1851, 'English', 'disponible', 'A story about a giant whale', 'None', 3),
('War and Peace', 'Leo Tolstoy', 'Historical', 'The Russian Messenger', '1st', '9780199232765', 1869, 'Russian', 'disponible', 'A novel about the Napoleonic Wars', 'None', 1),
('The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 'Little, Brown and Company', '1st', '9780316769488', 1951, 'English', 'disponible', 'A story about teenage rebellion', 'None', 4),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 'George Allen & Unwin', '1st', '9780547928227', 1937, 'English', 'disponible', 'A fantasy novel about a hobbit', 'None', 5),
('Fahrenheit 451', 'Ray Bradbury', 'Dystopian', 'Ballantine Books', '1st', '9781451673319', 1953, 'English', 'disponible', 'A novel about book burning', 'None', 3),
('Jane Eyre', 'Charlotte Brontë', 'Romance', 'Smith, Elder & Co.', '1st', '9780141441146', 1847, 'English', 'disponible', 'A novel about an orphaned girl', 'None', 2),
('Brave New World', 'Aldous Huxley', 'Dystopian', 'Chatto & Windus', '1st', '9780060850524', 1932, 'English', 'disponible', 'A novel about a dystopian future', 'None', 4),
('The Odyssey', 'Homer', 'Epic', 'Ancient Greece', '1st', '9780140268867', -800, 'Greek', 'disponible', 'An epic poem about Odysseus', 'None', 1),
('Crime and Punishment', 'Fyodor Dostoevsky', 'Psychological', 'The Russian Messenger', '1st', '9780140449136', 1866, 'Russian', 'disponible', 'A novel about crime and guilt', 'None', 2),
('The Brothers Karamazov', 'Fyodor Dostoevsky', 'Philosophical', 'The Russian Messenger', '1st', '9780374528379', 1880, 'Russian', 'disponible', 'A novel about faith and doubt', 'None', 1),
('Wuthering Heights', 'Emily Brontë', 'Gothic', 'Thomas Cautley Newby', '1st', '9780141439556', 1847, 'English', 'disponible', 'A novel about love and revenge', 'None', 3),
('Great Expectations', 'Charles Dickens', 'Fiction', 'Chapman & Hall', '1st', '9780141439563', 1861, 'English', 'disponible', 'A novel about a young orphan', 'None', 4),
('The Divine Comedy', 'Dante Alighieri', 'Epic', 'Italy', '1st', '9780140448955', 1320, 'Italian', 'disponible', 'An epic poem about the afterlife', 'None', 1),
('Les Misérables', 'Victor Hugo', 'Historical', 'A. Lacroix, Verboeckhoven & Cie', '1st', '9780451419439', 1862, 'French', 'disponible', 'A novel about justice and redemption', 'None', 2),
('Anna Karenina', 'Leo Tolstoy', 'Romance', 'The Russian Messenger', '1st', '9780143035008', 1877, 'Russian', 'disponible', 'A novel about love and betrayal', 'None', 1),
('The Iliad', 'Homer', 'Epic', 'Ancient Greece', '1st', '9780140275360', -750, 'Greek', 'disponible', 'An epic poem about the Trojan War', 'None', 1),
('Don Quixote', 'Miguel de Cervantes', 'Adventure', 'Francisco de Robles', '1st', '9780060934347', 1605, 'Spanish', 'disponible', 'A novel about a delusional knight', 'None', 2),
('The Count of Monte Cristo', 'Alexandre Dumas', 'Adventure', 'Penguin Classics', '1st', '9780140449266', 1844, 'French', 'disponible', 'A novel about revenge', 'None', 3),
('Madame Bovary', 'Gustave Flaubert', 'Fiction', 'Revue de Paris', '1st', '9780140449129', 1857, 'French', 'disponible', 'A novel about a doctor\'s wife', 'None', 2);

INSERT INTO `usuarios` (`nombre`, `apellidos`, `fecha_nacimiento`, `telefono`, `direccion`, `identificacion`, `comprobante_domicilio`, `fecha_registro`, `correo`, `estatus`, `registro_caducado`, `contrasena`, `tipo_usuario`) VALUES
('Admin', 'User', '1980-01-01', '1234567890', '123 Admin St', 'A123456', 'admin_comprobante.jpg', CURDATE(), 'admin@example.com', 'Registrado', 0, 'adminpassword', 'admin'),
('Regular', 'User', '1990-01-01', '0987654321', '456 User St', 'U123456', 'user_comprobante.jpg', CURDATE(), 'user@example.com', 'Registrado', 0, 'userpassword', 'usuario');

INSERT INTO `espacios` (`nombre_espacio`, `tipo_espacio`, `capacidad`, `ubicacion`, `descripcion`, `equipamiento`, `disponibilidad`) VALUES
('Sala de Lectura', 'sala', 20, 'Primer Piso', 'Espacio tranquilo para lectura', 'Mesas, Sillas, Wi-Fi', 'disponible'),
('Auditorio Principal', 'auditorio', 100, 'Segundo Piso', 'Auditorio para eventos y conferencias', 'Proyector, Sonido, Wi-Fi', 'disponible'),
('Cubículo de Estudio 1', 'cubiculo', 4, 'Tercer Piso', 'Cubículo para estudio individual o en grupo pequeño', 'Mesa, Sillas, Wi-Fi', 'ocupado'),
('Aula de Capacitación', 'aula', 30, 'Cuarto Piso', 'Aula para cursos y talleres', 'Pizarrón, Proyector, Wi-Fi', 'disponible');