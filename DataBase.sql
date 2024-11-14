CREATE DATABASE  IF NOT EXISTS `teatroweb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `teatroweb`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: teatroweb
-- ------------------------------------------------------
-- Server version	8.0.31

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

--
-- Table structure for table `categoriacurso`
--

DROP TABLE IF EXISTS `categoriacurso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoriacurso` (
  `IdCategoria` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoriacurso`
--

LOCK TABLES `categoriacurso` WRITE;
/*!40000 ALTER TABLE `categoriacurso` DISABLE KEYS */;
INSERT INTO `categoriacurso` VALUES (1,'Clowns',1),(4,'Experto',1);
/*!40000 ALTER TABLE `categoriacurso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curso`
--

DROP TABLE IF EXISTS `curso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curso` (
  `IdCurso` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(100) NOT NULL,
  `FechaRegistro` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Capacidad` int NOT NULL,
  `FechaInicio` date NOT NULL,
  `FechaFin` date NOT NULL,
  `Precio` decimal(10,2) NOT NULL,
  `IdCategoria` int NOT NULL,
  `IdDuracion` int NOT NULL,
  `IdIdioma` int NOT NULL,
  `IdRango` int NOT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdCurso`),
  KEY `IdCategoria` (`IdCategoria`),
  KEY `IdDuracion` (`IdDuracion`),
  KEY `IdIdioma` (`IdIdioma`),
  KEY `IdRango` (`IdRango`),
  CONSTRAINT `curso_ibfk_1` FOREIGN KEY (`IdCategoria`) REFERENCES `categoriacurso` (`IdCategoria`),
  CONSTRAINT `curso_ibfk_2` FOREIGN KEY (`IdDuracion`) REFERENCES `duracioncurso` (`IdDuracion`),
  CONSTRAINT `curso_ibfk_3` FOREIGN KEY (`IdIdioma`) REFERENCES `idiomacurso` (`IdIdioma`),
  CONSTRAINT `curso_ibfk_4` FOREIGN KEY (`IdRango`) REFERENCES `rangoedadescurso` (`IdRango`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curso`
--

LOCK TABLES `curso` WRITE;
/*!40000 ALTER TABLE `curso` DISABLE KEYS */;
INSERT INTO `curso` VALUES (1,'Vocalizacion basica','2024-10-30 03:28:24',50,'2024-10-29','2024-12-29',200.00,1,1,1,1,1),(2,'Clown','2024-10-30 16:07:46',80,'2024-10-30','2024-12-30',100.00,1,1,1,1,1),(3,'teatro 1','2024-10-30 21:08:16',60,'2024-10-31','2025-01-31',100.00,1,1,1,1,1),(4,'Mimo','2024-11-13 06:43:02',200,'2024-10-29','2024-11-01',132.00,4,1,1,1,1);
/*!40000 ALTER TABLE `curso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curso_docente`
--

DROP TABLE IF EXISTS `curso_docente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curso_docente` (
  `IdCurso` int NOT NULL,
  `IdDocente` int NOT NULL,
  PRIMARY KEY (`IdCurso`,`IdDocente`),
  KEY `IdDocente` (`IdDocente`),
  CONSTRAINT `curso_docente_ibfk_1` FOREIGN KEY (`IdCurso`) REFERENCES `curso` (`IdCurso`),
  CONSTRAINT `curso_docente_ibfk_2` FOREIGN KEY (`IdDocente`) REFERENCES `docente` (`IdDocente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curso_docente`
--

LOCK TABLES `curso_docente` WRITE;
/*!40000 ALTER TABLE `curso_docente` DISABLE KEYS */;
INSERT INTO `curso_docente` VALUES (1,1),(1,2),(1,3),(2,3),(1,4),(2,4);
/*!40000 ALTER TABLE `curso_docente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `docente`
--

DROP TABLE IF EXISTS `docente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `docente` (
  `IdDocente` int NOT NULL AUTO_INCREMENT,
  `IdUsuario` int NOT NULL,
  `IdGradoAcademico` int NOT NULL,
  `Descripcion` text,
  `EstadoRegistro` tinyint(1) NOT NULL DEFAULT '1',
  `Nombres` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`IdDocente`),
  KEY `IdUsuario` (`IdUsuario`),
  KEY `IdGradoAcademico` (`IdGradoAcademico`),
  CONSTRAINT `docente_ibfk_1` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`),
  CONSTRAINT `docente_ibfk_2` FOREIGN KEY (`IdGradoAcademico`) REFERENCES `gradoacademico` (`IdGradoAcademico`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docente`
--

LOCK TABLES `docente` WRITE;
/*!40000 ALTER TABLE `docente` DISABLE KEYS */;
INSERT INTO `docente` VALUES (1,12,1,'Hola hola',1,'Pepe'),(2,3,2,'123',1,'Carlos'),(3,3,1,'adasd',1,'Fernando '),(4,18,3,'adas',1,'Juan 1'),(5,3,2,'',1,'Max Verstappen'),(6,18,2,'hola',1,'Juan Perez');
/*!40000 ALTER TABLE `docente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `docente_redsocial`
--

DROP TABLE IF EXISTS `docente_redsocial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `docente_redsocial` (
  `IdDocente_Red` int NOT NULL AUTO_INCREMENT,
  `IdDocente` int NOT NULL,
  `IdRedesSociales` int NOT NULL,
  `URL` varchar(500) DEFAULT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdDocente_Red`),
  KEY `IdRedesSociales` (`IdRedesSociales`),
  KEY `IdDocente` (`IdDocente`),
  CONSTRAINT `docente_redsocial_ibfk_1` FOREIGN KEY (`IdRedesSociales`) REFERENCES `redessociales` (`IdRedesSociales`),
  CONSTRAINT `docente_redsocial_ibfk_2` FOREIGN KEY (`IdDocente`) REFERENCES `docente` (`IdDocente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docente_redsocial`
--

LOCK TABLES `docente_redsocial` WRITE;
/*!40000 ALTER TABLE `docente_redsocial` DISABLE KEYS */;
/*!40000 ALTER TABLE `docente_redsocial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `duracioncurso`
--

DROP TABLE IF EXISTS `duracioncurso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `duracioncurso` (
  `IdDuracion` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdDuracion`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `duracioncurso`
--

LOCK TABLES `duracioncurso` WRITE;
/*!40000 ALTER TABLE `duracioncurso` DISABLE KEYS */;
INSERT INTO `duracioncurso` VALUES (1,'2 meses',1);
/*!40000 ALTER TABLE `duracioncurso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estadosasistencia`
--

DROP TABLE IF EXISTS `estadosasistencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estadosasistencia` (
  `IdEstadoAsistencia` int NOT NULL AUTO_INCREMENT,
  `TipoAsistencia` varchar(50) NOT NULL,
  `EstadoRegistro` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`IdEstadoAsistencia`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estadosasistencia`
--

LOCK TABLES `estadosasistencia` WRITE;
/*!40000 ALTER TABLE `estadosasistencia` DISABLE KEYS */;
INSERT INTO `estadosasistencia` VALUES (1,'Asistió',1),(2,'Faltó',1),(3,'Justificó',1),(4,'Vacío',0),(5,'dwd',1);
/*!40000 ALTER TABLE `estadosasistencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gradoacademico`
--

DROP TABLE IF EXISTS `gradoacademico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gradoacademico` (
  `IdGradoAcademico` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `EstadoRegistro` tinyint NOT NULL,
  PRIMARY KEY (`IdGradoAcademico`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gradoacademico`
--

LOCK TABLES `gradoacademico` WRITE;
/*!40000 ALTER TABLE `gradoacademico` DISABLE KEYS */;
INSERT INTO `gradoacademico` VALUES (1,'Bachiller',1),(2,'Licenciado',1),(3,'Magíster',1),(4,'Doctorado',1);
/*!40000 ALTER TABLE `gradoacademico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `idiomacurso`
--

DROP TABLE IF EXISTS `idiomacurso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `idiomacurso` (
  `IdIdioma` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdIdioma`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `idiomacurso`
--

LOCK TABLES `idiomacurso` WRITE;
/*!40000 ALTER TABLE `idiomacurso` DISABLE KEYS */;
INSERT INTO `idiomacurso` VALUES (1,'English',1),(2,'Español',1);
/*!40000 ALTER TABLE `idiomacurso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opcionesmenu`
--

DROP TABLE IF EXISTS `opcionesmenu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opcionesmenu` (
  `IdOpcionMenu` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `UrlMenu` varchar(50) NOT NULL,
  `Descripcion` varchar(100) DEFAULT NULL,
  `IdPadre` int DEFAULT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdOpcionMenu`),
  KEY `IdPadre` (`IdPadre`),
  CONSTRAINT `opcionesmenu_ibfk_1` FOREIGN KEY (`IdPadre`) REFERENCES `opcionesmenu` (`IdOpcionMenu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opcionesmenu`
--

LOCK TABLES `opcionesmenu` WRITE;
/*!40000 ALTER TABLE `opcionesmenu` DISABLE KEYS */;
/*!40000 ALTER TABLE `opcionesmenu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opcionesmenu_perfiles`
--

DROP TABLE IF EXISTS `opcionesmenu_perfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opcionesmenu_perfiles` (
  `IdOpcionMenu` int NOT NULL,
  `IdPerfil` int NOT NULL,
  `Orden` tinyint NOT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdOpcionMenu`,`IdPerfil`),
  KEY `IdPerfil` (`IdPerfil`),
  CONSTRAINT `opcionesmenu_perfiles_ibfk_1` FOREIGN KEY (`IdOpcionMenu`) REFERENCES `opcionesmenu` (`IdOpcionMenu`),
  CONSTRAINT `opcionesmenu_perfiles_ibfk_2` FOREIGN KEY (`IdPerfil`) REFERENCES `perfiles` (`IdPerfil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opcionesmenu_perfiles`
--

LOCK TABLES `opcionesmenu_perfiles` WRITE;
/*!40000 ALTER TABLE `opcionesmenu_perfiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `opcionesmenu_perfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perfiles`
--

DROP TABLE IF EXISTS `perfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfiles` (
  `IdPerfil` int NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(50) NOT NULL,
  `Descripcion` varchar(500) DEFAULT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdPerfil`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfiles`
--

LOCK TABLES `perfiles` WRITE;
/*!40000 ALTER TABLE `perfiles` DISABLE KEYS */;
INSERT INTO `perfiles` VALUES (1,'Administrador','Perfil con acceso completo a todas las funcionalidades del sistema',1),(2,'Docente','Perfil del docente para crear tareas, calificaciones y subir materiales',1),(3,'Estudiante','Perfil de estudiante',1);
/*!40000 ALTER TABLE `perfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rangoedadescurso`
--

DROP TABLE IF EXISTS `rangoedadescurso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rangoedadescurso` (
  `IdRango` int NOT NULL AUTO_INCREMENT,
  `Descripcion` varchar(50) NOT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdRango`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rangoedadescurso`
--

LOCK TABLES `rangoedadescurso` WRITE;
/*!40000 ALTER TABLE `rangoedadescurso` DISABLE KEYS */;
INSERT INTO `rangoedadescurso` VALUES (1,'18-30',1);
/*!40000 ALTER TABLE `rangoedadescurso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `redessociales`
--

DROP TABLE IF EXISTS `redessociales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `redessociales` (
  `IdRedesSociales` int NOT NULL AUTO_INCREMENT,
  `RedSocial` varchar(50) NOT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdRedesSociales`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `redessociales`
--

LOCK TABLES `redessociales` WRITE;
/*!40000 ALTER TABLE `redessociales` DISABLE KEYS */;
INSERT INTO `redessociales` VALUES (1,'Facebook',1),(2,'Instagram',1),(3,'Youtube',1);
/*!40000 ALTER TABLE `redessociales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sesion`
--

DROP TABLE IF EXISTS `sesion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sesion` (
  `IdSesion` int NOT NULL AUTO_INCREMENT,
  `IdCurso` int NOT NULL,
  `NumeroSesion` int NOT NULL,
  `NombreSesion` varchar(100) NOT NULL,
  `IdTipoSesion` int NOT NULL,
  `FechaSesion` date NOT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdSesion`),
  KEY `IdCurso` (`IdCurso`),
  KEY `IdTipoSesion` (`IdTipoSesion`),
  CONSTRAINT `sesion_ibfk_1` FOREIGN KEY (`IdCurso`) REFERENCES `curso` (`IdCurso`) ON DELETE CASCADE,
  CONSTRAINT `sesion_ibfk_2` FOREIGN KEY (`IdTipoSesion`) REFERENCES `tiposesion` (`IdTipoSesion`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sesion`
--

LOCK TABLES `sesion` WRITE;
/*!40000 ALTER TABLE `sesion` DISABLE KEYS */;
INSERT INTO `sesion` VALUES (1,1,1,'introduccion a la vocalización',1,'2024-11-29',1),(3,4,1,'intro mimo',1,'2024-11-15',1);
/*!40000 ALTER TABLE `sesion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tiposesion`
--

DROP TABLE IF EXISTS `tiposesion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tiposesion` (
  `IdTipoSesion` int NOT NULL AUTO_INCREMENT,
  `TipoSesion` varchar(50) NOT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdTipoSesion`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiposesion`
--

LOCK TABLES `tiposesion` WRITE;
/*!40000 ALTER TABLE `tiposesion` DISABLE KEYS */;
INSERT INTO `tiposesion` VALUES (1,'Teórico',1),(2,'práctico',1),(3,'mixto',1);
/*!40000 ALTER TABLE `tiposesion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `IdUsuario` int NOT NULL AUTO_INCREMENT,
  `DNI` varchar(15) NOT NULL,
  `Nombres` varchar(40) NOT NULL,
  `ApellidoPaterno` varchar(40) NOT NULL,
  `ApellidoMaterno` varchar(40) DEFAULT NULL,
  `Celular` varchar(15) DEFAULT NULL,
  `CorreoElectronico` varchar(40) NOT NULL,
  `Clave` varchar(60) NOT NULL,
  `UsuarioCreacion` int DEFAULT NULL,
  `FechaCreacion` datetime NOT NULL,
  `UsuarioModificacion` int DEFAULT NULL,
  `FechaModificacion` datetime DEFAULT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (2,'98865752','Jeniffer','Karen','Miroquesada','12345678','jenni@correo.com','456',1,'2024-09-29 19:50:58',1,'2024-10-22 23:19:34',1),(3,'7654321','Max','Verstappen','awdaf','1234212','max@gmail.com','1234',3,'2024-09-29 21:40:11',3,'2024-09-29 21:40:11',1),(8,'75231045','Rayo','Mcqeen','Piston','78564235','mcqueen@correo.com','123',8,'2024-10-06 23:01:33',8,'2024-10-06 23:01:33',1),(9,'85312754','Michael','Schumacher','Ferrari','985321746','michael@correo.com','789',9,'2024-10-07 21:38:32',9,'2024-10-15 17:22:02',1),(11,'75229066','Christian','Rodriguez','Chilet','982537856','christian@correo.com','$2a$10$2fSindppAdHyXGA5munchO2hplw5x4s34bVMc68WxXVEYRQ5Ki5VG',11,'2024-10-15 16:57:21',11,'2024-10-15 16:57:21',1),(12,'75229067','Pepe','Mendoza','Dominguez','785652315','pepe@gmail.com','$2a$10$VXlVRWcAThX5DG1L4DUm/OGr17TfJB67VI3o9AMzlBOkLk3qADfDK',12,'2024-10-16 01:04:56',12,'2024-10-16 01:04:56',1),(13,'78567689','Mario','Bros','Nintendo','985995689','mario@nintendo.com','$2a$10$yjpLHophEzHArzbU4HFrSOaA4o4O86ibDtsPe19H8lDnClJMhshvu',13,'2024-10-16 21:50:36',13,'2024-10-16 21:50:36',1),(14,'12325468','Romel','Palomino',NULL,NULL,'Romel@correo.com','clave_generica',NULL,'2024-10-22 20:45:08',NULL,'2024-10-22 20:46:43',1),(15,'12345862','Hugo','Michael',NULL,NULL,'hugo@gmail.com','clave_generica',NULL,'2024-10-22 21:25:36',NULL,NULL,1),(17,'5678223','Julio','Roberto','Leones',NULL,'noel@gmail.com','clave_generica',NULL,'2024-10-22 21:45:56',NULL,'2024-10-22 21:59:17',1),(18,'20202020','Juan','Perez','Perez',NULL,'juanperez@correo.com','clave_generica',NULL,'2024-10-30 15:52:23',NULL,NULL,1),(19,'30303030','Juan','Rojas','Rojas',NULL,'juanrojas@correo.com','clave_generica',NULL,'2024-10-30 15:54:22',NULL,NULL,1);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario_perfiles`
--

DROP TABLE IF EXISTS `usuario_perfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario_perfiles` (
  `IdUsuario` int NOT NULL,
  `IdPerfil` int NOT NULL,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdUsuario`,`IdPerfil`),
  KEY `IdPerfil` (`IdPerfil`),
  CONSTRAINT `usuario_perfiles_ibfk_1` FOREIGN KEY (`IdPerfil`) REFERENCES `perfiles` (`IdPerfil`),
  CONSTRAINT `usuario_perfiles_ibfk_2` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario_perfiles`
--

LOCK TABLES `usuario_perfiles` WRITE;
/*!40000 ALTER TABLE `usuario_perfiles` DISABLE KEYS */;
INSERT INTO `usuario_perfiles` VALUES (2,2,1),(3,2,1),(8,3,1),(9,2,1),(11,1,1),(12,2,1),(13,1,1),(14,1,1),(15,1,1),(17,1,1),(18,2,1),(19,2,1);
/*!40000 ALTER TABLE `usuario_perfiles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-13 19:01:25
