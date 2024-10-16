package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelo.Conexion;

@WebServlet("/PerfilDocenteServlet")
public class PerfilDocenteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("nombre") == null) {
            response.sendRedirect("loginUsuario.jsp");
            return;
        }

        // Obtener los grados académicos de la base de datos
        List<String> gradosAcademicos = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = Conexion.getConnection();
            String sql = "SELECT Nombre FROM GradoAcademico";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                gradosAcademicos.add(rs.getString("Nombre"));
            }

            // Guardar los grados académicos en el request
            request.setAttribute("gradosAcademicos", gradosAcademicos);

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Redirigir a perfilDocente.jsp con los grados académicos
        request.getRequestDispatcher("perfilDocente.jsp").forward(request, response);
    }
}
