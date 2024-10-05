<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("nombre") == null) {
        response.sendRedirect("loginUsuario.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Perfil del Usuario</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="styles/styles.css">
    </head>
    <body>
        <div class="container mt-5">
            <h2 class="text-center">Bienvenido, <%= session.getAttribute("nombre") %></h2>
            <p class="text-center">Tu perfil es: <strong><%= session.getAttribute("perfil") %></strong></p>
        </div>
    </body>
</html>
