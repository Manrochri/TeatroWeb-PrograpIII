<%@page import="modelo.Conexion"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("perfil") == null
            || !"Administrador".equals(session.getAttribute("perfil"))) {
        response.sendRedirect("errorAcceso.jsp");
        return;
    }

    // Obteniendo el nombre del usuario y su rol desde la sesión
    String nombreUsuario = (String) session.getAttribute("nombre");
    String rolUsuario = (String) session.getAttribute("perfil");

    // Conexión a la base de datos para obtener los usuarios, perfiles y grados académicos
    Connection con = Conexion.getConnection();

    // Obtener usuarios
    PreparedStatement psUsuarios = con.prepareStatement("SELECT u.IdUsuario, u.DNI, u.Nombres, u.ApellidoPaterno, u.ApellidoMaterno, u.CorreoElectronico, p.Nombre as Perfil FROM Usuario u JOIN Usuario_Perfiles up ON u.IdUsuario = up.IdUsuario JOIN Perfiles p ON up.IdPerfil = p.IdPerfil WHERE u.EstadoRegistro = 1");
    ResultSet rsUsuarios = psUsuarios.executeQuery();

    // Obtener perfiles
    PreparedStatement psPerfiles = con.prepareStatement("SELECT IdPerfil, Nombre, Descripcion FROM Perfiles WHERE EstadoRegistro = 1");
    ResultSet rsPerfiles = psPerfiles.executeQuery();
    
    // Obtener grados académicos
    PreparedStatement psGrados = con.prepareStatement("SELECT IdGradoAcademico, Nombre FROM GradoAcademico WHERE EstadoRegistro = 1 ");
    ResultSet rsGrados = psGrados.executeQuery();
    
    // Obtener categorías
PreparedStatement psCategorias = con.prepareStatement("SELECT IdCategoria, Nombre FROM CategoriaCurso WHERE EstadoRegistro = 1");
ResultSet rsCategorias = psCategorias.executeQuery();

// Obtener duraciones
PreparedStatement psDuraciones = con.prepareStatement("SELECT IdDuracion, Nombre FROM DuracionCurso WHERE EstadoRegistro = 1");
ResultSet rsDuraciones = psDuraciones.executeQuery();

// Obtener idiomas
PreparedStatement psIdiomas = con.prepareStatement("SELECT IdIdioma, Nombre FROM IdiomaCurso WHERE EstadoRegistro = 1");
ResultSet rsIdiomas = psIdiomas.executeQuery();

// Obtener rangos
PreparedStatement psRangos = con.prepareStatement("SELECT IdRango, Descripcion FROM RangoEdadesCurso WHERE EstadoRegistro = 1");
ResultSet rsRangos = psRangos.executeQuery();

// Obtener curso
    PreparedStatement psCursos = con.prepareStatement(
    "SELECT c.IdCurso, c.Nombre, c.FechaRegistro, c.Capacidad, c.FechaInicio, c.FechaFin, c.Precio, " +
    "cc.Nombre AS Categoria, dc.Nombre AS Duracion, ic.Nombre AS Idioma, rc.Descripcion AS Rango " +
    "FROM Curso c " +
    "JOIN CategoriaCurso cc ON c.IdCategoria = cc.IdCategoria " +
    "JOIN DuracionCurso dc ON c.IdDuracion = dc.IdDuracion " +
    "JOIN IdiomaCurso ic ON c.IdIdioma = ic.IdIdioma " +
    "JOIN RangoEdadesCurso rc ON c.IdRango = rc.IdRango " +
    "WHERE c.EstadoRegistro = 1"
);
ResultSet rsCursos = psCursos.executeQuery();

// Obtener docentes y sus cursos asignados
PreparedStatement psDocentes = con.prepareStatement(
    "SELECT d.IdDocente, u.Nombres, u.ApellidoPaterno, u.ApellidoMaterno, u.CorreoElectronico, c.Nombre AS CursoNombre " +
    "FROM Docente d " +
    "JOIN Usuario u ON d.IdUsuario = u.IdUsuario " +
    "LEFT JOIN curso_docente cd ON d.IdDocente = cd.IdDocente " +
    "LEFT JOIN Curso c ON cd.IdCurso = c.IdCurso " +
    "WHERE d.EstadoRegistro = 1"
);
ResultSet rsDocentes = psDocentes.executeQuery();


%>

