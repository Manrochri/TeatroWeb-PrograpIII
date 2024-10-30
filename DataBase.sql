CREATE DATABASE IF NOT EXISTS teatroweb1 /!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /!80016 DEFAULT ENCRYPTION='N' */;
USE teatroweb1;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP TABLE IF EXISTS categoriacurso;
CREATE TABLE categoriacurso (
  IdCategoria int NOT NULL AUTO_INCREMENT,
  Nombre varchar(50) NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdCategoria)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS curso;
CREATE TABLE curso (
  IdCurso int NOT NULL AUTO_INCREMENT,
  Nombre varchar(100) NOT NULL,
  FechaRegistro timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Capacidad int NOT NULL,
  FechaInicio date NOT NULL,
  FechaFin date NOT NULL,
  Precio decimal(10,2) NOT NULL,
  IdCategoria int NOT NULL,
  IdDuracion int NOT NULL,
  IdIdioma int NOT NULL,
  IdRango int NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdCurso),
  KEY IdCategoria (IdCategoria),
  KEY IdDuracion (IdDuracion),
  KEY IdIdioma (IdIdioma),
  KEY IdRango (IdRango),
  CONSTRAINT curso_ibfk_1 FOREIGN KEY (IdCategoria) REFERENCES categoriacurso (IdCategoria),
  CONSTRAINT curso_ibfk_2 FOREIGN KEY (IdDuracion) REFERENCES duracioncurso (IdDuracion),
  CONSTRAINT curso_ibfk_3 FOREIGN KEY (IdIdioma) REFERENCES idiomacurso (IdIdioma),
  CONSTRAINT curso_ibfk_4 FOREIGN KEY (IdRango) REFERENCES rangoedadescurso (IdRango)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS curso_docente;
