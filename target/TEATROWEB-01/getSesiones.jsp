<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    String jdbcUrl = "jdbc:mysql://localhost:3306/teatroweb";
    String jdbcUser = "root";
    String jdbcPassword = "";
    Connection conn = null;
    PreparedStatement stmtSesiones = null;
    ResultSet rsSesiones = null;
    
    // Obtener el parámetro 'cursoId' desde la solicitud GET
    String cursoId = request.getParameter("IdCurso");
    
    if (cursoId != null && !cursoId.isEmpty()) {
        try {
            // Cargar el controlador JDBC
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Conexión a la base de datos
            conn = DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);
            
            // Consulta para obtener sesiones de un curso específico
            String querySesiones = "SELECT IdSesion, NombreSesion FROM sesion WHERE IDcurso = ? AND EstadoRegistro = 1";
            stmtSesiones = conn.prepareStatement(querySesiones);
            stmtSesiones.setInt(1, Integer.parseInt(cursoId));  // Usar 'IDcurso' de la base de datos
            rsSesiones = stmtSesiones.executeQuery();
            
            // Si hay sesiones, las agregamos al select
            boolean hasSessions = false;
            while (rsSesiones.next()) {
                hasSessions = true;
                out.print("<option value=\"" + rsSesiones.getInt("IdSesion") + "\">" + rsSesiones.getString("NombreSesion") + "</option>");
            }
            
            // Si no hay sesiones, mostrar un mensaje
            if (!hasSessions) {
                out.print("<option value=\"\">No hay sesiones disponibles</option>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("<option value=\"\">Error al cargar sesiones</option>");
        } finally {
            // Cerrar los recursos
            try { if (rsSesiones != null) rsSesiones.close(); } catch (Exception e) { /* Ignorar */ }
            try { if (stmtSesiones != null) stmtSesiones.close(); } catch (Exception e) { /* Ignorar */ }
            try { if (conn != null) conn.close(); } catch (Exception e) { /* Ignorar */ }
        }
    } else {
        out.print("<option value=\"\">Seleccione un curso primero</option>");
    }
%>
