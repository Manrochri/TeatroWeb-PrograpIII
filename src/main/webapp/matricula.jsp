<%@page import="java.util.Date"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="modelo.Conexion"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="jakarta.servlet.http.HttpSession"%>

<%
    // Verificar si el usuario está autenticado mediante una verificación directa
    if (session == null || session.getAttribute("nombre") == null || session.getAttribute("idAlumno") == null) {
        response.sendRedirect("loginUsuario.jsp");
        return;
    }

    // Obtener el ID del alumno directamente desde la sesión
    Integer idAlumno = (Integer) session.getAttribute("idAlumno");

    // Verificar si el ID del alumno es válido
    if (idAlumno == null) {
%>
        <p style="color: red;">No se ha encontrado el ID del alumno en la sesión. Por favor, inicia sesión nuevamente.</p>
<%
        return;
    }

    // Obtener el ID del curso desde la solicitud
    String idCurso = request.getParameter("idCurso");

    if (idCurso == null || idCurso.isEmpty()) {
%>
        <p style="color: red;">No se ha seleccionado ningún curso. Por favor, selecciona un curso válido.</p>
<%
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String query = "SELECT c.IdCurso, c.Nombre, c.Capacidad, c.FechaInicio, c.FechaFin, c.Precio, "
                 + "cat.Nombre AS CategoriaCurso, c.ImagenURL "
                 + "FROM curso c "
                 + "JOIN categoriacurso cat ON c.IdCategoria = cat.IdCategoria "
                 + "WHERE c.IdCurso = ? AND c.EstadoRegistro = 1";

    // Obtener mensajes de éxito o error desde la sesión
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    // Limpiar los mensajes después de mostrarlos
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");

    try {
        con = Conexion.getConnection();
        if (con == null) {
%>
            <p style="color: red;">Error al conectar a la base de datos. Por favor, inténtelo más tarde.</p>
<%
            return;
        }

        ps = con.prepareStatement(query);
        ps.setString(1, idCurso);
        rs = ps.executeQuery();

        if (!rs.next()) {
%>
            <p style="color: red;">No se encontró el curso seleccionado. Por favor, intenta con otro curso.</p>
<%
        } else {
            // Obtener los datos del curso
            String nombreCurso = rs.getString("Nombre");
            int capacidad = rs.getInt("Capacidad");
            Date fechaInicio = rs.getDate("FechaInicio");
            Date fechaFin = rs.getDate("FechaFin");
            double precio = rs.getDouble("Precio");
            String categoriaCurso = rs.getString("CategoriaCurso");
            String imagenURL = rs.getString("ImagenURL");

            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            SimpleDateFormat sqlDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String fechaMatricula = sqlDateFormat.format(new Date()); // Fecha actual para la matrícula
%>
<%
    // Obtener mensajes de éxito o error desde la sesión
    successMessage = (String) session.getAttribute("successMessage");
    errorMessage = (String) session.getAttribute("errorMessage");

    // Limpiar los mensajes después de mostrarlos
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalles del Curso</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .container { max-width: 1200px; margin: 30px auto; padding: 20px; }
        .alert { margin-bottom: 20px; }
        .curso-item { display: flex; justify-content: space-between; align-items: center; background-color: #ffffff; border: 1px solid #ddd; border-radius: 8px; padding: 20px; margin: 20px 0; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); }
        .curso-info { flex: 1; margin-right: 20px; }
        .curso-imagen { flex: 0 0 350px; margin-right: 20px; }
        .curso-imagen img { width: 100%; height: auto; border-radius: 8px; object-fit: cover; }
        h2 { color: #333; text-align: center; }
        .btn-primary { background-color: #007bff; border: none; padding: 12px 25px; border-radius: 5px; color: white; text-decoration: none; }
        .btn-primary:hover { background-color: #0056b3; }
        .descripcion-general { margin: 20px 0; padding: 15px; background-color: #e9ecef; border-radius: 8px; text-align: center; color: #333; font-size: 1.1em; }
        .curso-item:hover { box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2); transition: box-shadow 0.3s ease; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Detalles del Curso</h2>

        <% if (successMessage != null) { %>
            <div class="alert alert-success" role="alert">
                <%= successMessage %>
            </div>
        <% } else if (errorMessage != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= errorMessage %>
            </div>
        <% } %>

        <div class="descripcion-general">
            <p>¡Inscríbete ahora y mejora tus habilidades! Este curso está diseñado para proporcionarte los conocimientos necesarios para avanzar en tu carrera.</p>
        </div>
        <div class="curso-item">
            <div class="curso-info">
                <h3>Matricúlate en el curso: <%= nombreCurso %></h3>
                <p><strong>Categoría:</strong> <%= categoriaCurso %></p>
                <p><strong>Capacidad:</strong> <%= capacidad %></p>
                <p><strong>Fecha de Inicio:</strong> <%= dateFormat.format(fechaInicio) %></p>
                <p><strong>Fecha de Fin:</strong> <%= dateFormat.format(fechaFin) %></p>
                <p><strong>Precio:</strong> <%= precio %> USD</p>
                <form action="MantenimientoServlet" method="post">
                    <input type="hidden" name="accion" value="registrarMatricula1" />
                    <input type="hidden" name="idAlumno" value="<%= idAlumno %>" />
                    <input type="hidden" name="idCurso" value="<%= idCurso %>" />
                    <input type="hidden" name="fechaMatricula" value="<%= fechaMatricula %>" />
                    <button type="submit" class="btn btn-primary">Matricúlate Ahora</button>
                </form>
                    <a href="dashboard.jsp" class="btn btn-secondary mt-3">Regresar al Dashboard</a>
            </div>
            <div class="curso-imagen">
                <img src="<%= imagenURL %>" alt="<%= nombreCurso %>" />
            </div>
        </div>
    </div>
</body>
</html>
<%
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p style='color: red;'>Error al obtener los datos del curso.</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
