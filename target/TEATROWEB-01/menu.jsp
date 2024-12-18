<%@ page import="modelo.Conexion" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>


<%
    // Obtener el IdPerfil de la sesión
    if (session == null || session.getAttribute("IdPerfil") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int idPerfil = (int) session.getAttribute("IdPerfil");

    // Consultar las opciones de menú según el perfil
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String query = "SELECT om.IdOpcionMenu, om.Nombre, om.UrlMenu, om.IdPadre " +
                   "FROM opcionesmenu om " +
                   "JOIN opcionesmenu_perfiles omp ON om.IdOpcionMenu = omp.IdOpcionMenu " +
                   "WHERE omp.IdPerfil = ? " +
                   "ORDER BY omp.Orden ASC";

    con = Conexion.getConnection();
    ps = con.prepareStatement(query);
    ps.setInt(1, idPerfil);
    rs = ps.executeQuery();

    // Crear un mapa para almacenar las opciones de menú y sus submenús
    Map<Integer, List<String>> subMenus = new HashMap<>();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menú</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .menu-vertical {
            position: fixed;
            left: 0;
            top: 0;
            width: 250px;
            height: 100%;
            background-color: #2c3e50;
            color: white;
            display: flex;
            flex-direction: column;
            padding-top: 20px;
        }

        .menu-vertical a {
            text-decoration: none;
            color: white;
            padding: 15px 20px;
            display: block;
        }

        .menu-vertical a:hover {
            background-color: #34495e;
        }

        .menu-header {
            text-align: center;
            padding: 20px;
            font-size: 18px;
            font-weight: bold;
            background-color: #1abc9c;
        }

        .menu-logout {
            margin-top: auto;
            
            text-align: center;
        }

        .menu-logout a:hover {
            background-color: #c0392b;
        }

        .submenu {
            display: none; /* Ocultar submenús por defecto */
            padding-left: 20px; /* Indentación para submenús */
        }
        
        .submenu a {
            padding-left: 30px; /* Espacio adicional para submenús */
        }
        
        .dropbtn {
            background-color: transparent; 
            border: none; 
            color: white; 
            text-align: left; 
            width: 100%; 
            padding: 15px 20px; 
            cursor: pointer; 
        }
        
        .dropbtn:hover {
            background-color: #34495e; 
        }
    </style>
</head>
<body>
    <div class="menu-vertical">
        <div class="menu-header">
            <%= session.getAttribute("nombre") %> <br>
            Perfil: <%= session.getAttribute("perfil") %>
        </div>

        <%
          // Primero, procesar las opciones de menú
          while (rs.next()) {
              int idOpcionMenu = rs.getInt("IdOpcionMenu");
              String nombreOpcion = rs.getString("Nombre");
              String urlOpcion = rs.getString("UrlMenu");
              int idPadre = rs.getInt("IdPadre");

              // Si no hay padre, es un elemento de primer nivel
              if (idPadre == 0) { // Considerando que 0 significa que no tiene padre
                  // Comenzar un nuevo botón de menú
                  out.println("<button class='dropbtn' onclick='toggleSubmenu(" + idOpcionMenu + ")'>" + nombreOpcion + "</button>");
                  out.println("<ul class='submenu' id='submenu-" + idOpcionMenu + "'>");
                  
                  // Ahora buscar submenús relacionados
                  PreparedStatement subPs = con.prepareStatement("SELECT Nombre, UrlMenu FROM opcionesmenu WHERE IdPadre = ?");
                  subPs.setInt(1, idOpcionMenu);
                  ResultSet subRs = subPs.executeQuery();

                  while (subRs.next()) {
                      String nombreSubOpcion = subRs.getString("Nombre");
                      String urlSubOpcion = subRs.getString("UrlMenu");
                      out.println("<li><a href='" + urlSubOpcion + "'>" + nombreSubOpcion + "</a></li>");
                  }
                  
                  out.println("</ul>");
                  subRs.close();
                  subPs.close();
              }
          }
          ps.close();
          rs.close();
          con.close();
        %>

        <div class="menu-logout">
             <form action="LogoutServlet" method="post" class="mt-3">
                        <button type="submit" class="btn btn-danger w-100">Cerrar Sesión</button>
             </form>
        </div>
    </div>

    <script>
      function toggleSubmenu(id) {
          var submenu = document.getElementById('submenu-' + id);
          submenu.style.display = submenu.style.display === 'block' ? 'none' : 'block';
      }
    </script>
</body>
</html>
