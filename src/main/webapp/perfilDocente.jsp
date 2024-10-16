<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    if (session == null || session.getAttribute("perfil") == null
            || !"Docente".equals(session.getAttribute("perfil"))) {
        response.sendRedirect("errorAcceso.jsp");
        return;
    }
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
    <div class="container mt-5">
        <h1>Bienvenido, <%= session.getAttribute("nombre") %> <%= session.getAttribute("apellido") %></h1>
        <p>Rol: <%= session.getAttribute("perfil") %></p>
        
        <!-- Botón para cerrar sesión -->
        <form action="LogoutServlet" method="post">
            <button type="submit" class="btn btn-danger">Cerrar Sesión</button>
        </form>
    </div>
</body>
</html>
