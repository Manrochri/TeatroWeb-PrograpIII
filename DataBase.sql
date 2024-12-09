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
-- Table structure for table `alumno`
--

DROP TABLE IF EXISTS `alumno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alumno` (
  `IdAlumno` int NOT NULL AUTO_INCREMENT,
  `IdUsuario` int NOT NULL,
  `IdIdioma` int NOT NULL,
  PRIMARY KEY (`IdAlumno`),
  KEY `IdUsuario` (`IdUsuario`),
  KEY `IdIdioma` (`IdIdioma`),
  CONSTRAINT `alumno_ibfk_1` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`),
  CONSTRAINT `alumno_ibfk_2` FOREIGN KEY (`IdIdioma`) REFERENCES `idiomacurso` (`IdIdioma`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumno`
--

LOCK TABLES `alumno` WRITE;
/*!40000 ALTER TABLE `alumno` DISABLE KEYS */;
INSERT INTO `alumno` VALUES (1,56,1),(2,30,2);
/*!40000 ALTER TABLE `alumno` ENABLE KEYS */;
UNLOCK TABLES;

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
INSERT INTO `categoriacurso` VALUES (1,'CLOWNS',1),(4,'VOCALIZACIÓN',1);
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
INSERT INTO `curso` VALUES (1,'VOCALIZACION BASICA','2024-10-30 03:28:24',50,'2024-10-29','2024-12-29',200.00,4,1,1,1,1),(2,'CLOWN','2024-10-30 16:07:46',80,'2024-10-30','2024-12-30',100.00,1,1,2,1,1),(3,'TEATRO 1','2024-10-30 21:08:16',60,'2024-10-31','2025-01-31',100.00,1,1,1,1,1),(4,'MIMO','2024-11-13 06:43:02',200,'2024-10-29','2024-11-01',132.00,4,1,1,1,0);
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
  `EstadoRegistro` tinyint(1) DEFAULT '1',
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
INSERT INTO `curso_docente` VALUES (1,1,1),(1,2,1),(1,3,1),(1,4,1),(2,3,1),(2,4,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `docente`
--

LOCK TABLES `docente` WRITE;
/*!40000 ALTER TABLE `docente` DISABLE KEYS */;
INSERT INTO `docente` VALUES (1,12,1,'Hola hola',1,'Pepe'),(2,3,2,'123',1,'Carlos'),(3,3,1,'adasd',1,'Fernando '),(4,18,3,'adas',1,'Juan 1'),(5,3,2,'',1,'Max Verstappen'),(6,18,2,'hola',1,'Juan Perez'),(7,12,1,'Testing\r\n',1,'Pepe Mendoza'),(8,9,2,'',1,'Michael Schumacher'),(9,9,1,'qqq',1,'Michael Schumacher'),(10,3,2,'as',1,'Max Verstappen');
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
INSERT INTO `duracioncurso` VALUES (1,'2 MESES',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estadosasistencia`
--

LOCK TABLES `estadosasistencia` WRITE;
/*!40000 ALTER TABLE `estadosasistencia` DISABLE KEYS */;
INSERT INTO `estadosasistencia` VALUES (1,'ASISTIÓ',1),(2,'FALTÓ',1),(3,'JUSTIFICÓ',1),(4,'Vacío',0),(5,'dwd',0),(6,'VACÍO',0);
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
INSERT INTO `gradoacademico` VALUES (1,'BACHILLER',1),(2,'LICENCIADO',1),(3,'MAGÍSTER',1),(4,'Doctorado',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `idiomacurso`
--

LOCK TABLES `idiomacurso` WRITE;
/*!40000 ALTER TABLE `idiomacurso` DISABLE KEYS */;
INSERT INTO `idiomacurso` VALUES (1,'English',1),(2,'Español',1),(4,'PORTUGUÉS',0);
/*!40000 ALTER TABLE `idiomacurso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matriculas`
--

DROP TABLE IF EXISTS `matriculas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matriculas` (
  `IdMatricula` int NOT NULL AUTO_INCREMENT,
  `IdAlumno` int NOT NULL,
  `IdCurso` int NOT NULL,
  `FechaMatricula` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `EstadoRegistro` tinyint(1) NOT NULL,
  PRIMARY KEY (`IdMatricula`),
  KEY `IdAlumno` (`IdAlumno`),
  KEY `IdCurso` (`IdCurso`),
  CONSTRAINT `matriculas_ibfk_1` FOREIGN KEY (`IdAlumno`) REFERENCES `alumno` (`IdAlumno`),
  CONSTRAINT `matriculas_ibfk_2` FOREIGN KEY (`IdCurso`) REFERENCES `curso` (`IdCurso`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matriculas`
--

LOCK TABLES `matriculas` WRITE;
/*!40000 ALTER TABLE `matriculas` DISABLE KEYS */;
INSERT INTO `matriculas` VALUES (1,1,2,'2024-12-05 00:00:00',1),(2,1,1,'2024-12-01 00:00:00',0),(3,1,2,'2024-12-01 00:00:00',0),(4,1,1,'2024-11-29 00:00:00',1);
/*!40000 ALTER TABLE `matriculas` ENABLE KEYS */;
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
INSERT INTO `perfiles` VALUES (1,'ADMINISTRADOR','PERFIL CON ACCESO COMPLETO A TODAS LAS FUNCIONALIDADES DEL SISTEMA',1),(2,'DOCENTE','PERFIL DEL DOCENTE PARA CREAR TAREAS, CALIFICACIONES Y SUBIR MATERIALES',1),(3,'ESTUDIANTE','PERFIL DE ESTUDIANTE',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `redessociales`
--

LOCK TABLES `redessociales` WRITE;
/*!40000 ALTER TABLE `redessociales` DISABLE KEYS */;
INSERT INTO `redessociales` VALUES (1,'FACEBOOK',1),(2,'INSTAGRAM',1),(3,'YOUTUBE',1),(4,'WHATSSAP',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sesion`
--

LOCK TABLES `sesion` WRITE;
/*!40000 ALTER TABLE `sesion` DISABLE KEYS */;
INSERT INTO `sesion` VALUES (1,1,1,'SESION 1 (VOCALIZACIÓN BÁSICA)',2,'2024-12-04',1),(2,1,2,'Sesion 2 (Vocalización Básica)',1,'2024-12-04',1),(3,1,3,'Sesion 3 (Vocalización Básica)',1,'2024-12-04',1),(4,1,4,'Sesion 4 (Vocalización Básica)',1,'2024-12-04',1),(5,1,5,'Sesion 5 (Vocalización Básica)',1,'2024-12-04',1),(6,1,6,'Sesion 6 (Vocalización Básica)',1,'2024-12-04',1),(7,1,7,'Sesion 7 (Vocalización Básica)',1,'2024-12-04',1),(8,1,8,'Sesion 8 (Vocalización Básica)',1,'2024-12-04',1),(9,1,9,'Sesion 9 (Vocalización Básica)',1,'2024-12-04',1),(10,1,10,'Sesion 10 (Vocalización Básica)',1,'2024-12-04',1),(11,1,11,'Sesion 11 (Vocalización Básica)',1,'2024-12-04',1),(12,1,12,'Sesion 12 (Vocalización Básica)',1,'2024-12-04',1),(13,1,13,'Sesion 13 (Vocalización Básica)',1,'2024-12-04',1),(14,1,14,'Sesion 14 (Vocalización Básica)',1,'2024-12-04',1),(15,1,15,'Sesion 15 (Vocalización Básica)',1,'2024-12-04',1),(16,1,16,'Sesion 16 (Vocalización Básica)',1,'2024-12-04',1),(17,2,1,'Sesion 1 (Clown)',1,'2024-12-04',1),(18,2,2,'Sesion 2 (Clown)',1,'2024-12-04',1),(19,2,3,'Sesion 3 (Clown)',1,'2024-12-04',1),(20,2,4,'Sesion 4 (Clown)',1,'2024-12-04',1),(21,2,5,'Sesion 5 (Clown)',1,'2024-12-04',1),(22,2,6,'Sesion 6 (Clown)',1,'2024-12-04',1),(23,2,7,'Sesion 7 (Clown)',1,'2024-12-04',1),(24,2,8,'Sesion 8 (Clown)',1,'2024-12-04',1),(25,2,9,'Sesion 9 (Clown)',1,'2024-12-04',1),(26,2,10,'Sesion 10 (Clown)',1,'2024-12-04',1),(27,2,11,'Sesion 11 (Clown)',1,'2024-12-04',1),(28,2,12,'Sesion 12 (Clown)',1,'2024-12-04',1),(29,2,13,'Sesion 13 (Clown)',1,'2024-12-04',1),(30,2,14,'Sesion 14 (Clown)',1,'2024-12-04',1),(31,2,15,'Sesion 15 (Clown)',1,'2024-12-04',1),(32,2,16,'Sesion 16 (Clown)',1,'2024-12-04',1),(33,3,1,'Sesion 1 (Teatro)',1,'2024-12-04',1),(34,3,2,'Sesion 2 (Teatro)',1,'2024-12-04',1),(35,3,3,'Sesion 3 (Teatro)',1,'2024-12-04',1),(36,3,4,'Sesion 4 (Teatro)',1,'2024-12-04',1),(37,3,5,'Sesion 5 (Teatro)',1,'2024-12-04',1),(38,3,6,'Sesion 6 (Teatro)',1,'2024-12-04',1),(39,3,7,'Sesion 7 (Teatro)',1,'2024-12-04',1),(40,3,8,'Sesion 8 (Teatro)',1,'2024-12-04',1),(41,3,9,'Sesion 9 (Teatro)',1,'2024-12-04',1),(42,3,10,'Sesion 10 (Teatro)',1,'2024-12-04',1),(43,3,11,'Sesion 11 (Teatro)',1,'2024-12-04',1),(44,3,12,'Sesion 12 (Teatro)',1,'2024-12-04',1),(45,3,13,'Sesion 13 (Teatro)',1,'2024-12-04',1),(46,3,14,'Sesion 14 (Teatro)',1,'2024-12-04',1),(47,3,15,'Sesion 15 (Teatro)',1,'2024-12-04',1),(48,3,16,'Sesion 16 (Teatro)',1,'2024-12-04',1),(49,4,1,'Sesion 1 (Mimo)',1,'2024-12-04',1),(50,4,2,'Sesion 2 (Mimo)',1,'2024-12-04',1),(51,4,3,'Sesion 3 (Mimo)',1,'2024-12-04',1),(52,4,4,'Sesion 4 (Mimo)',1,'2024-12-04',1),(53,4,5,'Sesion 5 (Mimo)',1,'2024-12-04',1),(54,4,6,'Sesion 6 (Mimo)',1,'2024-12-04',1),(55,4,7,'Sesion 7 (Mimo)',1,'2024-12-04',1),(56,4,8,'Sesion 8 (Mimo)',1,'2024-12-04',1),(57,4,9,'Sesion 9 (Mimo)',1,'2024-12-04',1),(58,4,10,'Sesion 10 (Mimo)',1,'2024-12-04',1),(59,4,11,'Sesion 11 (Mimo)',1,'2024-12-04',1),(60,4,12,'Sesion 12 (Mimo)',1,'2024-12-04',1),(61,4,13,'Sesion 13 (Mimo)',1,'2024-12-04',1),(62,4,14,'Sesion 14 (Mimo)',1,'2024-12-04',1),(63,4,15,'Sesion 15 (Mimo)',1,'2024-12-04',1),(64,4,16,'Sesion 16 (Mimo)',1,'2024-12-04',1);
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
INSERT INTO `tiposesion` VALUES (1,'TEÓRICO',1),(2,'PRÁCTICO',1),(3,'MIXTO',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (2,'38865754','JENIFFER','KAREN','MIROQUESADA','12345678','JENNI@CORREO.COM','456',1,'2024-09-29 19:50:58',1,'2024-12-04 01:00:31',1),(3,'7654321','Max','Verstappen','awdaf','1234212','max@gmail.com','1234',3,'2024-09-29 21:40:11',3,'2024-09-29 21:40:11',1),(8,'75231045','Rayo','Mcqeen','Piston','78564235','mcqueen@correo.com','123',8,'2024-10-06 23:01:33',8,'2024-10-06 23:01:33',1),(9,'85312754','Michael','Schumacher','Ferrari','985321746','michael@correo.com','789',9,'2024-10-07 21:38:32',9,'2024-10-15 17:22:02',1),(11,'75229066','Christian','Rodriguez','Chilet','982537856','christian@correo.com','$2a$10$2fSindppAdHyXGA5munchO2hplw5x4s34bVMc68WxXVEYRQ5Ki5VG',11,'2024-10-15 16:57:21',11,'2024-10-15 16:57:21',1),(12,'75229067','Pepe','Mendoza','Dominguez','785652315','pepe@gmail.com','$2a$10$VXlVRWcAThX5DG1L4DUm/OGr17TfJB67VI3o9AMzlBOkLk3qADfDK',12,'2024-10-16 01:04:56',12,'2024-10-16 01:04:56',1),(13,'78567689','MARIO','BROS','NINTENDO','985995689','MARIO@NINTENDO.COM','$2a$10$yjpLHophEzHArzbU4HFrSOaA4o4O86ibDtsPe19H8lDnClJMhshvu',13,'2024-10-16 21:50:36',13,'2024-12-02 19:56:19',1),(14,'12325468','Romel','Palomino',NULL,NULL,'Romel@correo.com','clave_generica',NULL,'2024-10-22 20:45:08',NULL,'2024-10-22 20:46:43',1),(15,'12345862','Hugo','Michael',NULL,NULL,'hugo@gmail.com','clave_generica',NULL,'2024-10-22 21:25:36',NULL,NULL,1),(17,'5678223','JULIO','ROBERTO','LEONES',NULL,'NOEL@GMAIL.COM','clave_generica',NULL,'2024-10-22 21:45:56',NULL,'2024-12-02 00:05:57',1),(18,'20202020','JUAN','PEREZ','PEREZ',NULL,'JUANPEREZ@CORREO.COM','clave_generica',NULL,'2024-10-30 15:52:23',NULL,'2024-12-02 00:04:32',1),(19,'30303030','JUAN','ROJAS','ROJAS',NULL,'JUANROJAS@CORREO.COM','clave_generica',NULL,'2024-10-30 15:54:22',NULL,'2024-12-02 00:04:17',1),(20,'65242347','FABIOLA','FULANO','SULTANO',NULL,'FABIOLA@GMAIL.COM','clave_generica',NULL,'2024-11-20 16:14:17',NULL,NULL,1),(21,'75326345','FULTANITO','SULTANITO','MELGANITO','123874956','MELGANITO@CORREO.COM','$2a$10$JJBRuptxwlLVvT2Yl0KsDOKjdtCv.O48cVZ6CYw0sCF0TKeUuqhO.',21,'2024-11-20 16:21:59',21,'2024-11-20 16:21:59',1),(22,'752310345','PRUEBA','PRUEBITA ','PRUEBITA','4523265','PRUEBA@GMAIL.COM','$2a$10$MKXJPHLANP4Xkk/WaaJgJ.QBtAhhvjsqDM8r8sEZsQrzZTL8jw2QK',22,'2024-11-20 16:24:57',22,'2024-11-20 16:24:57',1),(23,'9865632','PRUEBA 2 ','TRIGGER','FUNCIONA','985632185','TRIGGER@FUNCIONA.COM','$2a$10$3o.gvMSx2rQ0bY7p/nuNxO7nXu5lAcsHOVYGQix.8gVmARwdzNkmO',23,'2024-11-20 16:33:50',23,'2024-11-20 16:33:50',1),(24,'75229852','PRUEBA','DEFINITIVA','TRIGGER','1234','DEFINITIVO@GMAIL.COM','$2a$10$HA5l2LaHIjIavbD3nPTg8.LpMH7BKcsgBZ3LN.fyRqnxRZdkpENdG',24,'2024-11-20 16:37:41',24,'2024-11-20 16:37:41',1),(25,'865324','CHRISTIAN','ESTUDIANTE','CHILET','12345','ESTUDIANTECHRIS@GMAIL.COM','$2a$10$it/Tga0hqlWKgVflYldpEu5UTK2zJZa3uWimfgXS6nQ6PIypmQJI.',25,'2024-11-20 16:39:53',25,'2024-11-20 16:39:53',1),(26,'78854865','JUANCITO','PEREZ','PEREZ',NULL,'JUANCITO@CORREO.COM','clave_generica',NULL,'2024-11-20 17:41:32',NULL,NULL,1),(27,'45232568','BENITO','PEREZ','DOMINGUEZ','986524879','BENITO@GMAIL.COM','$2a$10$VadncVQDV1Dxdjgjg0GCYeJF6PX4SUTqvVvY5jiHFllkueDltZ.46',27,'2024-12-01 23:29:21',27,'2024-12-04 10:34:23',1),(28,'75229068','CARLITOS','SAINZ','SAINZ','985587986','SAINZ@GMAIL.COM','$2a$10$67dWzXbMO2ZgfH6YsH..CuqQZoqz2Jo4Iahx0cni.uCYMgaTPj50a',28,'2024-12-01 23:30:51',28,'2024-12-02 00:14:29',1),(29,'98563258','YUKI','ZUNODA','ZUNODA','996532487','YUKI@GMAIL.COM','$2a$10$Kd36AqQwLyefDKGEaM9pRe1vfv/EbuY3dThU2ODiiBQBKApi75QIe',29,'2024-12-01 23:32:31',29,'2024-12-01 23:32:31',1),(30,'75229075','MARTIN','HILARIO','FULANO','9859654325','MARTIN@GMAIL.COM','$2a$10$TuuseuGL0RhecF2BTrjJROkG6MtJ4jEiZX.c6PKnYT8Dt.eNd2m7S',30,'2024-12-01 23:38:46',30,'2024-12-01 23:38:46',1),(31,'85965325','SERAFIN','FULANO','ZULTANO','975986324','SERAFIN@GMAIL.COM','$2a$10$kj9e0vTnARJA4k0lA6eNkORsvfnXQYGlYAH1qV3v0gpfYnJDdB972',31,'2024-12-01 23:42:18',31,'2024-12-01 23:42:18',1),(32,'78565248','FULANO','FULANITO','MELGANO','985896325','FULANO01@GMAIL.COM','$2a$10$rKwftpcOwXQqxYSETs2jAOdVG88brYF.3feYiwwfD7xsOde6rxaOS',32,'2024-12-01 23:58:45',32,'2024-12-04 16:34:33',1),(33,'9856265','PEPITO','FULANITO','REGISTRITO','985625689','pepito@gmail.com','$2a$10$FlibX7FFkSfXnk.LYdzOFOd3P99CQzWwZLUiGS2Oky5H0dXYEt3FO',33,'2024-12-03 22:22:30',33,'2024-12-03 22:22:30',1),(41,'98562329','FULANO','JULES','DIAZ','982537856','MAX@GMAIL.COM','$2a$10$HkvUzDguv2YeXsp2f/ag/uE/ZhXiwGj/MrM62nrGoeQMWJ3zkZQL2',41,'2024-12-03 23:07:12',41,'2024-12-04 16:18:27',1),(54,'85229033','PEPE','KAREN','DIAZ','999999999','charles@correo.com','$2a$10$Uw0DHYAAFaV9DyRq5zlam.q5JTuhJ4ipKgHy60LHQNEXJFCM43gNu',54,'2024-12-04 01:03:29',54,'2024-12-04 01:03:29',1),(55,'96325698','PEPELUX','NUÑEZ','PEPEX','985642314','pepelux@gmail.com','$2a$10$bx0WVmgFH6OnEbcOV3zLqeqzY9wOTPu6tbbwUB7dNqzlCXqYGzCKm',55,'2024-12-04 01:04:50',55,'2024-12-04 01:04:50',1),(56,'98765432','ALICE','SMITH','JOHNSON','987654321','ALICE.SMITH@EMAIL.COM','password1',1,'2024-11-30 10:00:00',1,'2024-12-04 10:39:03',1),(57,'98765432','Alice','Smith','Johnson','987654321','alice.smith@email.com','password1',1,'2024-11-30 10:00:00',1,'2024-11-30 10:00:00',1),(58,'87654321','Bob','Johnson','Brown','876543210','bob.johnson@email.com','password2',1,'2024-11-30 10:05:00',1,'2024-11-30 10:05:00',1),(59,'76543210','Charlie','Williams','Taylor','765432109','charlie.williams@email.com','password3',1,'2024-11-30 10:10:00',1,'2024-11-30 10:10:00',1),(60,'65432109','David','Brown','Wilson','654321098','david.brown@email.com','password4',1,'2024-11-30 10:15:00',1,'2024-11-30 10:15:00',1),(61,'54321098','Eve','Miller','Moore','543210987','eve.miller@email.com','password5',1,'2024-11-30 10:20:00',1,'2024-11-30 10:20:00',1),(62,'43210987','Frank','Taylor','Anderson','432109876','frank.taylor@email.com','password6',1,'2024-11-30 10:25:00',1,'2024-11-30 10:25:00',1),(63,'32109876','Grace','Thomas','Jackson','321098765','grace.thomas@email.com','password7',1,'2024-11-30 10:30:00',1,'2024-11-30 10:30:00',1),(64,'21098765','Hank','Anderson','White','210987654','hank.anderson@email.com','password8',1,'2024-11-30 10:35:00',1,'2024-11-30 10:35:00',1),(65,'10987654','Ivy','Jackson','Martin','109876543','ivy.jackson@email.com','password9',1,'2024-11-30 10:40:00',1,'2024-11-30 10:40:00',1),(66,'98765431','John','White','Clark','987654321','john.white@email.com','password10',1,'2024-11-30 10:45:00',1,'2024-11-30 10:45:00',1),(67,'87654320','Katie','Clark','Rodriguez','876543210','katie.clark@email.com','password11',1,'2024-11-30 10:50:00',1,'2024-11-30 10:50:00',1),(68,'76543209','Liam','Rodriguez','Lewis','765432109','liam.rodriguez@email.com','password12',1,'2024-11-30 10:55:00',1,'2024-11-30 10:55:00',1),(69,'65432108','Mia','Lewis','Scott','654321098','mia.lewis@email.com','password13',1,'2024-11-30 11:00:00',1,'2024-11-30 11:00:00',1),(70,'54321097','Noah','Scott','Adams','543210987','noah.scott@email.com','password14',1,'2024-11-30 11:05:00',1,'2024-11-30 11:05:00',1),(71,'43210976','Olivia','Adams','Baker','432109876','olivia.adams@email.com','password15',1,'2024-11-30 11:10:00',1,'2024-11-30 11:10:00',1),(72,'32109865','Peter','Baker','Carter','321098765','peter.baker@email.com','password16',1,'2024-11-30 11:15:00',1,'2024-11-30 11:15:00',1),(73,'21098754','Quinn','Carter','Perez','210987654','quinn.carter@email.com','password17',1,'2024-11-30 11:20:00',1,'2024-11-30 11:20:00',1),(74,'10987643','Ryan','Perez','Nelson','109876543','ryan.perez@email.com','password18',1,'2024-11-30 11:25:00',1,'2024-11-30 11:25:00',1),(75,'98765430','Sophia','Nelson','Young','987654321','sophia.nelson@email.com','password19',1,'2024-11-30 11:30:00',1,'2024-11-30 11:30:00',1),(76,'87654319','Thomas','Young','King','876543210','thomas.young@email.com','password20',1,'2024-11-30 11:35:00',1,'2024-11-30 11:35:00',1),(77,'9856987','MILES','MORALES','MORALES',NULL,'MILES@GMAIL.COM','clave_generica',NULL,'2024-12-04 01:14:59',NULL,NULL,1),(78,'75229068','PEPE','DOCENTE','JUAREZ','96366589','pepe_docente@gmail.com','$2a$10$cOBrsX2DEVH3G1g927/qKeUAjlMdWRTOt8vZ1Vv/qukfsYSe9Y9Pq',78,'2024-12-04 17:52:32',78,'2024-12-04 17:52:32',1),(79,'95996896','TESTING1','TEST','TESTING','98986589','testing@gmail.com','$2a$10$U2YMGAMeiWscI3N.7/jU4.S49whE6h502.dIsTUFhykoo.R8BX30e',79,'2024-12-08 20:20:11',79,'2024-12-08 20:20:11',1);
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
INSERT INTO `usuario_perfiles` VALUES (2,1,1),(3,2,1),(8,3,1),(9,2,1),(11,1,1),(12,2,1),(13,3,1),(14,1,1),(15,1,1),(17,1,1),(18,2,1),(19,1,1),(20,3,1),(21,3,1),(22,3,1),(23,3,1),(24,3,1),(25,3,1),(26,3,1),(27,3,1),(28,2,1),(29,1,1),(30,1,1),(31,1,1),(32,2,1),(33,1,1),(41,2,1),(54,1,1),(55,1,1),(56,3,1),(77,3,1),(78,2,1),(79,1,1);
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

-- Dump completed on 2024-12-08 20:24:08
