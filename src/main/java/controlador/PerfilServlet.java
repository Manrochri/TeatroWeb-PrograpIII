package controlador;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Perfil;
import modelo.PerfilDAO;

@WebServlet("/PerfilServlet")
public class PerfilServlet extends HttpServlet {
    
    // Maneja la obtención de perfiles
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Perfil> perfiles = new ArrayList<>();

        String url = "jdbc:mysql://localhost:3306/teatroweb";
        String username = "root";
        String password = "";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Cargar el controlador JDBC de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establecer la conexión
            conn = DriverManager.getConnection(url, username, password);

            // Preparar y ejecutar la consulta
            String sql = "SELECT IdPerfil, Nombre FROM Perfiles WHERE EstadoRegistro = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setBoolean(1, true);
            rs = stmt.executeQuery();

            // Agregar resultados a la lista
            while (rs.next()) {
                Perfil perfil = new Perfil();
                perfil.setIdPerfil(rs.getInt("IdPerfil"));
                perfil.setNombre(rs.getString("Nombre"));
                perfiles.add(perfil);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al conectar con la base de datos: " + e.getMessage());
        } finally {
            // Cerrar recursos
            try { if (rs != null) rs.close(); } catch (Exception e) { /* Ignorar */ }
            try { if (stmt != null) stmt.close(); } catch (Exception e) { /* Ignorar */ }
            try { if (conn != null) conn.close(); } catch (Exception e) { /* Ignorar */ }
        }

        // Enviar la lista de perfiles a la JSP
        request.setAttribute("perfiles", perfiles);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    // Maneja el registro de un nuevo perfil
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener los parámetros del formulario
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");

        // Crear el objeto Perfil
        Perfil nuevoPerfil = new Perfil();
        nuevoPerfil.setNombre(nombre);
        nuevoPerfil.setDescripcion(descripcion);

        // Registrar el perfil a través de PerfilDAO
        PerfilDAO perfilDAO = new PerfilDAO();
        boolean registrado = perfilDAO.registrarPerfil(nuevoPerfil);

        // Redirigir según el resultado
        if (registrado) {
            response.sendRedirect("registroExitoso.jsp");
        } else {
            response.sendRedirect("errorRegistro.jsp");
        }
    }
}
