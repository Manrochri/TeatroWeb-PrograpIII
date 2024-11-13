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
-- Dumping data for table `categoriacurso`
--

LOCK TABLES `categoriacurso` WRITE;
/*!40000 ALTER TABLE `categoriacurso` DISABLE KEYS */;
INSERT INTO `categoriacurso` VALUES (1,'Clowns',1),(4,'Experto',1);
/*!40000 ALTER TABLE `categoriacurso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `curso`
--

LOCK TABLES `curso` WRITE;
/*!40000 ALTER TABLE `curso` DISABLE KEYS */;
INSERT INTO `curso` VALUES (1,'Vocalizacion basica','2024-10-30 03:28:24',50,'2024-10-29','2024-12-29',200.00,1,1,1,1,1),(2,'Clown','2024-10-30 16:07:46',80,'2024-10-30','2024-12-30',100.00,1,1,1,1,1),(3,'teatro 1','2024-10-30 21:08:16',60,'2024-10-31','2025-01-31',100.00,1,1,1,1,1);
/*!40000 ALTER TABLE `curso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `curso_docente`
--

LOCK TABLES `curso_docente` WRITE;
/*!40000 ALTER TABLE `curso_docente` DISABLE KEYS */;
INSERT INTO `curso_docente` VALUES (1,1),(1,2),(1,3),(2,3),(1,4),(2,4);
/*!40000 ALTER TABLE `curso_docente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `docente`
--

LOCK TABLES `docente` WRITE;
/*!40000 ALTER TABLE `docente` DISABLE KEYS */;
INSERT INTO `docente` VALUES (1,12,1,'Hola hola',1,'Pepe'),(2,3,2,'123',1,'Carlos'),(3,3,1,'adasd',1,'Fernando '),(4,18,3,'adas',1,'Juan 1');
/*!40000 ALTER TABLE `docente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `duracioncurso`
--

LOCK TABLES `duracioncurso` WRITE;
/*!40000 ALTER TABLE `duracioncurso` DISABLE KEYS */;
INSERT INTO `duracioncurso` VALUES (1,'2 meses',1);
/*!40000 ALTER TABLE `duracioncurso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `gradoacademico`
--

LOCK TABLES `gradoacademico` WRITE;
/*!40000 ALTER TABLE `gradoacademico` DISABLE KEYS */;
INSERT INTO `gradoacademico` VALUES (1,'Bachiller',1),(2,'Licenciado',1),(3,'Magíster',1),(4,'Doctorado',1);
/*!40000 ALTER TABLE `gradoacademico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `idiomacurso`
--

LOCK TABLES `idiomacurso` WRITE;
/*!40000 ALTER TABLE `idiomacurso` DISABLE KEYS */;
INSERT INTO `idiomacurso` VALUES (1,'English',1);
/*!40000 ALTER TABLE `idiomacurso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `opcionesmenu`
--

LOCK TABLES `opcionesmenu` WRITE;
/*!40000 ALTER TABLE `opcionesmenu` DISABLE KEYS */;
/*!40000 ALTER TABLE `opcionesmenu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `opcionesmenu_perfiles`
--

LOCK TABLES `opcionesmenu_perfiles` WRITE;
/*!40000 ALTER TABLE `opcionesmenu_perfiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `opcionesmenu_perfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `perfiles`
--

LOCK TABLES `perfiles` WRITE;
/*!40000 ALTER TABLE `perfiles` DISABLE KEYS */;
INSERT INTO `perfiles` VALUES (1,'Administrador','Perfil con acceso completo a todas las funcionalidades del sistema',1),(2,'Docente','Perfil del docente para crear tareas, calificaciones y subir materiales',1),(3,'Estudiante','Perfil de estudiante',1),(4,'Invitado','Perfil de invitado ',1),(5,'VIP 2','Este perfil es VIP',1),(6,'Desarrollador','Perfil para el desarrollador de la página web',1),(7,'Host temporal ','Host temporal prueba',1);
/*!40000 ALTER TABLE `perfiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `rangoedadescurso`
--

LOCK TABLES `rangoedadescurso` WRITE;
/*!40000 ALTER TABLE `rangoedadescurso` DISABLE KEYS */;
INSERT INTO `rangoedadescurso` VALUES (1,'18-30',1);
/*!40000 ALTER TABLE `rangoedadescurso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sesion`
--

LOCK TABLES `sesion` WRITE;
/*!40000 ALTER TABLE `sesion` DISABLE KEYS */;
INSERT INTO `sesion` VALUES (1,1,1,'introduccion a la vocalización',1,'2024-11-29',1);
/*!40000 ALTER TABLE `sesion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tiposesion`
--

LOCK TABLES `tiposesion` WRITE;
/*!40000 ALTER TABLE `tiposesion` DISABLE KEYS */;
INSERT INTO `tiposesion` VALUES (1,'Teórico',1),(2,'práctico',1),(3,'mixto',1);
/*!40000 ALTER TABLE `tiposesion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (2,'98865752','Jeniffer','Karen','Miroquesada','12345678','jenni@correo.com','456',1,'2024-09-29 19:50:58',1,'2024-10-22 23:19:34',1),(3,'7654321','Max','Verstappen','awdaf','1234212','max@gmail.com','1234',3,'2024-09-29 21:40:11',3,'2024-09-29 21:40:11',1),(8,'75231045','Rayo','Mcqeen','Piston','78564235','mcqueen@correo.com','123',8,'2024-10-06 23:01:33',8,'2024-10-06 23:01:33',1),(9,'85312754','Michael','Schumacher','Ferrari','985321746','michael@correo.com','789',9,'2024-10-07 21:38:32',9,'2024-10-15 17:22:02',1),(11,'75229066','Christian','Rodriguez','Chilet','982537856','christian@correo.com','$2a$10$2fSindppAdHyXGA5munchO2hplw5x4s34bVMc68WxXVEYRQ5Ki5VG',11,'2024-10-15 16:57:21',11,'2024-10-15 16:57:21',1),(12,'75229067','Pepe','Mendoza','Dominguez','785652315','pepe@gmail.com','$2a$10$VXlVRWcAThX5DG1L4DUm/OGr17TfJB67VI3o9AMzlBOkLk3qADfDK',12,'2024-10-16 01:04:56',12,'2024-10-16 01:04:56',1),(13,'78567689','Mario','Bros','Nintendo','985995689','mario@nintendo.com','$2a$10$yjpLHophEzHArzbU4HFrSOaA4o4O86ibDtsPe19H8lDnClJMhshvu',13,'2024-10-16 21:50:36',13,'2024-10-16 21:50:36',1),(14,'12325468','Romel','Palomino',NULL,NULL,'Romel@correo.com','clave_generica',NULL,'2024-10-22 20:45:08',NULL,'2024-10-22 20:46:43',1),(15,'12345862','Hugo','Michael',NULL,NULL,'hugo@gmail.com','clave_generica',NULL,'2024-10-22 21:25:36',NULL,NULL,1),(17,'5678223','Julio','Roberto','Leones',NULL,'noel@gmail.com','clave_generica',NULL,'2024-10-22 21:45:56',NULL,'2024-10-22 21:59:17',1),(18,'20202020','Juan','Perez','Perez',NULL,'juanperez@correo.com','clave_generica',NULL,'2024-10-30 15:52:23',NULL,NULL,1),(19,'30303030','Juan','Rojas','Rojas',NULL,'juanrojas@correo.com','clave_generica',NULL,'2024-10-30 15:54:22',NULL,NULL,1);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

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

-- Dump completed on 2024-11-13  0:41:26
