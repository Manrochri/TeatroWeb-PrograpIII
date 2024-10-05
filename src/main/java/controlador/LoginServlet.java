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
import modelo.Conexion;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String dni = request.getParameter("dni");
        String clave = request.getParameter("clave");

        try {
            // Conectar a la base de datos
            Connection con = Conexion.getConnection();
            
            // Consultar el usuario por DNI y clave
            String query = "SELECT u.Nombres, p.Nombre as Perfil FROM Usuario u " +
                           "JOIN Usuario_Perfiles up ON u.IdUsuario = up.IdUsuario " +
                           "JOIN Perfiles p ON up.IdPerfil = p.IdPerfil " +
                           "WHERE u.DNI = ? AND u.Clave = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, dni);
            ps.setString(2, clave);
            
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Obtener el nombre y perfil del usuario
                String nombre = rs.getString("Nombres");
                String perfil = rs.getString("Perfil");
                
                // Crear una sesión para el usuario autenticado
                HttpSession session = request.getSession();
                session.setAttribute("nombre", nombre);
                session.setAttribute("perfil", perfil);
                
                // Redirigir dependiendo del perfil del usuario
                if ("Administrador".equals(perfil)) {
                    // Redirigir a la página de mantenimiento si es administrador
                    response.sendRedirect("mantenimiento.jsp");
                } else {
                    // Redirigir a una página común para otros perfiles
                    response.sendRedirect("dashboard.jsp");
                }
            } else {
                // Si el login falla, redirigir a una página de error
                response.sendRedirect("errorLogin.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("errorLogin.jsp");
        }
    }
}
