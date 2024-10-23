-- Base de datos : teatroweb
-- Creación de la tabla Usuario
CREATE TABLE Usuario (
    IdUsuario INT AUTO_INCREMENT PRIMARY KEY,
    DNI VARCHAR(15) NOT NULL,
    Nombres VARCHAR(40) NOT NULL,
    ApellidoPaterno VARCHAR(40) NOT NULL,
    ApellidoMaterno VARCHAR(40),
    Celular VARCHAR(15),
    CorreoElectronico VARCHAR(40) NOT NULL,
    Clave VARCHAR(60) NOT NULL,
    UsuarioCreacion INT,
    FechaCreacion DATETIME NOT NULL,
    UsuarioModificacion INT,
    FechaModificacion DATETIME,
    EstadoRegistro BOOLEAN NOT NULL
);

-- Creación de la tabla Perfiles
CREATE TABLE Perfiles (
    IdPerfil INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(500),
    EstadoRegistro BOOLEAN NOT NULL
);

-- Creación de la tabla OpcionesMenu
CREATE TABLE OpcionesMenu (
    IdOpcionMenu INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    UrlMenu VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(100),
    IdPadre INT,
    EstadoRegistro BOOLEAN NOT NULL,
    FOREIGN KEY (IdPadre) REFERENCES OpcionesMenu(IdOpcionMenu)
);

-- Creación de la tabla intermedia Usuario_Perfiles
CREATE TABLE Usuario_Perfiles (
    IdUsuario INT NOT NULL,
    IdPerfil INT NOT NULL,
    EstadoRegistro BOOLEAN NOT NULL,
    PRIMARY KEY (IdUsuario, IdPerfil),
    FOREIGN KEY (IdPerfil) REFERENCES Perfiles(IdPerfil),
    FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario)
);

-- Creación de la tabla intermedia OpcionesMenu_Perfiles
CREATE TABLE OpcionesMenu_Perfiles (
    IdOpcionMenu INT NOT NULL,
    IdPerfil INT NOT NULL,
    Orden TINYINT NOT NULL,
    EstadoRegistro BOOLEAN NOT NULL,
    PRIMARY KEY (IdOpcionMenu, IdPerfil),
    FOREIGN KEY (IdOpcionMenu) REFERENCES OpcionesMenu(IdOpcionMenu),
    FOREIGN KEY (IdPerfil) REFERENCES Perfiles(IdPerfil)
);


-- Creación de tabla GradoAcademico
CREATE TABLE GradoAcademico (
    IdGradoAcademico INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL
    EstadoRegistro BOOLEAN NOT NULL
);
-- Creación de tabla Docente

CREATE TABLE Docente (
    IdDocente INT AUTO_INCREMENT PRIMARY KEY,
    IdUsuario INT NOT NULL,
    IdGradoAcademico INT NOT NULL,
    Descripcion TEXT,
    FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario),
    FOREIGN KEY (IdGradoAcademico) REFERENCES GradoAcademico(IdGradoAcademico)
);


-- Crear tablas maestras de CURSO
CREATE TABLE CategoriaCurso (
    IdCategoria INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    EstadoRegistro BOOLEAN NOT NULL
);

CREATE TABLE DuracionCurso (
    IdDuracion INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    EstadoRegistro BOOLEAN NOT NULL
);

CREATE TABLE IdiomaCurso (
    IdIdioma INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    EstadoRegistro BOOLEAN NOT NULL
);

CREATE TABLE RangoEdadesCurso (
    IdRango INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL,
    EstadoRegistro BOOLEAN NOT NULL
);

-- Crear tabla Curso
CREATE TABLE Curso (
    IdCurso INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    FechaRegistro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Capacidad INT NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL,
    IdCategoria INT NOT NULL,
    IdDuracion INT NOT NULL,
    IdIdioma INT NOT NULL,
    IdRango INT NOT NULL,
    EstadoRegistro BOOLEAN NOT NULL,
    FOREIGN KEY (IdCategoria) REFERENCES CategoriaCurso(IdCategoria),
    FOREIGN KEY (IdDuracion) REFERENCES DuracionCurso(IdDuracion),
    FOREIGN KEY (IdIdioma) REFERENCES IdiomaCurso(IdIdioma),
    FOREIGN KEY (IdRango) REFERENCES RangoEdadesCurso(IdRango)
);

-- Crear tabla intermedia para relación muchos a muchos entre Curso y Docentes
CREATE TABLE Curso_Docentes (
    IdCurso INT NOT NULL,
    IdDocente INT NOT NULL,
    PRIMARY KEY (IdCurso, IdDocente),
    FOREIGN KEY (IdCurso) REFERENCES Curso(IdCurso),
    FOREIGN KEY (IdDocente) REFERENCES Docente(IdDocente)
);

-- Inserción de datos en la tabla Perfiles
INSERT INTO Perfiles (Nombre, Descripcion, EstadoRegistro)
VALUES
('Administrador', 'Usuario con acceso completo a todas las funciones del sistema.', 1),
('Usuario', 'Usuario estándar con acceso limitado a ciertas funciones.', 1),
('Moderador', 'Usuario con permisos para gestionar contenidos y usuarios.', 1),
('Invitado', 'Usuario con acceso temporal y permisos muy limitados.', 1);

-- Inserción de grado académico

INSERT INTO GradoAcademico (Nombre, EstadoRegistro)
VALUES
('Bachiller', 1),
('Licenciado', 1),
('Magíster', 1),
('Doctorado', 1);
