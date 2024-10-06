<%@page import="modelo.Conexion"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("perfil") == null || 
        !"Administrador".equals(session.getAttribute("perfil"))) {
        response.sendRedirect("errorAcceso.jsp");
        return;
    }

    // Obteniendo el nombre del usuario y su rol desde la sesión
    String nombreUsuario = (String) session.getAttribute("nombre");
    String rolUsuario = (String) session.getAttribute("perfil");

    // Conexión a la base de datos para obtener los usuarios y perfiles
    Connection con = Conexion.getConnection();
    
    // Obtener usuarios
    PreparedStatement psUsuarios = con.prepareStatement("SELECT u.IdUsuario, u.DNI, u.Nombres, u.ApellidoPaterno, u.CorreoElectronico, p.Nombre as Perfil FROM Usuario u JOIN Usuario_Perfiles up ON u.IdUsuario = up.IdUsuario JOIN Perfiles p ON up.IdPerfil = p.IdPerfil WHERE u.EstadoRegistro = 1");
    ResultSet rsUsuarios = psUsuarios.executeQuery();
    
    // Obtener perfiles
    PreparedStatement psPerfiles = con.prepareStatement("SELECT IdPerfil, Nombre, Descripcion FROM Perfiles WHERE EstadoRegistro = 1");
    ResultSet rsPerfiles = psPerfiles.executeQuery();
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mantenimiento de Usuarios y Perfiles</title>
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
                    <button class="btn btn-primary w-100 my-2" data-bs-toggle="modal" data-bs-target="#modalUsuarios">CRUD Usuarios</button>
                    <button class="btn btn-secondary w-100 my-2" data-bs-toggle="modal" data-bs-target="#modalPerfiles">CRUD Perfiles</button>
                </div>

                <!-- Contenido a la derecha -->
                <div class="col-md-9">
                    <!-- Aquí se muestra el contenido de los CRUDs -->

                    <!-- Modal CRUD Usuarios -->
                    <div class="modal fade" id="modalUsuarios" tabindex="-1" aria-labelledby="modalUsuariosLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="modalUsuariosLabel">CRUD Usuarios</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <!-- Formulario para registrar o editar usuarios -->
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
                                            <label for="correo" class="form-label">Correo Electrónico</label>
                                            <input type="email" class="form-control" id="correo" name="correo" required>
                                        </div>
                                        <div class="mb-3">
                                            <label for="perfil" class="form-label">Perfil</label>
                                            <select class="form-select" id="perfil" name="perfil" required>
                                                <option value="" disabled selected>Seleccionar Perfil</option>
                                                <% 
                                                    // Ejecutar nuevamente la consulta para obtener los perfiles
                                                    PreparedStatement psPerfiles2 = con.prepareStatement("SELECT IdPerfil, Nombre FROM Perfiles WHERE EstadoRegistro = 1");
                                                    ResultSet rsPerfiles2 = psPerfiles2.executeQuery();
                                                    while (rsPerfiles2.next()) { 
                                                %>
                                                    <option value="<%= rsPerfiles2.getInt("IdPerfil") %>"><%= rsPerfiles2.getString("Nombre") %></option>
                                                <% } %>
                                            </select>
                                        </div>
                                        <button type="submit" name="accion" value="registrarUsuario" class="btn btn-primary">Guardar Usuario</button>
                                    </form>

                                    <!-- Tabla de usuarios registrados -->
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
                                                <td><%= rsUsuarios.getString("DNI") %></td>
                                                <td><%= rsUsuarios.getString("Nombres") %> <%= rsUsuarios.getString("ApellidoPaterno") %></td>
                                                <td><%= rsUsuarios.getString("CorreoElectronico") %></td>
                                                <td><%= rsUsuarios.getString("Perfil") %></td>
                                                <td>
                                                    <button class="btn btn-warning btn-sm" onclick="editarUsuario(<%= rsUsuarios.getInt("IdUsuario") %>)">Editar</button>
                                                    <form action="MantenimientoServlet" method="post" class="d-inline">
                                                        <input type="hidden" name="idUsuario" value="<%= rsUsuarios.getInt("IdUsuario") %>">
                                                        <button type="submit" name="accion" value="eliminarUsuario" class="btn btn-danger btn-sm">Eliminar</button>
                                                    </form>
                                                </td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal CRUD Perfiles -->
                    <div class="modal fade" id="modalPerfiles" tabindex="-1" aria-labelledby="modalPerfilesLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="modalPerfilesLabel">CRUD Perfiles</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <!-- Formulario para registrar o editar perfiles -->
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
                                        <button type="submit" name="accion" value="registrarPerfil" class="btn btn-primary">Guardar Perfil</button>
                                    </form>

                                    <!-- Tabla de perfiles registrados -->
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
                                                <td><%= rsPerfiles.getString("Nombre") %></td>
                                                <td><%= rsPerfiles.getString("Descripcion") %></td>
                                                <td>
                                                    <button class="btn btn-warning btn-sm" onclick="editarPerfil(<%= rsPerfiles.getInt("IdPerfil") %>)">Editar</button>
                                                    <form action="MantenimientoServlet" method="post" class="d-inline">
                                                        <input type="hidden" name="idPerfil" value="<%= rsPerfiles.getInt("IdPerfil") %>">
                                                        <button type="submit" name="accion" value="eliminarPerfil" class="btn btn-danger btn-sm">Eliminar</button>
                                                    </form>
                                                </td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Script para precargar datos en el modal para editar -->
        <script>
            function editarUsuario(idUsuario) {
                // Aquí debes hacer una llamada AJAX o precargar los datos de la tabla al formulario
                // para permitir editar el usuario en el modal.
            }

            function editarPerfil(idPerfil) {
                // Similar al caso de los usuarios, precargar datos para editar un perfil
            }
        </script>
    </body>
</html>
