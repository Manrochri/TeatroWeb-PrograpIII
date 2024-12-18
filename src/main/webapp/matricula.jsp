<%@page import="java.util.Date"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="modelo.Conexion"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
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
                + "WHERE c.IdCurso = ? AND c.EstadoRegistro = 1 AND cat.EstadoRegistro = 1";

   try {
       con = Conexion.getConnection();
       ps = con.prepareStatement(query);
       ps.setString(1, idCurso);
       rs = ps.executeQuery();

       if (!rs.next()) {
%>
           <p>No se encontró el curso seleccionado. Por favor, intenta con otro curso.</p>
<%
       } else {
           String nombreCurso = rs.getString("Nombre");
           int capacidad = rs.getInt("Capacidad");
           Date fechaInicio = rs.getDate("FechaInicio");
           Date fechaFin = rs.getDate("FechaFin");
           double precio = rs.getDouble("Precio");
           String categoriaCurso = rs.getString("CategoriaCurso");
           String imagenURL = rs.getString("ImagenURL");

           SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
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

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 20px;
        }

        .curso-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #ffffff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .curso-info {
            flex: 1;
            margin-right: 20px;
        }

        .curso-imagen {
            flex: 0 0 350px; /* Aumenta el tamaño de la imagen */
            margin-right: 20px;
        }

        .curso-imagen img {
            width: 100%;
            height: auto;
            border-radius: 8px;
            object-fit: cover; /* Ajusta la imagen para que se vea bien en diferentes tamaños */
        }

        h2 {
            color: #333;
            text-align: center;
        }

        .btn-primary {
            background-color: #007bff;
            border: none;
            padding: 12px 25px;
            border-radius: 5px;
            color: white;
            text-decoration: none }

        .btn-primary:hover {
            background-color: #0056b3;
        }

        .descripcion-general {
            margin: 20px 0;
            padding: 15px;
            background-color: #e9ecef;
            border-radius: 8px;
            text-align: center;
            color: #333;
            font-size: 1.1em;
        }

        .curso-item:hover {
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            transition: box-shadow 0.3s ease;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Detalles del Curso</h2>
        <div class="descripcion-general">
            <p>¡Inscríbete ahora y mejora tus habilidades! Este curso está diseñado para proporcionarte los conocimientos necesarios para avanzar en tu carrera. No pierdas la oportunidad de aprender de los mejores y de formar parte de una comunidad de estudiantes apasionados.</p>
        </div>
        <div class="curso-item">
            <div class="curso-info">
                <h3>Matricúlate en el curso: <%= nombreCurso %></h3>
                <p><strong>Categoría:</strong> <%= categoriaCurso %></p>
                <p><strong>Capacidad:</strong> <%= capacidad %></p>
                <p><strong>Fecha de Inicio:</strong> <%= dateFormat.format(fechaInicio) %></p>
                <p><strong>Fecha de Fin:</strong> <%= dateFormat.format(fechaFin) %></p>
                <p><strong>Precio:</strong> <%= precio %> USD</p>
                
                <form action="confirmarMatricula.jsp" method="post">
                    <input type="hidden" name="idCurso" value="<%= idCurso %>" />
                    <input type="hidden" name="nombreCurso" value="<%= nombreCurso %>" />
                    <input type="hidden" name="precio" value="<%= precio %>" />
                    <button type="submit" class="btn btn-primary">Matricúlate Ahora</button>
                </form>
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
       out.println("Error al obtener los datos del curso: " + e.getMessage());
   } finally {
       if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
       if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
       if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
   }
%>