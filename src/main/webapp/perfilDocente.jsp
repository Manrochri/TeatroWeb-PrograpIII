<%@page import="modelo.Conexion"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
if (session == null || session.getAttribute("perfil") == null
            || !"DOCENTE".equals(session.getAttribute("perfil"))) {
        response.sendRedirect("errorAcceso.jsp");
        return;
    }


    // Obtener el nombre y rol del usuario desde la sesión
    String nombreUsuario = (String) session.getAttribute("nombre");
    String apellidoUsuario = (String) session.getAttribute("apellido");
    String rolUsuario = (String) session.getAttribute("perfil");

    // Crear una lista para almacenar los grados académicos
    ArrayList<String> gradosAcademicos = new ArrayList<>();
    
    // Conexión a la base de datos para obtener los grados académicos
    Connection con = Conexion.getConnection();
    PreparedStatement psGrados = con.prepareStatement("SELECT Nombre FROM GradoAcademico");
    ResultSet rsGrados = psGrados.executeQuery();
    
    // Agregar los grados académicos a la lista
    while (rsGrados.next()) {
        gradosAcademicos.add(rsGrados.getString("Nombre"));
    }

    // Cerrar la conexión
    rsGrados.close();
    psGrados.close();
    con.close();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>Perfil del Docente</title>
</head>
<body>
    <div class="container-fluid mt-5">
        <div class="row">
            <!-- Columna izquierda: Información del usuario -->
            <div class="col-md-3 bg-light p-4">
                <h5>Bienvenido, <%= nombreUsuario %> <%= apellidoUsuario %></h5>
                <p>Rol: <strong><%= rolUsuario %></strong></p>
                <hr>
                <h6>Opciones</h6>
                <button class="btn btn-primary w-100 my-2" onclick="mostrarSeccion('miPerfil')">Mi Perfil</button>
                <button class="btn btn-secondary w-100 my-2" onclick="mostrarSeccion('otraOpcion')">Otras Opciones</button>

                <!-- Botón para cerrar sesión -->
                <form action="LogoutServlet" method="post" class="mt-3">
                    <button type="submit" class="btn btn-danger w-100">Cerrar Sesión</button>
                </form>
            </div>

            <!-- Columna derecha: Contenido dinámico basado en la opción seleccionada -->
            <div class="col-md-9">
                <!-- Sección para actualizar el perfil del docente -->
                <div id="miPerfil" style="display: none;">
                    <h5>Actualizar Perfil de <%= nombreUsuario %> <%= apellidoUsuario %></h5>
                    <form action="ActualizarPerfilDocenteServlet" method="post">
                        <!-- Selección del grado académico -->
                        <div class="mb-3">
                            <label for="gradoAcademico" class="form-label">Grado Académico</label>
                            <select class="form-select" id="gradoAcademico" name="gradoAcademico" required>
                                <option value="" disabled selected>Seleccionar Grado</option>
                                <% for (String grado : gradosAcademicos) { %>
                                    <option value="<%= grado %>"><%= grado %></option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Campo para la descripción -->
                        <div class="mb-3">
                            <label for="descripcion" class="form-label">Descripción</label>
                            <textarea class="form-control" id="descripcion" name="descripcion" rows="3" required></textarea>
                        </div>

                        <button type="submit" class="btn btn-success">Guardar Cambios</button>
                    </form>
                </div>

                <!-- Otra opción que podrías agregar -->
                <div id="otraOpcion" style="display: none;">
                    <h5>Registrar curso</h5>
                    <p>Aquí se registrarán curso. Falta terminar</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Script para manejar las secciones dinámicas -->
    <script>
        function mostrarSeccion(seccion) {
            document.getElementById('miPerfil').style.display = 'none';
            document.getElementById('otraOpcion').style.display = 'none';

            // Mostrar la sección seleccionada
            document.getElementById(seccion).style.display = 'block';
        }
    </script>
</body>
</html>
