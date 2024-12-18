<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="modelo.Conexion"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
   
    if (session == null || session.getAttribute("nombre") == null) {
        response.sendRedirect("loginUsuario.jsp");
        return;
    }

    // Obteniendo el nombre del usuario y su rol desde la sesión
    String nombreUsuario = (String) session.getAttribute("nombre");
    String rolUsuario = (String) session.getAttribute("perfil");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Perfil del Usuario</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="styles/dashboard.css">
    </head>
    <body>
        <div class="menu-column">
            <jsp:include page="menu.jsp" />
        </div>
        
        <div class="content-column">
            <div class="container mt-5">
                <h2 class="text-center">Bienvenido, <%= nombreUsuario %></h2>
                <p class="text-center">Tu perfil es: <strong><%= rolUsuario %></strong></p>
            </div>
            
            <h1>Catálogo de cursos disponibles</h1>
            <div class="card-container">
                <%
                    Connection con = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        con = Conexion.getConnection();
                        String query = "SELECT c.IdCurso, c.Nombre AS CursoNombre, c.ImagenURL, cc.Nombre AS CategoriaNombre, c.Capacidad "
                                       + "FROM curso c "
                                       + "JOIN categoriacurso cc ON c.IdCategoria = cc.IdCategoria "
                                       + "WHERE c.EstadoRegistro = 1";
                        ps = con.prepareStatement(query);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                            int idCurso = rs.getInt("IdCurso");
                            String nombreCurso = rs.getString("CursoNombre");
                            String imagenURL = rs.getString("ImagenURL");
                            String categoria = rs.getString("CategoriaNombre");
                            String categoriaFormatted = categoria.substring(0, 1).toUpperCase() + categoria.substring(1).toLowerCase();
                            int capacidad = rs.getInt("Capacidad");
                %>
                            <div class="card">
                                <a href="matricula.jsp?idCurso=<%= idCurso %>" class="card-link">
                                    <img src="<%= imagenURL %>" alt="Imagen del curso" class="card-img-top">
                                    <div class="card-body">
                                        <h3 class="card-title"><%= nombreCurso %></h3>
                                        <p class="card-text">Categoría: <%= categoriaFormatted %></p>
                                        <p class="card-text">Capacidad: <%= capacidad %></p>
                                    </div>
                                </a>
                            </div>
                <%
                        }
                    } catch (SQLException e) {
                        out.println("<p class='text-danger'>Error al obtener los cursos: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </div>
        </div>
    </body>
</html>
