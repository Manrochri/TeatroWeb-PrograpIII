package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import modelo.Usuario;
import modelo.UsuarioDAO;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/registrarUsuario")
public class RegistroUsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Configurar codificación para soportar caracteres especiales
            request.setCharacterEncoding("UTF-8");

            // Recuperar los datos del formulario
            String dni = request.getParameter("dni");
            String nombre = request.getParameter("nombre");
            String apellidoPaterno = request.getParameter("apellidoPaterno");
            String apellidoMaterno = request.getParameter("apellidoMaterno");
            String celular = request.getParameter("celular");
            String correoElectronico = request.getParameter("correoElectronico");
            String clave = request.getParameter("clave");
            String perfilIdStr = request.getParameter("perfil");

            // **[MODIFICACIÓN 1]**
            if (nombre != null) nombre = nombre.toUpperCase();  // Nombre a mayúsculas
            if (apellidoPaterno != null) apellidoPaterno = apellidoPaterno.toUpperCase();  // Apellido Paterno a mayúsculas
            if (apellidoMaterno != null) apellidoMaterno = apellidoMaterno.toUpperCase();
            
            
            // Validación de campos obligatorios
            if (dni == null || dni.trim().isEmpty()
                    || nombre == null || nombre.trim().isEmpty()
                    || apellidoPaterno == null || apellidoPaterno.trim().isEmpty()
                    || correoElectronico == null || correoElectronico.trim().isEmpty()
                    || clave == null || clave.trim().isEmpty()
                    || perfilIdStr == null || perfilIdStr.trim().isEmpty()) {

                // **[MODIFICACIÓN 2]**: Establecer mensaje de error en el request
                request.setAttribute("mensaje", "Todos los campos obligatorios deben ser completados.");
                request.setAttribute("tipo", "error"); // Tipo de mensaje (error)

                // Redirigir a index.jsp para mostrar el mensaje en el modal
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }

            // Parsear el ID del perfil
            int perfilId = Integer.parseInt(perfilIdStr);

            // Encriptar la contraseña usando bcrypt
            String hashedClave = BCrypt.hashpw(clave, BCrypt.gensalt());

            // Crear objeto Usuario y asignar los valores
            Usuario usuario = new Usuario();
            usuario.setDni(dni);
            usuario.setNombres(nombre);
            usuario.setApellidoPaterno(apellidoPaterno);
            usuario.setApellidoMaterno(apellidoMaterno);
            usuario.setCelular(celular);
            usuario.setCorreoElectronico(correoElectronico);
            usuario.setClave(hashedClave); // Guardar la clave encriptada
            usuario.setEstadoRegistro(true);

            // Asignar el perfil seleccionado
            usuario.setPerfiles(List.of(perfilId));

            // Registrar usuario en la base de datos
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            boolean registrado = usuarioDAO.registrarUsuario(usuario);

            if (registrado) {
                // **[MODIFICACIÓN 3]**: Enviar mensaje de éxito al request
                request.setAttribute("mensaje", "¡Usuario registrado exitosamente!");
                request.setAttribute("tipo", "success"); // Tipo de mensaje (éxito)
            } else {
                // **[MODIFICACIÓN 4]**: Enviar mensaje de error al request
                request.setAttribute("mensaje", "Error al registrar el usuario.");
                request.setAttribute("tipo", "error");
            }

            // **[MODIFICACIÓN 5]**: Redirigir a index.jsp para mostrar el mensaje en el modal
            request.getRequestDispatcher("index.jsp").forward(request, response);

        } catch (Exception e) {
            // **[MODIFICACIÓN 6]**: Captura de excepciones y envío de mensaje de error
            request.setAttribute("mensaje", "Error: " + e.getMessage());
            request.setAttribute("tipo", "error");

            // Redirigir a index.jsp con el mensaje de error
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
