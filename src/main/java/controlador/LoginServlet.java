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
import java.util.logging.Level;
import java.util.logging.Logger;
import modelo.Conexion;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String dni = request.getParameter("dni");
        String clave = request.getParameter("clave");

        try {
            // Conectar a la base de datos
            Connection con = Conexion.getConnection();
            
            // Consultar la contraseña encriptada por DNI
            String query = "SELECT u.Clave, u.Nombres, p.Nombre as Perfil FROM Usuario u " +
                           "JOIN Usuario_Perfiles up ON u.IdUsuario = up.IdUsuario " +
                           "JOIN Perfiles p ON up.IdPerfil = p.IdPerfil " +
                           "WHERE u.DNI = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, dni);
            
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String hashedClave = rs.getString("Clave");
                
                // Verificar si la clave ingresada coincide con la clave encriptada
                if (BCrypt.checkpw(clave, hashedClave)) {
                    // Obtener el nombre y perfil del usuario
                    String nombre = rs.getString("Nombres");
                    String perfil = rs.getString("Perfil");
                    
                    // Crear una sesión para el usuario autenticado
                    HttpSession session = request.getSession();
                    session.setAttribute("nombre", nombre);
                    session.setAttribute("perfil", perfil);
                    
                    // Redirigir dependiendo del perfil del usuario
                    if ("Administrador".equals(perfil)) {
                        response.sendRedirect("mantenimiento.jsp");
                    } else {
                        response.sendRedirect("dashboard.jsp");
                    }
                } else {
                    // Si la clave no coincide
                    response.sendRedirect("errorLogin.jsp");
                }
            } else {
                // Si no se encuentra el usuario
                response.sendRedirect("errorLogin.jsp");
            }
        } catch (IOException | SQLException e) {
            response.sendRedirect("errorLogin.jsp");
        }
    }
}
