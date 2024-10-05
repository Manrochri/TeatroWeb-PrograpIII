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

    // Conexión a la base de datos para obtener los perfiles
    Connection con = Conexion.getConnection();
    PreparedStatement ps = con.prepareStatement("SELECT IdPerfil, Nombre FROM Perfiles WHERE EstadoRegistro = 1");
    ResultSet rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Mantenimiento de Usuarios y Perfiles</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="styles/styles.css">
    </head>
    <body>
        <div class="container mt-5">
            <h2 class="text-center">Mantenimiento de Usuarios y Perfiles</h2>
            
            <!-- Botones para abrir los modales -->
            <div class="d-flex justify-content-center mb-3">
                <button class="btn btn-primary me-3" data-bs-toggle="modal" data-bs-target="#modalUsuarios">CRUD Usuarios</button>
                <button class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#modalPerfiles">CRUD Perfiles</button>
            </div>

            <!-- Modal CRUD Usuarios -->
            <div class="modal fade" id="modalUsuarios" tabindex="-1" aria-labelledby="modalUsuariosLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalUsuariosLabel">CRUD Usuarios</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form action="MantenimientoServlet" method="post">
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
                                        <% while (rs.next()) { %>
                                            <option value="<%= rs.getInt("IdPerfil") %>"><%= rs.getString("Nombre") %></option>
                                        <% } %>
                                    </select>
                                </div>
                                <button type="submit" name="accion" value="registrarUsuario" class="btn btn-primary">Registrar Usuario</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal CRUD Perfiles -->
            <div class="modal fade" id="modalPerfiles" tabindex="-1" aria-labelledby="modalPerfilesLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalPerfilesLabel">CRUD Perfiles</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form action="MantenimientoServlet" method="post">
                                <div class="mb-3">
                                    <label for="nombrePerfil" class="form-label">Nombre del Perfil</label>
                                    <input type="text" class="form-control" id="nombrePerfil" name="nombrePerfil" required>
                                </div>
                                <div class="mb-3">
                                    <label for="descripcionPerfil" class="form-label">Descripción del Perfil</label>
                                    <textarea class="form-control" id="descripcionPerfil" name="descripcionPerfil" required></textarea>
                                </div>
                                <button type="submit" name="accion" value="registrarPerfil" class="btn btn-primary">Registrar Perfil</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
