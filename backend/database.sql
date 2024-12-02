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
  `sinopsis` text,
  `cantidad` int(11) DEFAULT 1,
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
  `estado_prestamo` enum('pendiente', 'prestado', 'devuelto', 'rechazado','extraviado') DEFAULT 'pendiente',
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
  `estado_penalizacion` enum('pagada','pendiente') DEFAULT NULL,
  PRIMARY KEY (`penalizacion_id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `prestamo_id` (`prestamo_id`),
  CONSTRAINT `penalizaciones_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`usuario_id`),
  CONSTRAINT `penalizaciones_ibfk_2` FOREIGN KEY (`prestamo_id`) REFERENCES `historialprestamos` (`prestamo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `espacios` (
  `espacio_id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_espacio` varchar(100) DEFAULT NULL,
  `tipo_espacio` enum('sala','auditorio','cubiculo','aula') DEFAULT NULL,
  `capacidad` int(11) DEFAULT NULL,
  `ubicacion` varchar(100) DEFAULT NULL,
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

INSERT INTO `libros` (`titulo`, `autor`, `genero`, `editorial`, `edicion`, `ISBN`, `ano_publicacion`, `idioma`, `estado`, `sinopsis`, `cantidad`) VALUES
('El Gran Gatsby', 'F. Scott Fitzgerald', 'Ficción', 'Scribner', '1ra', '9780743273565', 1925, 'Inglés', 'disponible', 'Una historia sobre la era del Jazz', 5),
('Matar a un Ruiseñor', 'Harper Lee', 'Ficción', 'J.B. Lippincott & Co.', '1ra', '9780061120084', 1960, 'Inglés', 'disponible', 'Una novela sobre la injusticia racial', 3),
('1984', 'George Orwell', 'Distopía', 'Secker & Warburg', '1ra', '9780451524935', 1949, 'Inglés', 'disponible', 'Una historia sobre el totalitarismo', 4),
('Orgullo y Prejuicio', 'Jane Austen', 'Romance', 'T. Egerton', '1ra', '9781503290563', 1813, 'Inglés', 'disponible', 'Una novela clásica sobre las costumbres', 2),
('Moby Dick', 'Herman Melville', 'Aventura', 'Harper & Brothers', '1ra', '9781503280786', 1851, 'Inglés', 'disponible', 'Una historia sobre una ballena gigante', 3),
('Guerra y Paz', 'Leo Tolstoy', 'Histórica', 'The Russian Messenger', '1ra', '9780199232765', 1869, 'Ruso', 'disponible', 'Una novela sobre las guerras napoleónicas', 1),
('El Guardián entre el Centeno', 'J.D. Salinger', 'Ficción', 'Little, Brown and Company', '1ra', '9780316769488', 1951, 'Inglés', 'disponible', 'Una historia sobre la rebeldía adolescente', 4),
('El Hobbit', 'J.R.R. Tolkien', 'Fantasía', 'George Allen & Unwin', '1ra', '9780547928227', 1937, 'Inglés', 'disponible', 'Una novela fantástica sobre un hobbit', 5),
('Fahrenheit 451', 'Ray Bradbury', 'Distopía', 'Ballantine Books', '1ra', '9781451673319', 1953, 'Inglés', 'disponible', 'Una novela sobre la quema de libros', 3),
('Jane Eyre', 'Charlotte Brontë', 'Romance', 'Smith, Elder & Co.', '1ra', '9780141441146', 1847, 'Inglés', 'disponible', 'Una novela sobre una joven huérfana', 2),
('Un Mundo Feliz', 'Aldous Huxley', 'Distopía', 'Chatto & Windus', '1ra', '9780060850524', 1932, 'Inglés', 'disponible', 'Una novela sobre un futuro distópico', 4),
('La Odisea', 'Homer', 'Épica', 'Ancient Greece', '1ra', '9780140268867', -800, 'Griego', 'disponible', 'Un poema épico sobre Odiseo', 1),
('Crimen y Castigo', 'Fyodor Dostoevsky', 'Psicológica', 'The Russian Messenger', '1ra', '9780140449136', 1866, 'Ruso', 'disponible', 'Una novela sobre el crimen y la culpa', 2),
('Los Hermanos Karamazov', 'Fyodor Dostoevsky', 'Filosófica', 'The Russian Messenger', '1ra', '9780374528379', 1880, 'Ruso', 'disponible', 'Una novela sobre la fe y la duda', 1),
('Cumbres Borrascosas', 'Emily Brontë', 'Gótica', 'Thomas Cautley Newby', '1ra', '9780141439556', 1847, 'Inglés', 'disponible', 'Una novela sobre el amor y la venganza', 3),
('Grandes Esperanzas', 'Charles Dickens', 'Ficción', 'Chapman & Hall', '1ra', '9780141439563', 1861, 'Inglés', 'disponible', 'Una novela sobre un joven huérfano', 4),
('La Divina Comedia', 'Dante Alighieri', 'Épica', 'Italy', '1ra', '9780140448955', 1320, 'Italiano', 'disponible', 'Un poema épico sobre el más allá', 1),
('Los Miserables', 'Victor Hugo', 'Histórica', 'A. Lacroix, Verboeckhoven & Cie', '1ra', '9780451419439', 1862, 'Francés', 'disponible', 'Una novela sobre la justicia y la redención', 2),
('Ana Karenina', 'Leo Tolstoy', 'Romance', 'The Russian Messenger', '1ra', '9780143035008', 1877, 'Ruso', 'disponible', 'Una novela sobre el amor y la traición', 1),
('La Ilíada', 'Homer', 'Épica', 'Ancient Greece', '1ra', '9780140275360', -750, 'Griego', 'disponible', 'Un poema épico sobre la Guerra de Troya', 1),
('Don Quijote', 'Miguel de Cervantes', 'Aventura', 'Francisco de Robles', '1ra', '9780060934347', 1605, 'Español', 'disponible', 'Una novela sobre un caballero delirante', 2),
('El Conde de Montecristo', 'Alexandre Dumas', 'Aventura', 'Penguin Classics', '1ra', '9780140449266', 1844, 'Francés', 'disponible', 'Una novela sobre la venganza', 3),
('Madame Bovary', 'Gustave Flaubert', 'Ficción', 'Revue de Paris', '1ra', '9780140449129', 1857, 'Francés', 'disponible', 'Una novela sobre la esposa de un médico', 2);

INSERT INTO `usuarios` (`nombre`, `apellidos`, `fecha_nacimiento`, `telefono`, `direccion`, `identificacion`, `comprobante_domicilio`, `fecha_registro`, `correo`, `estatus`, `registro_caducado`, `contrasena`, `tipo_usuario`) VALUES
('Admin', 'User', '1980-01-01', '1234567890', '123 Admin St', 'A123456', 'admin_comprobante.jpg', CURDATE(), 'admin@example.com', 'Registrado', 0, 'adminpassword', 'admin'),
('Regular', 'User', '1990-01-01', '0987654321', '456 User St', 'U123456', 'user_comprobante.jpg', CURDATE(), 'user@example.com', 'Registrado', 0, 'userpassword', 'usuario');

INSERT INTO `espacios` (`nombre_espacio`, `tipo_espacio`, `capacidad`, `ubicacion`, `descripcion`, `equipamiento`, `disponibilidad`) VALUES
('Sala de Lectura', 'sala', 20, 'Primer Piso', 'Espacio tranquilo para lectura', 'Mesas, Sillas, Wi-Fi', 'disponible'),
('Auditorio Principal', 'auditorio', 100, 'Segundo Piso', 'Auditorio para eventos y conferencias', 'Proyector, Sonido, Wi-Fi', 'disponible'),
('Cubículo de Estudio 1', 'cubiculo', 4, 'Tercer Piso', 'Cubículo para estudio individual o en grupo pequeño', 'Mesa, Sillas, Wi-Fi', 'ocupado'),
('Aula de Capacitación', 'aula', 30, 'Cuarto Piso', 'Aula para cursos y talleres', 'Pizarrón, Proyector, Wi-Fi', 'disponible');