CREATE TABLE curso_docente (
  IdCurso int NOT NULL,
  IdDocente int NOT NULL,
  PRIMARY KEY (IdCurso, IdDocente),
  KEY IdDocente (IdDocente),
  CONSTRAINT curso_docente_ibfk_1 FOREIGN KEY (IdCurso) REFERENCES curso (IdCurso),
  CONSTRAINT curso_docente_ibfk_2 FOREIGN KEY (IdDocente) REFERENCES docente (IdDocente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS docente;
CREATE TABLE docente (
  IdDocente int NOT NULL AUTO_INCREMENT,
  IdUsuario int NOT NULL,
  IdGradoAcademico int NOT NULL,
  Descripcion text,
  EstadoRegistro tinyint(1) NOT NULL DEFAULT '1',
  Nombres varchar(100) DEFAULT NULL,
  PRIMARY KEY (IdDocente),
  KEY IdUsuario (IdUsuario),
  KEY IdGradoAcademico (IdGradoAcademico),
  CONSTRAINT docente_ibfk_1 FOREIGN KEY (IdUsuario) REFERENCES usuario (IdUsuario),
  CONSTRAINT docente_ibfk_2 FOREIGN KEY (IdGradoAcademico) REFERENCES gradoacademico (IdGradoAcademico)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS duracioncurso;
CREATE TABLE duracioncurso (
  IdDuracion int NOT NULL AUTO_INCREMENT,
  Nombre varchar(50) NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdDuracion)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS gradoacademico;
CREATE TABLE gradoacademico (
  IdGradoAcademico int NOT NULL AUTO_INCREMENT,
  Nombre varchar(50) NOT NULL,
  EstadoRegistro tinyint NOT NULL,
  PRIMARY KEY (IdGradoAcademico)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS idiomacurso;
CREATE TABLE idiomacurso (
  IdIdioma int NOT NULL AUTO_INCREMENT,
  Nombre varchar(50) NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdIdioma)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS opcionesmenu;
CREATE TABLE opcionesmenu (
  IdOpcionMenu int NOT NULL AUTO_INCREMENT,
  Nombre varchar(50) NOT NULL,
  UrlMenu varchar(50) NOT NULL,
  Descripcion varchar(100) DEFAULT NULL,
  IdPadre int DEFAULT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdOpcionMenu),
  KEY IdPadre (IdPadre),
  CONSTRAINT opcionesmenu_ibfk_1 FOREIGN KEY (IdPadre) REFERENCES opcionesmenu (IdOpcionMenu)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS opcionesmenu_perfiles;
CREATE TABLE opcionesmenu_perfiles (
  IdOpcionMenu int NOT NULL,
  IdPerfil int NOT NULL,
  Orden tinyint NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdOpcionMenu, IdPerfil),
  KEY IdPerfil (IdPerfil),
  CONSTRAINT opcionesmenu_perfiles_ibfk_1 FOREIGN KEY (IdOpcionMenu) REFERENCES opcionesmenu (IdOpcionMenu),
  CONSTRAINT opcionesmenu_perfiles_ibfk_2 FOREIGN KEY (IdPerfil) REFERENCES perfiles (IdPerfil)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS perfiles;
CREATE TABLE perfiles (
  IdPerfil int NOT NULL AUTO_INCREMENT,
  Nombre varchar(50) NOT NULL,
  Descripcion varchar(500) DEFAULT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdPerfil)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS rangoedadescurso;
CREATE TABLE rangoedadescurso (
  IdRango int NOT NULL AUTO_INCREMENT,
  Descripcion varchar(50) NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdRango)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS usuario;
CREATE TABLE usuario (
  IdUsuario int NOT NULL AUTO_INCREMENT,
  DNI varchar(15) NOT NULL,
  Nombres varchar(40) NOT NULL,
  ApellidoPaterno varchar(40) NOT NULL,
  ApellidoMaterno varchar(40) DEFAULT NULL,
  Celular varchar(15) DEFAULT NULL,
  CorreoElectronico varchar(40) NOT NULL,
  Clave varchar(60) NOT NULL,
  UsuarioCreacion int DEFAULT NULL,
  FechaCreacion datetime NOT NULL,
  UsuarioModificacion int DEFAULT NULL,
  FechaModificacion datetime DEFAULT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdUsuario)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS usuario_perfiles;
CREATE TABLE usuario_perfiles (
  IdUsuario int NOT NULL,
  IdPerfil int NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdUsuario, IdPerfil),
  KEY IdPerfil (IdPerfil),
  CONSTRAINT usuario_perfiles_ibfk_1 FOREIGN KEY (IdPerfil) REFERENCES perfiles (IdPerfil),
  CONSTRAINT usuario_perfiles_ibfk_2 FOREIGN KEY (IdUsuario) REFERENCES usuario (IdUsuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Inserciones en la tabla 'perfiles'
INSERT INTO perfiles (Nombre, Descripcion, EstadoRegistro)
VALUES
('Administrador', 'Usuario con acceso completo a todas las funciones del sistema.', 1),
('Usuario', 'Usuario estándar con acceso limitado a ciertas funciones.', 1),
('Moderador', 'Usuario con permisos para gestionar contenidos y usuarios.', 1),
('Invitado', 'Usuario con acceso temporal y permisos muy limitados.', 1);

-- Inserciones en la tabla 'gradoacademico'
INSERT INTO gradoacademico (Nombre, EstadoRegistro)
VALUES
('Bachiller', 1),
('Licenciado', 1),
('Magíster', 1),
('Doctorado', 1);

-- Restaurar configuraciones anteriores
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;CREATE DATABASE IF NOT EXISTS teatroweb1 /!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /!80016 DEFAULT ENCRYPTION='N' */;
USE teatroweb1;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP TABLE IF EXISTS categoriacurso;
CREATE TABLE categoriacurso (
  IdCategoria int NOT NULL AUTO_INCREMENT,
  Nombre varchar(50) NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdCategoria)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS curso;
CREATE TABLE curso (
  IdCurso int NOT NULL AUTO_INCREMENT,
  Nombre varchar(100) NOT NULL,
  FechaRegistro timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Capacidad int NOT NULL,
  FechaInicio date NOT NULL,
  FechaFin date NOT NULL,
  Precio decimal(10,2) NOT NULL,
  IdCategoria int NOT NULL,
  IdDuracion int NOT NULL,
  IdIdioma int NOT NULL,
  IdRango int NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdCurso),
  KEY IdCategoria (IdCategoria),
  KEY IdDuracion (IdDuracion),
  KEY IdIdioma (IdIdioma),
  KEY IdRango (IdRango),
  CONSTRAINT curso_ibfk_1 FOREIGN KEY (IdCategoria) REFERENCES categoriacurso (IdCategoria),
  CONSTRAINT curso_ibfk_2 FOREIGN KEY (IdDuracion) REFERENCES duracioncurso (IdDuracion),
  CONSTRAINT curso_ibfk_3 FOREIGN KEY (IdIdioma) REFERENCES idiomacurso (IdIdioma),
  CONSTRAINT curso_ibfk_4 FOREIGN KEY (IdRango) REFERENCES rangoedadescurso (IdRango)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS curso_docente;
CREATE TABLE curso_docente (
  IdCurso int NOT NULL,
  IdDocente int NOT NULL,
  PRIMARY KEY (IdCurso, IdDocente),
  KEY IdDocente (IdDocente),
  CONSTRAINT curso_docente_ibfk_1 FOREIGN KEY (IdCurso) REFERENCES curso (IdCurso),
  CONSTRAINT curso_docente_ibfk_2 FOREIGN KEY (IdDocente) REFERENCES docente (IdDocente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS docente;
CREATE TABLE docente (
  IdDocente int NOT NULL AUTO_INCREMENT,
  IdUsuario int NOT NULL,
  IdGradoAcademico int NOT NULL,
  Descripcion text,
  EstadoRegistro tinyint(1) NOT NULL DEFAULT '1',
  Nombres varchar(100) DEFAULT NULL,
  PRIMARY KEY (IdDocente),
  KEY IdUsuario (IdUsuario),
  KEY IdGradoAcademico (IdGradoAcademico),
  CONSTRAINT docente_ibfk_1 FOREIGN KEY (IdUsuario) REFERENCES usuario (IdUsuario),
  CONSTRAINT docente_ibfk_2 FOREIGN KEY (IdGradoAcademico) REFERENCES gradoacademico (IdGradoAcademico)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS duracioncurso;
CREATE TABLE duracioncurso (
  IdDuracion int NOT NULL AUTO_INCREMENT,
  Nombre varchar(50) NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdDuracion)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS gradoacademico;
CREATE TABLE gradoacademico (
  IdGradoAcademico int NOT NULL AUTO_INCREMENT,
  Nombre varchar(50) NOT NULL,
  EstadoRegistro tinyint NOT NULL,
  PRIMARY KEY (IdGradoAcademico)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS idiomacurso;
CREATE TABLE idiomacurso (
  IdIdioma int NOT NULL AUTO_INCREMENT,
  Nombre varchar(50) NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdIdioma)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS opcionesmenu;
CREATE TABLE opcionesmenu (
  IdOpcionMenu int NOT NULL AUTO_INCREMENT,
  Nombre varchar(50) NOT NULL,
  UrlMenu varchar(50) NOT NULL,
  Descripcion varchar(100) DEFAULT NULL,
  IdPadre int DEFAULT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdOpcionMenu),
  KEY IdPadre (IdPadre),
  CONSTRAINT opcionesmenu_ibfk_1 FOREIGN KEY (IdPadre) REFERENCES opcionesmenu (IdOpcionMenu)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS opcionesmenu_perfiles;
CREATE TABLE opcionesmenu_perfiles (
  IdOpcionMenu int NOT NULL,
  IdPerfil int NOT NULL,
  Orden tinyint NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdOpcionMenu, IdPerfil),
  KEY IdPerfil (IdPerfil),
  CONSTRAINT opcionesmenu_perfiles_ibfk_1 FOREIGN KEY (IdOpcionMenu) REFERENCES opcionesmenu (IdOpcionMenu),
  CONSTRAINT opcionesmenu_perfiles_ibfk_2 FOREIGN KEY (IdPerfil) REFERENCES perfiles (IdPerfil)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS perfiles;
CREATE TABLE perfiles (
  IdPerfil int NOT NULL AUTO_INCREMENT,
  Nombre varchar(50) NOT NULL,
  Descripcion varchar(500) DEFAULT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdPerfil)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS rangoedadescurso;
CREATE TABLE rangoedadescurso (
  IdRango int NOT NULL AUTO_INCREMENT,
  Descripcion varchar(50) NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdRango)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS usuario;
CREATE TABLE usuario (
  IdUsuario int NOT NULL AUTO_INCREMENT,
  DNI varchar(15) NOT NULL,
  Nombres varchar(40) NOT NULL,
  ApellidoPaterno varchar(40) NOT NULL,
  ApellidoMaterno varchar(40) DEFAULT NULL,
  Celular varchar(15) DEFAULT NULL,
  CorreoElectronico varchar(40) NOT NULL,
  Clave varchar(60) NOT NULL,
  UsuarioCreacion int DEFAULT NULL,
  FechaCreacion datetime NOT NULL,
  UsuarioModificacion int DEFAULT NULL,
  FechaModificacion datetime DEFAULT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdUsuario)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS usuario_perfiles;
CREATE TABLE usuario_perfiles (
  IdUsuario int NOT NULL,
  IdPerfil int NOT NULL,
  EstadoRegistro tinyint(1) NOT NULL,
  PRIMARY KEY (IdUsuario, IdPerfil),
  KEY IdPerfil (IdPerfil),
  CONSTRAINT usuario_perfiles_ibfk_1 FOREIGN KEY (IdPerfil) REFERENCES perfiles (IdPerfil),
  CONSTRAINT usuario_perfiles_ibfk_2 FOREIGN KEY (IdUsuario) REFERENCES usuario (IdUsuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Inserciones en la tabla 'perfiles'
INSERT INTO perfiles (Nombre, Descripcion, EstadoRegistro)
VALUES
('Administrador', 'Usuario con acceso completo a todas las funciones del sistema.', 1),
('Usuario', 'Usuario estándar con acceso limitado a ciertas funciones.', 1),
('Moderador', 'Usuario con permisos para gestionar contenidos y usuarios.', 1),
('Invitado', 'Usuario con acceso temporal y permisos muy limitados.', 1);

-- Inserciones en la tabla 'gradoacademico'
INSERT INTO gradoacademico (Nombre, EstadoRegistro)
VALUES
('Bachiller', 1),
('Licenciado', 1),
('Magíster', 1),
('Doctorado', 1);

-- Restaurar configuraciones anteriores
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;