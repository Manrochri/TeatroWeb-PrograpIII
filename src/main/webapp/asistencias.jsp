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

    // Obtener cursos
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);
        
        String queryCursos = "SELECT IdCurso, Nombre FROM curso WHERE EstadoRegistro = 1";
        stmtCursos = conn.prepareStatement(queryCursos);
        rsCursos = stmtCursos.executeQuery();
        
        while (rsCursos.next()) {
            cursos.add(rsCursos.getInt("IdCurso") + "|" + rsCursos.getString("Nombre"));
        }

        // Si se ha seleccionado un curso y una sesión
        String cursoId = request.getParameter("cursoSelect");
        String sesionId = request.getParameter("sesionSelect");

        if (cursoId != null && sesionId != null) {
            // Obtener los alumnos de la sesión seleccionada
            String queryAlumnos = "SELECT a.Nombre FROM alumno a " +
                                   "JOIN inscripcion i ON a.IdAlumno = i.IdAlumno " +
                                   "WHERE i.IdCurso = ? AND i.EstadoRegistro = 1";
            stmtAlumnos = conn.prepareStatement(queryAlumnos);
            stmtAlumnos.setInt(1, Integer.parseInt(cursoId));
            rsAlumnos = stmtAlumnos.executeQuery();
            
            while (rsAlumnos.next()) {
                alumnos.add(rsAlumnos.getString("Nombre"));
            }

            // Obtener los estados de asistencia
            String queryEstadosAsistencia = "SELECT IdEstadoAsistencia, TipoAsistencia FROM estadosasistencia WHERE EstadoRegistro = 1";
            stmtEstadosAsistencia = conn.prepareStatement(queryEstadosAsistencia);
            rsEstadosAsistencia = stmtEstadosAsistencia.executeQuery();
            
            while (rsEstadosAsistencia.next()) {
                estadosAsistencia.add(rsEstadosAsistencia.getInt("IdEstadoAsistencia") + "|" + rsEstadosAsistencia.getString("TipoAsistencia"));
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<html>
<head>
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        // Función para actualizar las sesiones según el curso seleccionado
        function cargarSesiones() {
            var cursoId = document.getElementById("cursoSelect").value;
            console.log("Curso seleccionado: " + cursoId);  // Para depurar

            if (cursoId !== "") {
                $.ajax({
                    url: 'getSesiones.jsp',
                    type: 'GET',
                    data: {cursoId: cursoId},  // Enviar el parámetro 'cursoId'
                    success: function(data) {
                        console.log(data);  // Ver lo que devuelve el servidor
                        document.getElementById("sesionSelect").innerHTML = data;
                    },
                    error: function(xhr, status, error) {
                        console.error('Error en la solicitud AJAX: ' + status + ' ' + error);
                    }
                });
            } else {
                // Si no se ha seleccionado un curso, mostrar un mensaje o vaciar el select
                document.getElementById("sesionSelect").innerHTML = "<option value=\"\">Seleccione un curso primero</option>";
            }
        }

    </script>
</head>
<body>
    <form method="post">
        <label for="cursoSelect">Seleccionar Curso:</label>
        <select id="cursoSelect" name="cursoSelect" onchange="cargarSesiones()">  <!-- Llama la función cuando el curso cambia -->
            <option value="">Seleccione un curso</option>
            <%
                for (String curso : cursos) {
                    String[] cursoDatos = curso.split("\\|");
                    out.print("<option value=\"" + cursoDatos[0] + "\">" + cursoDatos[1] + "</option>");
                }
            %>
        </select>
        
        <label for="sesionSelect">Seleccionar Sesión:</label>
        <select id="sesionSelect" name="sesionSelect" onchange="cargarTablaAsistencia()">
            <option value="">Seleccione una sesión</option>
            <% 
                for (String sesion : sesiones) {
                    String[] sesionDatos = sesion.split("\\|");
                    out.print("<option value=\"" + sesionDatos[0] + "\">" + sesionDatos[1] + "</option>");
                }
            %>
        </select>

        <!-- Aquí empieza la tabla de asistencia -->
        <table border="1">
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
                            out.print("<select name='estadoAsistencia_" + alumno + "'>");
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

        <input type="submit" value="Guardar Asistencia">
    </form>
</body>
</html>
