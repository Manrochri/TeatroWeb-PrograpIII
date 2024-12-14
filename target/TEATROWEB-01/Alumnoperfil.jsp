<%-- 
    Document   : Alumnoperfil
    Created on : 9 dic. 2024, 3:07:49 p. m.
    Author     : USER
--%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page import="modelo.Conexion"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil del Alumno</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Perfil del Alumno</h3>
            </div>
            <div class="card-body">
                <p class="mb-3"><strong>Nombre:</strong> <%= request.getAttribute("nombreAlumno") %></p>

                <h4 class="mb-3">Cursos Matriculados</h4>
                <table class="table table-striped table-bordered">
                    <thead class="table-dark">
                        <tr>
                            <th>Curso</th>
                            <th>Docente</th>
                            <th>Fecha de Inicio</th>
                            <th>Fecha de Fin</th>
                            <th>Categoría</th>
                            <th>Fecha de Matrícula</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        List<Map<String, String>> cursosDetalles = (List<Map<String, String>>) request.getAttribute("cursosDetalles");
                        if (cursosDetalles != null) {
                            for (Map<String, String> curso : cursosDetalles) {
                        %>
                            <tr>
                                <td><%= curso.get("CursoNombre") %></td>
                                <td><%= curso.get("DocenteNombre") %></td>
                                <td><%= curso.get("FechaInicio") %></td>
                                <td><%= curso.get("FechaFin") %></td>
                                <td><%= curso.get("CategoriaNombre") %></td>
                                <td><%= curso.get("FechaMatricula") %></td>
                            </tr>
                        <%
                            }
                        } else {
                        %>
                            <tr>
                                <td colspan="6" class="text-center">No hay cursos matriculados</td>
                            </tr>
                        <%
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
