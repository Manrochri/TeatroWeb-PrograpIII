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

            // Validación de campos obligatorios
            if (dni == null || dni.trim().isEmpty()
                    || nombre == null || nombre.trim().isEmpty()
                    || apellidoPaterno == null || apellidoPaterno.trim().isEmpty()
                    || correoElectronico == null || correoElectronico.trim().isEmpty()
                    || clave == null || clave.trim().isEmpty()
                    || perfilIdStr == null || perfilIdStr.trim().isEmpty()) {

                // Si hay un error en los campos obligatorios, regresar al formulario
                request.setAttribute("error", "Todos los campos obligatorios deben ser completados.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }

            // Parsear el ID del perfil
            int perfilId = Integer.parseInt(perfilIdStr);

            // Crear objeto Usuario y asignar los valores
            Usuario usuario = new Usuario();
            usuario.setDni(dni);
            usuario.setNombres(nombre);
            usuario.setApellidoPaterno(apellidoPaterno);
            usuario.setApellidoMaterno(apellidoMaterno);
            usuario.setCelular(celular);
            usuario.setCorreoElectronico(correoElectronico);
            usuario.setClave(clave);
            usuario.setEstadoRegistro(true); // Activo

            // Asignar el perfil seleccionado
            usuario.setPerfiles(List.of(perfilId));

            // Registrar usuario en la base de datos
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            boolean registrado = usuarioDAO.registrarUsuario(usuario);

            // Redirigir según el resultado del registro
            if (registrado) {
                response.sendRedirect("registroExitoso.jsp");
            } else {
                request.setAttribute("error", "Error al registrar el usuario.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }

        } catch (Exception e) {
            // Capturar el error y reenviar los detalles a la página JSP para que se muestren
            request.setAttribute("error", "Error: " + e.getMessage());
            e.printStackTrace(); // Imprimir el error en los logs del servidor
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}