<!-- Aquí se agregan los mensajes de éxito o error -->
<%
    String successMessage = request.getParameter("success");
    if (successMessage != null) {
%>
    <div class="alert alert-success mt-3">
        <% 
            if ("usuarioRegistrado".equals(successMessage)) {
                out.print("¡Usuario registrado exitosamente!");
            } else if ("usuarioEditado".equals(successMessage)) {
                out.print("¡Usuario editado exitosamente!");
            } else if ("usuarioEliminado".equals(successMessage)) {
                out.print("¡Usuario eliminado exitosamente!");
            } else if ("perfilRegistrado".equals(successMessage)) {
                out.print("¡Perfil registrado exitosamente!");
            } else if ("perfilEditado".equals(successMessage)) {
                out.print("¡Perfil editado exitosamente!");
            } else if ("perfilEliminado".equals(successMessage)) {
                out.print("¡Perfil eliminado exitosamente!");
            } else if ("gradoRegistrado".equals(successMessage)) {
                out.print("¡Grado académico registrado exitosamente!");
            } else if ("gradoEditado".equals(successMessage)) {
                out.print("¡Grado académico actualizado exitosamente!");
            } else if ("gradoEliminado".equals(successMessage)) {
                out.print("¡Grado académico eliminado exitosamente!");
            }
            else if ("categoriaRegistrada".equals(successMessage)) {
                out.print("¡Categoría registrada exitosamente!");
            } else if ("categoriaEditada".equals(successMessage)) {
                out.print("¡Categoría editada exitosamente!");
            } else if ("categoriaEliminada".equals(successMessage)) {
                out.print("¡Categoría eliminada exitosamente!");
            } else if ("duracionRegistrada".equals(successMessage)) {
                out.print("¡Duración registrada exitosamente!");
            } else if ("duracionEditada".equals(successMessage)) {
                out.print("¡Duración editada exitosamente!");
            } else if ("duracionEliminada".equals(successMessage)) {
                out.print("¡Duración eliminada exitosamente!");
            } else if ("idiomaRegistrado".equals(successMessage)) {
                out.print("¡Idioma registrado exitosamente!");
            } else if ("idiomaEditado".equals(successMessage)) {
                out.print("¡Idioma editado exitosamente!");
            } else if ("idiomaEliminado".equals(successMessage)) {
                out.print("¡Idioma eliminado exitosamente!");
            } else if ("rangoRegistrado".equals(successMessage)) {
                out.print("¡Rango registrado exitosamente!");
            } else if ("rangoEditado".equals(successMessage)) {
                out.print("¡Rango editado exitosamente!");
            } else if ("rangoEliminado".equals(successMessage)) {
                out.print("¡Rango eliminado exitosamente!");
            } else if ("cursoRegistrado".equals(successMessage)) {
    out.print("¡Curso registrado exitosamente!");
} else if ("cursoEditado".equals(successMessage)) {
    out.print("¡Curso editado exitosamente!");
} else if ("cursoEliminado".equals(successMessage)) {
    out.print("¡Curso eliminado exitosamente!");
}
        %>
    </div>
<% } %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mantenimiento de Usuarios, Perfiles y Grados Académicos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="styles/styles.css">
</head>
<body>
    <div class="container-fluid mt-5">
        <div class="row">
            <!-- Menú principal a la izquierda -->
            <div class="col-md-3 bg-light p-4">
                <h5>Bienvenido, <%= nombreUsuario %></h5>
                <p>Rol: <strong><%= rolUsuario %></strong></p>
                <hr>
                <h6>Opciones</h6>
                <h5>Gestión para Usuarios</h5>
                <hr>
                <button class="btn btn-primary w-100 my-2" onclick="mostrarCRUD('usuarios')">Gestionar Usuarios</button>
                <button class="btn btn-secondary w-100 my-2" onclick="mostrarCRUD('perfiles')">Gestionar Perfiles</button>
                <h5>Gestión para Docentes</h5>
                <hr>
                <button class="btn btn-info w-100 my-2" onclick="mostrarCRUD('docentes')">Gestionar Docentes</button>
                <button class="btn btn-info w-100 my-2" onclick="mostrarCRUD('grados')">Gestionar Grado Académico</button>
                
                <h5>Gestión para Cursos</h5>
                <hr>
                <button class="btn btn-success w-100 my-2" onclick="mostrarCRUD('cursos')">Gestionar Cursos</button>
                <button class="btn btn-success w-100 my-2" onclick="mostrarCRUD('categorias')">Gestionar Categorías de cursos</button>
                <button class="btn btn-warning w-100 my-2" onclick="mostrarCRUD('duraciones')">Gestionar Duración Curso</button>
                <button class="btn btn-danger w-100 my-2" onclick="mostrarCRUD('idiomas')">Gestionar Idioma Curso</button>
                <button class="btn btn-dark w-100 my-2" onclick="mostrarCRUD('rangos')">Gestionar Rango Edades Curso</button
                
                <!-- Cerrar sesion -->
                <form action="LogoutServlet" method="post" class="mt-3">
                <button type="submit" class="btn btn-danger w-100">Cerrar Sesión</button>
                </form>
            </div>

            <!-- Contenido a la derecha -->
            <div class="col-md-9">
                <!-- Sección donde aparecerán las opciones CRUD -->
                <div id="seccionCRUD" style="display: none;">
                    <!-- Aquí se llenará con los CRUD de usuarios, perfiles o grados académicos -->
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL USUARIOS -->
    <div class="modal fade" id="usuarioModal" tabindex="-1" aria-labelledby="usuarioModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="usuarioModalLabel">Gestionar Usuario</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="MantenimientoServlet" method="post" id="formUsuario">
                        <input type="hidden" name="idUsuario" id="idUsuario">
                        <div class="mb-3">
                            <label for="dni" class="form-label">DNI</label>
                            <input type="text" class="form-control" id="dni" name="dni" required>
                        </div>
                        <div class="mb-3">
                            <label for="nombres" class="form-label">Nombres</label>
                            <input type="text" class="form-control" id="nombres" name="nombres" required>
                        </div>
                        <div class="mb-3">
                            <label for="apellidoPaterno" class="form-label">Apellido Paterno</label>
                            <input type="text" class="form-control" id="apellidoPaterno" name="apellidoPaterno" required>
                        </div>
                        <div class="mb-3">
                            <label for="apellidoMaterno" class="form-label">Apellido Materno</label>
                            <input type="text" class="form-control" id="apellidoMaterno" name="apellidoMaterno">
                        </div>
                        <div class="mb-3">
                            <label for="correo" class="form-label">Correo Electrónico</label>
                            <input type="email" class="form-control" id="correo" name="correo" required>
                        </div>
                        <div class="mb-3">
                            <label for="perfil" class="form-label">Perfil</label>
                            <select class="form-select" id="perfil" name="perfil" required>
                                <option value="" disabled selected>Seleccionar Perfil</option>
                                <%
                                    PreparedStatement psPerfiles2 = con.prepareStatement("SELECT IdPerfil, Nombre FROM Perfiles WHERE EstadoRegistro = 1");
                                    ResultSet rsPerfiles2 = psPerfiles2.executeQuery();
                                    while (rsPerfiles2.next()) {
                                %>
                                <option value="<%= rsPerfiles2.getInt("IdPerfil")%>"><%= rsPerfiles2.getString("Nombre")%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <button type="submit" name="accion" value="registrarUsuario" class="btn btn-primary">Guardar Usuario</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL PERFILES -->
    <div class="modal fade" id="perfilModal" tabindex="-1" aria-labelledby="perfilModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="perfilModalLabel">Gestionar Perfil</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="MantenimientoServlet" method="post" id="formPerfil">
                        <input type="hidden" name="idPerfil" id="idPerfil">
                        <div class="mb-3">
                            <label for="nombrePerfil" class="form-label">Nombre del Perfil</label>
                            <input type="text" class="form-control" id="nombrePerfil" name="nombrePerfil" required>
                        </div>
                        <div class="mb-3">
                            <label for="descripcionPerfil" class="form-label">Descripción</label>
                            <textarea class="form-control" id="descripcionPerfil" name="descripcionPerfil" required></textarea>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <button type="submit" name="accion" value="registrarPerfil" class="btn btn-primary">Guardar Perfil</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL GRADOS -->
    <div class="modal fade" id="gradoModal" tabindex="-1" aria-labelledby="gradoModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="gradoModalLabel">Gestionar Grado Académico</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="MantenimientoServlet" method="post" id="formGrado">
                        <input type="hidden" name="idGrado" id="idGrado">
                        <div class="mb-3">
                            <label for="nombreGrado" class="form-label">Nombre del Grado Académico</label>
                            <input type="text" class="form-control" id="nombreGrado" name="nombreGrado" required>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <button type="submit" name="accion" value="registrarGrado" class="btn btn-primary">Guardar Grado</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>


 <!-- MODAL CATEGORÍA CURSO -->
<div class="modal fade" id="categoriaModal" tabindex="-1" aria-labelledby="categoriaModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="categoriaModalLabel">Gestionar Categoría Curso</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="MantenimientoServlet" method="post" id="formCategoria">
                    <input type="hidden" name="idCategoria" id="idCategoria">
                    <div class="mb-3">
                        <label for="nombreCategoria" class="form-label">Nombre de la Categoría</label>
                        <input type="text" class="form-control" id="nombreCategoria" name="nombreCategoria" required>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        <button type="submit" name="accion" value="registrarCategoria" class="btn btn-primary">Guardar Categoría</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- MODAL DURACIÓN CURSO -->
<div class="modal fade" id="duracionModal" tabindex="-1" aria-labelledby="duracionModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="duracionModalLabel">Gestionar Duración Curso</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="MantenimientoServlet" method="post" id="formDuracion">
                    <input type="hidden" name="idDuracion" id="idDuracion">
                    <div class="mb-3">
                        <label for="nombreDuracion" class="form-label">Duración (ej. 3 meses)</label>
                        <input type="text" class="form-control" id="nombreDuracion" name="nombreDuracion" required>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        <button type="submit" name="accion" value="registrarDuracion" class="btn btn-primary">Guardar Duración</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

 
 <!-- MODAL Idioma-CURSOS-->
 <div class="modal fade" id="idiomaModal" tabindex="-1" aria-labelledby="idiomaModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="idiomaModalLabel">Gestionar Idiomas Curso</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="MantenimientoServlet" method="post" id="formIdioma">
                    <input type="hidden" name="idIdioma" id="idIdioma">
                    <div class="mb-3">
                        <label for="nombreIdioma" class="form-label">Idioma (ej. Ingles)</label>
                        <input type="text" class="form-control" id="nombreIdioma" name="nombreIdioma" required>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        <button type="submit" name="accion" value="registrarIdioma" class="btn btn-primary">Guardar Idioma</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
 
 <!-- MODAL rangos-CURSOS-->
 <div class="modal fade" id="rangoModal" tabindex="-1" aria-labelledby="rangoModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="rangoModalLabel">Gestionar Rango Edades Curso</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="MantenimientoServlet" method="post" id="formRango">
                    <input type="hidden" name="idRango" id="idRango">
                    <div class="mb-3">
                        <label for="descripcionRango" class="form-label">Rango (ej. 18 - 25 años)</label>
                        <input type="text" class="form-control" id="descripcionRango" name="descripcionRango" required>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        <button type="submit" name="accion" value="registrarRango" class="btn btn-primary">Guardar Rango</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
 
<!-- MODAL CURSOS -->
<div class="modal fade" id="cursosModal" tabindex="-1" aria-labelledby="cursosModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="cursosModalLabel">Gestionar Cursos</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="MantenimientoServlet" method="post" id="formCurso">
                    <input type="hidden" name="idCurso" id="idCurso">
                    <div class="mb-3">
                        <label for="nombreCurso" class="form-label">Nombre del Curso</label>
                        <input type="text" class="form-control" id="nombreCurso" name="nombreCurso" required>
                    </div>
                    <div class="mb-3">
                        <label for="capacidad" class="form-label">Capacidad</label>
                        <input type="number" class="form-control" id="capacidad" name="capacidad" required>
                    </div>
                    <div class="mb-3">
                        <label for="fechaInicio" class="form-label">Fecha de Inicio</label>
                        <input type="date" class="form-control" id="fechaInicio" name="fechaInicio" required>
                    </div>
                    <div class="mb-3">
                        <label for="fechaFin" class="form-label">Fecha de Fin</label>
                        <input type="date" class="form-control" id="fechaFin" name="fechaFin" required>
                    </div>
                    <div class="mb-3">
                        <label for="precio" class="form-label">Precio</label>
                        <input type="number" class="form-control" id="precio" name="precio" step="0.01" required>
                    </div>
                    <div class="mb-3">
                        <label for="categoria" class="form-label">Categoría</label>
                        <select class="form-select" id="categoria" name="categoria" required>
                            <option value="" disabled selected>Seleccionar Categoría</option>
                            <!-- Aquí debes llenar las opciones de categoría -->
                            <%
                                    PreparedStatement psCategoria2 = con.prepareStatement("SELECT IdCategoria, Nombre FROM categoriacurso WHERE EstadoRegistro = 1");
                                    ResultSet rsCategoria2 = psCategoria2.executeQuery();
                                    while (rsCategoria2.next()) {
                                %>
                                <option value="<%= rsCategoria2.getInt("IdCategoria")%>"><%= rsCategoria2.getString("Nombre")%></option>
                                <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="duracion" class="form-label">Duración</label>
                        <select class="form-select" id="duracion" name="duracion" required>
                            <option value="" disabled selected>Seleccionar Duración</option>
                            <!-- Aquí debes llenar las opciones de duración -->
                            <%
                                PreparedStatement psDuracion = con.prepareStatement("SELECT IdDuracion, Nombre FROM DuracionCurso WHERE EstadoRegistro = 1");
                                ResultSet rsDuracion = psDuracion.executeQuery();
                                while (rsDuracion.next()) {
                            %>
                            <option value="<%= rsDuracion.getInt("IdDuracion") %>"><%= rsDuracion.getString("Nombre") %></option>
                            <% } %>
                            
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="idioma" class="form-label">Idioma</label>
                        <select class="form-select" id="idioma" name="idioma" required>
                            <option value="" disabled selected>Seleccionar Idioma</option>
                            <!-- Aquí debes llenar las opciones de idioma -->
                            <%
                                PreparedStatement psIdioma = con.prepareStatement("SELECT IdIdioma, Nombre FROM IdiomaCurso WHERE EstadoRegistro = 1");
                                ResultSet rsIdioma = psIdioma.executeQuery();
                                while (rsIdioma.next()) {
                            %>
                            <option value="<%= rsIdioma.getInt("IdIdioma") %>"><%= rsIdioma.getString("Nombre") %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="rango" class="form-label">Rango de Edades</label>
                        <select class="form-select" id="rango" name="rango" required>
                            <option value="" disabled selected>Seleccionar Rango</option>
                            <!-- Aquí debes llenar las opciones de rango -->
                            <%
                                PreparedStatement psRango = con.prepareStatement("SELECT IdRango, Descripcion FROM RangoEdadesCurso WHERE EstadoRegistro = 1");
                                ResultSet rsRango = psRango.executeQuery();
                                while (rsRango.next()) {
                            %>
                            <option value="<%= rsRango.getInt("IdRango") %>"><%= rsRango.getString("Descripcion") %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        <button type="submit" name="accion" value="registrarCurso" class="btn btn-primary">Guardar Curso</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- MODAL DOCENTES -->
<!-- MODAL DOCENTES -->
<div class="modal fade" id="docenteModal" tabindex="-1" aria-labelledby="docenteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="docenteModalLabel">Nuevo Docente</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="formDocente" action="MantenimientoServlet" method="post">
                <div class="modal-body">
                    <!-- Campo oculto para idDocente, necesario para editar -->
                    <input type="hidden" name="idDocente" id="idDocente">

                    <!-- Selector de usuario con perfil docente -->
                    <div class="mb-3">
                        <label for="idUsuario" class="form-label">Usuario</label>
                        <select class="form-select" id="idUsuario" name="idUsuario" required>
                            <option value="" disabled selected>Seleccionar Usuario</option>
                            <% 
                                // Consulta para obtener los usuarios con perfil docente
                                PreparedStatement psUsuariosDocente = con.prepareStatement(
                                    "SELECT u.IdUsuario, u.Nombres, u.ApellidoPaterno, u.ApellidoMaterno " +
                                    "FROM usuario u " +
                                    "JOIN usuario_perfiles up ON u.IdUsuario = up.IdUsuario " +
                                    "JOIN perfiles p ON up.IdPerfil = p.IdPerfil " +
                                    "WHERE p.Nombre = 'Docente' AND u.EstadoRegistro = 1"
                                );
                                ResultSet rsUsuariosDocente = psUsuariosDocente.executeQuery();
                                while (rsUsuariosDocente.next()) {
                            %>
                            <option value="<%= rsUsuariosDocente.getInt("IdUsuario") %>">
                                <%= rsUsuariosDocente.getString("Nombres") %> <%= rsUsuariosDocente.getString("ApellidoPaterno") %> <%= rsUsuariosDocente.getString("ApellidoMaterno") %>
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Selector de Grado Académico -->
                    <div class="mb-3">
                        <label for="gradoAcademico" class="form-label">Grado Académico</label>
                        <select class="form-select" id="gradoAcademico" name="gradoAcademico" required>
                            <option value="" disabled selected>Seleccionar Grado Académico</option>
                            <% 
                                PreparedStatement psGradoAcademico = con.prepareStatement("SELECT IdGradoAcademico, Nombre FROM gradoacademico WHERE EstadoRegistro = 1");
                                ResultSet rsGradoAcademico = psGradoAcademico.executeQuery();
                                while (rsGradoAcademico.next()) {
                            %>
                            <option value="<%= rsGradoAcademico.getInt("IdGradoAcademico") %>"><%= rsGradoAcademico.getString("Nombre") %></option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Campo para Descripción -->
                    <div class="mb-3">
                        <label for="descripcion" class="form-label">Descripción</label>
                        <textarea class="form-control" id="descripcion" name="descripcion" required></textarea>
                    </div>

                    <!-- Selección de Curso Asignado -->
                    <div class="mb-3">
                        <label for="curso" class="form-label">Curso Asignado</label>
                        <select class="form-select" id="curso" name="curso">
                            <option value="" disabled selected>Seleccionar Curso</option>
                            <% 
                                PreparedStatement psCursosListado = con.prepareStatement("SELECT IdCurso, Nombre FROM curso WHERE EstadoRegistro = 1");
                                ResultSet rsCursosListado = psCursosListado.executeQuery();
                                while (rsCursosListado.next()) {
                            %>
                            <option value="<%= rsCursosListado.getInt("IdCurso") %>"><%= rsCursosListado.getString("Nombre") %></option>
                            <% } %>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    <button type="submit" id="submitDocente" class="btn btn-primary">Guardar Docente</button>
                </div>
                <input type="hidden" name="accion" id="accionDocente" value="registrarDocente">
            </form>
        </div>
    </div>
</div>



 
 
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Script para manejar CRUD -->
    <script>
        function mostrarCRUD(tipo) {
            const seccionCRUD = document.getElementById('seccionCRUD');
            let contenido = '';

            if (tipo === 'usuarios') {
                contenido = `
                    <h5>Gestión de Usuarios</h5>
                    <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#usuarioModal">
                        Nuevo Usuario
                    </button>
                    <h5 class="mt-4">Usuarios Registrados</h5>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>DNI</th>
                                <th>Nombre Completo</th>
                                <th>Correo Electrónico</th>
                                <th>Perfil</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% while (rsUsuarios.next()) { %>
                            <tr>
                                <td><%= rsUsuarios.getString("DNI")%></td>
                                <td><%= rsUsuarios.getString("Nombres")%> <%= rsUsuarios.getString("ApellidoPaterno")%></td>
                                <td><%= rsUsuarios.getString("CorreoElectronico")%></td>
                                <td><%= rsUsuarios.getString("Perfil")%></td>
                                <td>
                                    <button class="btn btn-warning btn-sm" onclick="editarUsuario(<%= rsUsuarios.getInt("IdUsuario")%>, '<%= rsUsuarios.getString("DNI")%>', '<%= rsUsuarios.getString("Nombres")%>', '<%= rsUsuarios.getString("ApellidoPaterno")%>', '<%= rsUsuarios.getString("ApellidoMaterno")%>', '<%= rsUsuarios.getString("CorreoElectronico")%>', '<%= rsUsuarios.getString("Perfil")%>')">Editar</button>
                                    <form action="MantenimientoServlet" method="post" class="d-inline" onsubmit="return confirm('¿Estás seguro de que deseas eliminar este usuario?');">
                                        <input type="hidden" name="idUsuario" value="<%= rsUsuarios.getInt("IdUsuario")%>">
                                        <button type="submit" name="accion" value="eliminarUsuario" class="btn btn-danger btn-sm">Eliminar</button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                `;
            } else if (tipo === 'perfiles') {
                contenido = `
                    <h5>Gestión de Perfiles</h5>
                    <button type="button" class="btn btn-secondary mb-3" data-bs-toggle="modal" data-bs-target="#perfilModal">
                        Nuevo Perfil
                    </button>
                    <h5 class="mt-4">Perfiles Registrados</h5>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Nombre</th>
                                <th>Descripción</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% while (rsPerfiles.next()) { %>
                            <tr>
                                <td><%= rsPerfiles.getString("Nombre")%></td>
                                <td><%= rsPerfiles.getString("Descripcion")%></td>
                                <td>
                                    <button class="btn btn-warning btn-sm" onclick="editarPerfil(<%= rsPerfiles.getInt("IdPerfil")%>, '<%= rsPerfiles.getString("Nombre")%>', '<%= rsPerfiles.getString("Descripcion")%>')">Editar</button>
                                    <form action="MantenimientoServlet" method="post" class="d-inline">
                                        <input type="hidden" name="idPerfil" value="<%= rsPerfiles.getInt("IdPerfil")%>">
                                        <button type="submit" name="accion" value="eliminarPerfil" class="btn btn-danger btn-sm">Eliminar</button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                `;
            } else if (tipo === 'grados') {
                contenido = `
                    <h5>Gestión de Grado Académico</h5>
                    <button type="button" class="btn btn-info mb-3" data-bs-toggle="modal" data-bs-target="#gradoModal">
                        Nuevo Grado
                    </button>
                    <h5 class="mt-4">Grados Académicos Registrados</h5>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% while (rsGrados.next()) { %>
                            <tr>
                                <td><%= rsGrados.getInt("IdGradoAcademico") %></td>
                                <td><%= rsGrados.getString("Nombre") %></td>
                                <td>
                                    <button class="btn btn-warning btn-sm" onclick="editarGrado(<%= rsGrados.getInt("IdGradoAcademico") %>, '<%= rsGrados.getString("Nombre") %>')">Editar</button>
                                    <form action="MantenimientoServlet" method="post" class="d-inline" onsubmit="return confirm('¿Está seguro que desea eliminar este grado académico?');">
                                        <input type="hidden" name="idGrado" value="<%= rsGrados.getInt("IdGradoAcademico") %>">
                                        <button type="submit" name="accion" value="eliminarGrado" class="btn btn-danger btn-sm">Eliminar</button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                `;
            } else if (tipo === 'categorias') {
    contenido = `
        <h5>Gestión de Categorías</h5>
        <button type="button" class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#categoriaModal">Nueva Categoría</button>
        <h5 class="mt-4">Categorías Registradas</h5>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Nombre de la Categoría</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% while (rsCategorias.next()) { %>
                <tr>
                    <td><%= rsCategorias.getString("Nombre") %></td>
                    <td>
                        <button class="btn btn-warning btn-sm" onclick="editarCategoria(<%= rsCategorias.getInt("IdCategoria") %>, '<%= rsCategorias.getString("Nombre") %>')">Editar</button>
                        <form action="MantenimientoServlet" method="post" class="d-inline">
                            <input type="hidden" name="idCategoria" value="<%= rsCategorias.getInt("IdCategoria") %>">
                            <button type="submit" name="accion" value="eliminarCategoria" class="btn btn-danger btn-sm">Eliminar</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    `;
}
else if (tipo === 'duraciones') {
    contenido = `
        <h5>Gestión de Duraciones</h5>
        <button type="button" class="btn btn-warning mb-3" data-bs-toggle="modal" data-bs-target="#duracionModal">Nueva Duración</button>
        <h5 class="mt-4">Duraciones Registradas</h5>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Duración de los cursos</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% while (rsDuraciones.next()) { %>
                <tr>
                    <td><%= rsDuraciones.getString("Nombre") %></td>
                    <td>
                        <button class="btn btn-warning btn-sm" onclick="editarDuracion(<%= rsDuraciones.getInt("IdDuracion") %>, '<%= rsDuraciones.getString("Nombre") %>')">Editar</button>
                        <form action="MantenimientoServlet" method="post" class="d-inline">
                            <input type="hidden" name="idDuracion" value="<%= rsDuraciones.getInt("IdDuracion") %>">
                            <button type="submit" name="accion" value="eliminarDuracion" class="btn btn-danger btn-sm">Eliminar</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    `;
}

else if (tipo === 'idiomas') {
    contenido = `
        <h5>Gestión de Idiomas</h5>
        <button type="button" class="btn btn-warning mb-3" data-bs-toggle="modal" data-bs-target="#idiomaModal">Nuevo Idioma</button>
        <h5 class="mt-4">Idiomas Registradas</h5>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Nombre del Idioma</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% while (rsIdiomas.next()) { %>
                <tr>
                    <td><%= rsIdiomas.getString("Nombre") %></td>
                    <td>
                        <button class="btn btn-warning btn-sm" onclick="editarIdioma(<%= rsIdiomas.getInt("IdIdioma") %>, '<%= rsIdiomas.getString("Nombre") %>')">Editar</button>
                        <form action="MantenimientoServlet" method="post" class="d-inline">
                            <input type="hidden" name="idIdioma" value="<%= rsIdiomas.getInt("IdIdioma") %>">
                            <button type="submit" name="accion" value="eliminarIdioma" class="btn btn-danger btn-sm">Eliminar</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    `;
}


else if (tipo === 'rangos') {
    contenido = `
        <h5>Gestión de Rango de Edades</h5>
        <button type="button" class="btn btn-warning mb-3" data-bs-toggle="modal" data-bs-target="#rangoModal">Nuevo Rango</button>
        <h5 class="mt-4">Rango de Edades Registradas</h5>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Descripcion del Rango</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% while (rsRangos.next()) { %>
                <tr>
                    <td><%= rsRangos.getString("Descripcion") %></td>
                    <td>
                        <button class="btn btn-warning btn-sm" onclick="editarRango(<%= rsRangos.getInt("IdRango") %>, '<%= rsRangos.getString("Descripcion") %>')">Editar</button>
                        <form action="MantenimientoServlet" method="post" class="d-inline">
                            <input type="hidden" name="idRango" value="<%= rsRangos.getInt("IdRango") %>">
                            <button type="submit" name="accion" value="eliminarRango" class="btn btn-danger btn-sm">Eliminar</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    `;
}
else if (tipo === 'cursos') {
    contenido = `
        <h5>Gestión Cursos</h5>
        <button type="button" class="btn btn-warning mb-3" data-bs-toggle="modal" data-bs-target="#cursosModal">Registrar nuevo curso</button>
        <h5 class="mt-4">Cursos Registrados</h5>
        <table class="table table-bordered">
    <thead>
        <tr>
            <th>Nombre del curso</th>
            <th>Fecha de creación</th>
            <th>Capacidad</th>
            <th>Fecha de inicio</th>
            <th>Fecha de fin</th>
            <th>Precio</th>
            <th>Categoría</th>
            <th>Duración</th>
            <th>Idioma</th>
            <th>Rango</th>
            <th>Acciones</th>
        </tr>
    </thead>
    <tbody>
        <% 
        try {
            while (rsCursos.next()) { %>
                <tr>
                    <td><%= rsCursos.getString("Nombre") %></td>
                    <td><%= rsCursos.getString("FechaRegistro") %></td>
                    <td><%= rsCursos.getString("Capacidad") %></td>
                    <td><%= rsCursos.getString("FechaInicio") %></td>
                    <td><%= rsCursos.getString("FechaFin") %></td>
                    <td><%= rsCursos.getString("Precio") %></td>
                    <td><%= rsCursos.getString("Categoria") %></td>
                    <td><%= rsCursos.getString("Duracion") %></td>
                    <td><%= rsCursos.getString("Idioma") %></td>
                    <td><%= rsCursos.getString("Rango") %></td>
                    <td>
                        <button class="btn btn-warning btn-sm" onclick="editarCurso(
        <%= rsCursos.getInt("IdCurso") %>, 
        '<%= rsCursos.getString("Nombre") %>', 
        <%= rsCursos.getInt("Capacidad") %>, 
        '<%= rsCursos.getString("FechaInicio") %>', 
        '<%= rsCursos.getString("FechaFin") %>', 
        <%= rsCursos.getDouble("Precio") %>, 
        '<%= rsCursos.getString("Categoria") %>', 
        '<%= rsCursos.getString("Duracion") %>', 
        '<%= rsCursos.getString("Idioma") %>', 
        '<%= rsCursos.getString("Rango") %>'
    )">Editar</button>
                        <form action="MantenimientoServlet" method="post" class="d-inline">
                            <input type="hidden" name="idCurso" value="<%= rsCursos.getInt("IdCurso") %>">
                            <button type="submit" name="accion" value="eliminarCurso" class="btn btn-danger btn-sm">Eliminar</button>
                        </form>
                    </td>
                </tr>
        <%   }
        } catch (Exception e) {
            e.printStackTrace();
        } %>
    </tbody>
</table>

    `;
}
else if (tipo === 'docentes') {
    contenido = `
        <h5>Gestión de Docentes</h5>
        <button type="button" class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#docenteModal">Nuevo Docente</button>
        <h5 class="mt-4">Docentes Registrados</h5>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Nombres</th>
                    <th>Apellidos</th>
                    <th>Correo Electrónico</th>
                    <th>Curso Asignado</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% while (rsDocentes.next()) { %>
                <tr>
                    <td><%= rsDocentes.getString("Nombres") %></td>
                    <td><%= rsDocentes.getString("ApellidoPaterno") + " " + rsDocentes.getString("ApellidoMaterno") %></td>
                    <td><%= rsDocentes.getString("CorreoElectronico") %></td>
                    <td><%= rsDocentes.getString("CursoNombre") %></td>
                    <td>
                        <button class="btn btn-warning btn-sm" onclick="editarDocente(<%= rsDocentes.getInt("IdDocente") %>, '<%= rsDocentes.getString("Nombres") %>', '<%= rsDocentes.getString("ApellidoPaterno") %>', '<%= rsDocentes.getString("ApellidoMaterno") %>', '<%= rsDocentes.getString("CorreoElectronico") %>', <%= rsDocentes.getInt("IdCurso") %>)">Editar</button>
                        <form action="MantenimientoServlet" method="post" class="d-inline">
                            <input type="hidden" name="idDocente" value="<%= rsDocentes.getInt("IdDocente") %>">
                            <button type="submit" name="accion" value="eliminarDocente" class="btn btn-danger btn-sm">Eliminar</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    `;
}


            
            
            seccionCRUD.innerHTML = contenido;
            seccionCRUD.style.display = 'block';
        }

        function editarUsuario(idUsuario, dni, nombres, apellidoPaterno, apellidoMaterno, correo, perfil) {
            document.getElementById('idUsuario').value = idUsuario;
            document.getElementById('dni').value = dni;
            document.getElementById('nombres').value = nombres;
            document.getElementById('apellidoPaterno').value = apellidoPaterno;
            document.getElementById('apellidoMaterno').value = apellidoMaterno;
            document.getElementById('correo').value = correo;
            document.getElementById('perfil').value = perfil;


            // Cambiar el valor del botón a "Actualizar"
            document.querySelector('#formUsuario button[type="submit"]').innerText = "Actualizar Usuario";
            document.querySelector('#formUsuario button[type="submit"]').value = "editarUsuario";
            
            // Abrir el modal
            var modal = new bootstrap.Modal(document.getElementById('usuarioModal'));
            modal.show();
        }

        function editarPerfil(idPerfil, nombrePerfil, descripcionPerfil) {
            document.getElementById('idPerfil').value = idPerfil;
            document.getElementById('nombrePerfil').value = nombrePerfil;
            document.getElementById('descripcionPerfil').value = descripcionPerfil;

            // Cambiar el botón a "Actualizar"
            document.querySelector('#formPerfil button[type="submit"]').innerText = "Actualizar Perfil";
            document.querySelector('#formPerfil button[type="submit"]').value = "editarPerfil";
            
            // Abrir el modal
            var modal = new bootstrap.Modal(document.getElementById('perfilModal'));
            modal.show();
        }

        function editarGrado(idGrado, nombreGrado) {
            document.getElementById('idGrado').value = idGrado;
            document.getElementById('nombreGrado').value = nombreGrado;

            // Cambiar el botón a "Actualizar"
            document.querySelector('#formGrado button[type="submit"]').innerText = "Actualizar Grado";
            document.querySelector('#formGrado button[type="submit"]').value = "editarGrado";
            
            // Abrir el modal
            var modal = new bootstrap.Modal(document.getElementById('gradoModal'));
            modal.show();
        }
        function editarCategoria(idCategoria, nombreCategoria) {
            document.getElementById('idCategoria').value = idCategoria;
            document.getElementById('nombreCategoria').value = nombreCategoria;

            // Cambiar el botón a "Actualizar"
            document.querySelector('#formCategoria button[type="submit"]').innerText = "Actualizar Categoría";
            document.querySelector('#formCategoria button[type="submit"]').value = "editarCategoria";

            // Abrir el modal
            var modal = new bootstrap.Modal(document.getElementById('categoriaModal'));
            modal.show();
        }
        
        function editarDuracion(idDuracion, nombreDuracion) {
            document.getElementById('idDuracion').value = idDuracion;
            document.getElementById('nombreDuracion').value = nombreDuracion;

            // Cambiar el botón a "Actualizar"
            document.querySelector('#formDuracion button[type="submit"]').innerText = "Actualizar Duración";
            document.querySelector('#formDuracion button[type="submit"]').value = "editarDuracion";

            // Abrir el modal
            var modal = new bootstrap.Modal(document.getElementById('duracionModal'));
            modal.show();
        }
        
        function editarIdioma(idIdioma  , nombreIdioma) {
            document.getElementById('idIdioma').value = idIdioma;
            document.getElementById('nombreIdioma').value = nombreIdioma;

            // Cambiar el botón a "Actualizar"
            document.querySelector('#formIdioma button[type="submit"]').innerText = "Actualizar Idioma";
            document.querySelector('#formIdioma button[type="submit"]').value = "editarIdioma";

            // Abrir el modal
            var modal = new bootstrap.Modal(document.getElementById('idiomaModal'));
            modal.show();
        } 
        
        function editarRango(idRango  , descripcionRango) {
            document.getElementById('idRango').value = idRango;
            document.getElementById('descripcionRango').value = descripcionRango;

            // Cambiar el botón a "Actualizar"
            document.querySelector('#formRango button[type="submit"]').innerText = "Actualizar Rango";
            document.querySelector('#formRango button[type="submit"]').value = "editarRango";

            // Abrir el modal
            var modal = new bootstrap.Modal(document.getElementById('rangoModal'));
            modal.show();
        }
        
        function editarCurso(idCurso, nombreCurso, capacidad, fechaInicio, fechaFin, precio, categoria, duracion, idioma, rango) {
    // Asignar los valores al formulario del modal
    document.getElementById('idCurso').value = idCurso;
    document.getElementById('nombreCurso').value = nombreCurso;
    document.getElementById('capacidad').value = capacidad;
    document.getElementById('fechaInicio').value = fechaInicio;
    document.getElementById('fechaFin').value = fechaFin;
    document.getElementById('precio').value = precio;
    
    // Seleccionar las opciones correspondientes para categoría, duración, idioma y rango
    document.getElementById('categoria').value = categoria;
    document.getElementById('duracion').value = duracion;
    document.getElementById('idioma').value = idioma;
    document.getElementById('rango').value = rango;

    // Cambiar el texto y valor del botón a "Actualizar Curso"
    document.querySelector('#formCurso button[type="submit"]').innerText = "Actualizar Curso";
    document.querySelector('#formCurso button[type="submit"]').value = "editarCurso";

    // Abrir el modal
    var modal = new bootstrap.Modal(document.getElementById('cursosModal'));
    modal.show();
}

function editarDocente(idDocente, idUsuario, idGradoAcademico, descripcion, cursoId) {
    // Asigna los valores de los parámetros a los campos del formulario
    document.getElementById("idDocente").value = idDocente;
    document.getElementById("idUsuario").value = idUsuario;
    document.getElementById("gradoAcademico").value = idGradoAcademico;
    document.getElementById("descripcion").value = descripcion;
    document.getElementById("curso").value = cursoId;

    // Cambia el valor y el texto del botón de acción a "Editar Docente"
    document.getElementById("accionDocente").value = "editarDocente";
    document.getElementById("submitDocente").innerText = "Actualizar Docente";

    // Abre el modal
    var modal = new bootstrap.Modal(document.getElementById('docenteModal'));
    modal.show();
}

function limpiarFormularioDocente() {
    // Limpia el formulario del modal
    document.getElementById("formDocente").reset();
    document.getElementById("idDocente").value = '';
    document.getElementById("accionDocente").value = "registrarDocente";
    document.getElementById("submitDocente").innerText = "Guardar Docente";
}

// Asegura que se limpie el formulario al cerrar el modal
document.getElementById("docenteModal").addEventListener("hidden.bs.modal", limpiarFormularioDocente);




        // Limpiar el formulario del modal de usuario al cerrarse
        var usuarioModal = document.getElementById('usuarioModal');
        usuarioModal.addEventListener('hidden.bs.modal', function () {
            document.getElementById('formUsuario').reset();
            document.getElementById('idUsuario').value = '';
            document.querySelector('#formUsuario button[type="submit"]').innerText = "Guardar Usuario";
            document.querySelector('#formUsuario button[type="submit"]').value = "registrarUsuario";
        });

        // Limpiar el formulario del modal de perfil al cerrarse
        var perfilModal = document.getElementById('perfilModal');
        perfilModal.addEventListener('hidden.bs.modal', function () {
            document.getElementById('formPerfil').reset();
            document.getElementById('idPerfil').value = '';
            document.querySelector('#formPerfil button[type="submit"]').innerText = "Guardar Perfil";
            document.querySelector('#formPerfil button[type="submit"]').value = "registrarPerfil";
        });

        // Limpiar el formulario del modal de grado al cerrarse
        var gradoModal = document.getElementById('gradoModal');
        gradoModal.addEventListener('hidden.bs.modal', function () {
            document.getElementById('formGrado').reset();
            document.getElementById('idGrado').value = '';
            document.querySelector('#formGrado button[type="submit"]').innerText = "Guardar Grado";
            document.querySelector('#formGrado button[type="submit"]').value = "registrarGrado";
        });
        
        // Limpiar el formulario al cerrar el modal de Categoría

        var categoriaModal = document.getElementById('categoriaModal');
        categoriaModal.addEventListener('hidden.bs.modal', function () {
            document.getElementById('formCategoria').reset();
            document.getElementById('idCategoria').value = '';
            document.querySelector('#formCategoria button[type="submit"]').innerText = "Guardar Categoría";
            document.querySelector('#formCategoria button[type="submit"]').value = "registrarCategoria";
        });
        
    

        // Limpiar el formulario al cerrar el modal de duracion
        var duracionModal = document.getElementById('duracionModal');
        duracionModal.addEventListener('hidden.bs.modal', function () {
            document.getElementById('formDuracion').reset();
            document.getElementById('idDuracion').value = '';
            document.querySelector('#formDuracion button[type="submit"]').innerText = "Guardar Duración";
            document.querySelector('#formDuracion button[type="submit"]').value = "registrarDuracion";
        });

        // Limpiar el formulario al cerrar el modal-idioma
        var idiomaModal = document.getElementById('idiomaModal');
        duracionModal.addEventListener('hidden.bs.modal', function () {
            document.getElementById('formIdioma').reset();
            document.getElementById('idIdioma').value = '';
            document.querySelector('#formIdioma button[type="submit"]').innerText = "Guardar Idioma";
            document.querySelector('#formIdioma button[type="submit"]').value = "registrarIdioma";
        });       
        
        // Limpiar el formulario al cerrar el modal-rango
        var rangoModal = document.getElementById('rangoModal');
        duracionModal.addEventListener('hidden.bs.modal', function () {
            document.getElementById('formRango').reset();
            document.getElementById('idRango').value = '';
            document.querySelector('#formRango button[type="submit"]').innerText = "Guardar Rango";
            document.querySelector('#formRango button[type="submit"]').value = "registrarRango";
        }); 
        
        // Limpiar el formulario al cerrar el modal-curso
        var cursoModal = document.getElementById('cursoModal');
        cursoModal.addEventListener('hidden.bs.modal', function () {
            document.getElementById('formCurso').reset();
            document.getElementById('idCurso').value = '';
            document.querySelector('#formCurso button[type="submit"]').innerText = "Guardar Curso";
            document.querySelector('#formCurso button[type="submit"]').value = "registrarCurso";
        });
    </script>
</body>
</html>
