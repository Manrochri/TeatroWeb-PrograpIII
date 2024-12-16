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
%>

<%! 
    public List<Map<String, String>> obtenerCursos() {
        List<Map<String, String>> cursos = new ArrayList<>();
        try (Connection con = Conexion.getConnection()) {
            String query = "SELECT Nombre, Categoria, Capacidad, ImagenURL FROM Curso";
            try (PreparedStatement ps = con.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> curso = new HashMap<>();
                    curso.put("nombre", rs.getString("Nombre"));
                    curso.put("categoria", rs.getString("Categoria"));
                    curso.put("capacidad", String.valueOf(rs.getInt("Capacidad")));
                    curso.put("imagenURL", rs.getString("ImagenURL"));
                    cursos.add(curso);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cursos;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Perfil del Usuario</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="styles/dashboard.css">
    </head>
    <body>
        <div class="container mt-5">
            <h2 class="text-center">Bienvenido, <%= session.getAttribute("nombre") %></h2>
            <p class="text-center">Tu perfil es: <strong><%= session.getAttribute("perfil") %></strong></p>
        </div>
        
        <h1>Catálogo de cursos disponibles</h1>
    <div class="card-container">
        <% 
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            String query = "SELECT c.Nombre AS CursoNombre, c.ImagenURL, cc.Nombre AS CategoriaNombre, c.Capacidad FROM curso c JOIN categoriacurso cc ON c.IdCategoria = cc.IdCategoria WHERE c.EstadoRegistro = 1";

// Ajusta la consulta según lo que necesites

            try {
                con = Conexion.getConnection();
                ps = con.prepareStatement(query);
                rs = ps.executeQuery();

                while (rs.next()) {
                    String nombreCurso = rs.getString("CursoNombre");
                    String imagenURL = rs.getString("ImagenURL");
                    String categoria = rs.getString("CategoriaNombre"); // Deberías hacer un JOIN para obtener el nombre de la categoría
                    String categoriaFormatted = categoria.substring(0, 1).toUpperCase() + categoria.substring(1).toLowerCase(); // Formateo aquí
                    int capacidad = rs.getInt("Capacidad");
        %>
        <div class="card">
            
            <img src="<%= imagenURL %>" alt="Imagen del curso">
            <div class="card-content">
            <h3><%= nombreCurso %></h3>
            <p>Categoría: <%= categoriaFormatted  %></p>
            <p>Capacidad: <%= capacidad %></p>
            </div>
        </div>
        <% 
                }
            } catch (SQLException e) {
                out.println("Error al obtener los cursos: " + e.getMessage());
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
    </div>
        
    </body>
</html>
