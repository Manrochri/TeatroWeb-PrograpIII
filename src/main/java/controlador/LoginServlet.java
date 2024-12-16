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
import modelo.Conexion;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String usuario = request.getParameter("usuario");  // DNI o Correo
        String clave = request.getParameter("clave");

        try {
            // Conectar a la base de datos
            Connection con = Conexion.getConnection();
            
            // Consulta dependiendo de si es un correo electrónico o un DNI
            String query = "";
if (usuario.contains("@")) {  // Si el usuario contiene "@", asumimos que es un correo electrónico
    query = "SELECT u.IdUsuario, u.Clave, u.Nombres, u.ApellidoPaterno, p.IdPerfil, p.Nombre as Perfil " +
            "FROM Usuario u " +
            "JOIN Usuario_Perfiles up ON u.IdUsuario = up.IdUsuario " +
            "JOIN Perfiles p ON up.IdPerfil = p.IdPerfil " +
            "WHERE u.CorreoElectronico = ?";
} else {  // De lo contrario, asumimos que es un DNI
    query = "SELECT u.IdUsuario, u.Clave, u.Nombres, u.ApellidoPaterno, p.IdPerfil, p.Nombre as Perfil " +
            "FROM Usuario u " +
            "JOIN Usuario_Perfiles up ON u.IdUsuario = up.IdUsuario " +
            "JOIN Perfiles p ON up.IdPerfil = p.IdPerfil " +
            "WHERE u.DNI = ?";
}


            // Preparar y ejecutar la consulta
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, usuario);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String hashedClave = rs.getString("Clave");
                
                // Verificar si la clave ingresada coincide con la clave encriptada
                if (BCrypt.checkpw(clave, hashedClave)) {
                    // Obtener los datos del usuario
                    String nombre = rs.getString("Nombres");
                    String apellido = rs.getString("ApellidoPaterno");
                    String perfil = rs.getString("Perfil");
                    int idUsuario = rs.getInt("IdUsuario");
                    int idPerfil = rs.getInt("IdPerfil");
                    
                    // Crear una sesión para el usuario autenticado
                    HttpSession session = request.getSession();
                    session.setAttribute("nombre", nombre);
                    session.setAttribute("apellido", apellido);
                    session.setAttribute("perfil", perfil);
                    session.setAttribute("IdUsuario", idUsuario);
                    session.setAttribute("IdPerfil", idPerfil);
                    
                    // Redirigir según el perfil
                    switch (perfil.toUpperCase()) {
                        case "ADMINISTRADOR":
                            response.sendRedirect("mantenimiento.jsp");
                            break;
                        case "DOCENTE":
                            response.sendRedirect("perfilDocente.jsp");
                            break;
                        default:
                            response.sendRedirect("dashboard.jsp");
                            break;
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
            // En caso de error, redirigir a la página de error
            response.sendRedirect("errorLogin.jsp");
        }
    }
}
