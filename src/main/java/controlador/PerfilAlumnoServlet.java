package controlador;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import modelo.Conexion;


@WebServlet("/PerfilAlumnoServlet")
public class PerfilAlumnoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idAlumno = request.getParameter("idAlumno");

        if (idAlumno == null || idAlumno.isEmpty()) {
            request.setAttribute("error", "No se proporcionó un ID válido para el alumno.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement stmtMatriculas = null;
        ResultSet rsMatriculas = null;
        String nombreAlumno = "";
        List<Map<String, String>> cursosDetalles = new ArrayList<>();

        try {
            conn = Conexion.getConnection();

            // Consulta SQL para obtener la información completa de los cursos matriculados, el docente, la categoría y fechas.
            String sqlMatriculas = 
                "SELECT u.Nombres AS AlumnoNombre, u.ApellidoPaterno AS AlumnoApellidoP, u.ApellidoMaterno AS AlumnoApellidoM, " +
                "c.Nombre AS CursoNombre, cd.IdDocente, d.Nombres AS DocenteNombre, " +
                "c.FechaInicio, c.FechaFin, cc.Nombre AS CategoriaNombre, m.FechaMatricula " +
                "FROM Matriculas m " +
                "JOIN Alumno a ON m.IdAlumno = a.IdAlumno " +
                "JOIN Usuario u ON a.IdUsuario = u.IdUsuario " +
                "JOIN Curso c ON m.IdCurso = c.IdCurso " +
                "JOIN curso_docente cd ON c.IdCurso = cd.IdCurso AND cd.EstadoRegistro = 1 " +
                "JOIN docente d ON cd.IdDocente = d.IdDocente " +
                "JOIN categoriacurso cc ON c.IdCategoria = cc.IdCategoria " +
                "WHERE m.EstadoRegistro = 1 AND m.IdAlumno = ?";

            stmtMatriculas = conn.prepareStatement(sqlMatriculas);
            stmtMatriculas.setString(1, idAlumno);
            rsMatriculas = stmtMatriculas.executeQuery();

            while (rsMatriculas.next()) {
                if (nombreAlumno.isEmpty()) {
                    nombreAlumno = rsMatriculas.getString("AlumnoNombre") + " " +
                                   rsMatriculas.getString("AlumnoApellidoP") + " " +
                                   rsMatriculas.getString("AlumnoApellidoM");
                }

                // Crear un mapa con toda la información del curso
                Map<String, String> cursoDetalle = new HashMap<>();
                cursoDetalle.put("CursoNombre", rsMatriculas.getString("CursoNombre"));
                cursoDetalle.put("DocenteNombre", rsMatriculas.getString("DocenteNombre"));
                cursoDetalle.put("FechaInicio", rsMatriculas.getString("FechaInicio"));
                cursoDetalle.put("FechaFin", rsMatriculas.getString("FechaFin"));
                cursoDetalle.put("CategoriaNombre", rsMatriculas.getString("CategoriaNombre"));
                cursoDetalle.put("FechaMatricula", rsMatriculas.getString("FechaMatricula"));

                cursosDetalles.add(cursoDetalle);
            }

            request.setAttribute("nombreAlumno", nombreAlumno);
            request.setAttribute("cursosDetalles", cursosDetalles);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al obtener la información del alumno: " + e.getMessage());
        } finally {
            try { if (rsMatriculas != null) rsMatriculas.close(); } catch (Exception e) { /* Ignorar */ }
            try { if (stmtMatriculas != null) stmtMatriculas.close(); } catch (Exception e) { /* Ignorar */ }
            try { if (conn != null) conn.close(); } catch (Exception e) { /* Ignorar */ }
        }

        request.getRequestDispatcher("Alumnoperfil.jsp").forward(request, response);
    }
}