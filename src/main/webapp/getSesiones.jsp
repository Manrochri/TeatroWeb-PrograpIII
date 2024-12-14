<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    String jdbcUrl = "jdbc:mysql://localhost:3306/teatroweb";
    String jdbcUser = "root";
    String jdbcPassword = "";
    Connection conn = null;
    PreparedStatement stmtCursos = null;
    PreparedStatement stmtSesiones = null;
    PreparedStatement stmtAlumnos = null;
    PreparedStatement stmtEstadosAsistencia = null;
    ResultSet rsCursos = null;
    ResultSet rsSesiones = null;
    ResultSet rsAlumnos = null;
    ResultSet rsEstadosAsistencia = null;

    ArrayList<String> cursos = new ArrayList<>();
    ArrayList<String> sesiones = new ArrayList<>();
    ArrayList<String> alumnos = new ArrayList<>();
    ArrayList<String> estadosAsistencia = new ArrayList<>();

    String selectedCurso = request.getParameter("cursoSelect");
    String selectedSesion = request.getParameter("sesionSelect");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);

        // Obtener cursos
        String queryCursos = "SELECT IdCurso, Nombre FROM curso WHERE EstadoRegistro = 1";
        stmtCursos = conn.prepareStatement(queryCursos);
        rsCursos = stmtCursos.executeQuery();
        while (rsCursos.next()) {
            cursos.add(rsCursos.getInt("IdCurso") + "|" + rsCursos.getString("Nombre"));
        }

        // Si se seleccionó un curso, obtener las sesiones
        if (selectedCurso != null && !selectedCurso.isEmpty()) {
            String querySesiones = "SELECT IdSesion, NombreSesion FROM sesion WHERE IDcurso = ? AND EstadoRegistro = 1";
            stmtSesiones = conn.prepareStatement(querySesiones);
            stmtSesiones.setInt(1, Integer.parseInt(selectedCurso));
            rsSesiones = stmtSesiones.executeQuery();
            while (rsSesiones.next()) {
                sesiones.add(rsSesiones.getInt("IdSesion") + "|" + rsSesiones.getString("NombreSesion"));
            }
        }

        // Si se seleccionó una sesión, obtener los alumnos
        if (selectedSesion != null && !selectedSesion.isEmpty()) {
            String queryAlumnos = "SELECT a.Nombre FROM alumno a " +
                                   "JOIN inscripcion i ON a.IdAlumno = i.IdAlumno " +
                                   "WHERE i.IdCurso = ? AND i.EstadoRegistro = 1";
            stmtAlumnos = conn.prepareStatement(queryAlumnos);
            stmtAlumnos.setInt(1, Integer.parseInt(selectedCurso));
            rsAlumnos = stmtAlumnos.executeQuery();
            while (rsAlumnos.next()) {
                alumnos.add(rsAlumnos.getString("Nombre"));
            }
        }

        // Obtener estados de asistencia
        String queryEstadosAsistencia = "SELECT IdEstadoAsistencia, TipoAsistencia FROM estadosasistencia WHERE EstadoRegistro = 1";
        stmtEstadosAsistencia = conn.prepareStatement(queryEstadosAsistencia);
        rsEstadosAsistencia = stmtEstadosAsistencia.executeQuery();
        while (rsEstadosAsistencia.next()) {
            estadosAsistencia.add(rsEstadosAsistencia.getInt("IdEstadoAsistencia") + "|" + rsEstadosAsistencia.getString("TipoAsistencia"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rsCursos != null) rsCursos.close(); } catch (Exception e) { }
        try { if (rsSesiones != null) rsSesiones.close(); } catch (Exception e) { }
        try { if (rsAlumnos != null) rsAlumnos.close(); } catch (Exception e) { }
        try { if (rsEstadosAsistencia != null) rsEstadosAsistencia.close(); } catch (Exception e) { }
        try { if (stmtCursos != null) stmtCursos.close(); } catch (Exception e) { }
        try { if (stmtSesiones != null) stmtSesiones.close(); } catch (Exception e) { }
        try { if (stmtAlumnos != null) stmtAlumnos.close(); } catch (Exception e) { }
        try { if (stmtEstadosAsistencia != null) stmtEstadosAsistencia.close(); } catch (Exception e) { }
        try { if (conn != null) conn.close(); } catch (Exception e) { }
    }
%>

<!-- Incluyendo Bootstrap CSS desde un CDN -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Asistencias</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container my-5">
        <!-- Título centrado -->
        <div class="text-center mb-4">
            <h1 class="text-primary">Sistema de Asistencia - Selección de Cursos</h1>
        </div>

        <!-- Formulario centrado -->
        <div class="row justify-content-center">
            <div class="col-md-8">
                <form method="post" class="needs-validation" novalidate>
                    <div class="mb-3">
                        <label for="cursoSelect" class="form-label">Seleccionar Curso</label>
                        <select id="cursoSelect" name="cursoSelect" class="form-select" onchange="this.form.submit();">
                            <option value="">Seleccione un curso</option>
                            <%
                                for (String curso : cursos) {
                                    String[] cursoDatos = curso.split("\\|");
                                    String selected = cursoDatos[0].equals(selectedCurso) ? "selected" : "";
                                    out.print("<option value=\"" + cursoDatos[0] + "\" " + selected + ">" + cursoDatos[1] + "</option>");
                                }
                            %>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="sesionSelect" class="form-label">Seleccionar Sesión</label>
                        <select id="sesionSelect" name="sesionSelect" class="form-select" onchange="this.form.submit();">
                            <option value="">Seleccione una sesión</option>
                            <%
                                for (String sesion : sesiones) {
                                    String[] sesionDatos = sesion.split("\\|");
                                    String selected = sesionDatos[0].equals(selectedSesion) ? "selected" : "";
                                    out.print("<option value=\"" + sesionDatos[0] + "\" " + selected + ">" + sesionDatos[1] + "</option>");
                                }
                            %>
                        </select>
                    </div>
                </form>
            </div>
        </div>

        <!-- Tabla centrada con los alumnos -->
        <div class="table-responsive mt-4">
            <table class="table table-striped table-hover text-center">
                <thead>
                    <tr>
                        <th>Alumno</th>
                        <th>Estado de Asistencia</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (alumnos.size() > 0) {
                            for (String alumno : alumnos) {
                                out.print("<tr>");
                                out.print("<td>" + alumno + "</td>");
                                out.print("<td>");
                                out.print("<select class='form-select' name='estadoAsistencia_" + alumno + "'>");
                                for (String estado : estadosAsistencia) {
                                    String[] estadoDatos = estado.split("\\|");
                                    out.print("<option value='" + estadoDatos[0] + "'>" + estadoDatos[1] + "</option>");
                                }
                                out.print("</select>");
                                out.print("</td>");
                                out.print("</tr>");
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Incluyendo Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html>
