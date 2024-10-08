
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
import modelo.Conexion;

@WebServlet("/MantenimientoServlet")
public class MantenimientoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        try {
            Connection con = Conexion.getConnection();
            PreparedStatement ps;

            if (null != accion) switch (accion) {
                case "registrarUsuario":{
                    // Lógica para registrar un nuevo usuario
                    String dni = request.getParameter("dni");
                    String nombres = request.getParameter("nombres");
                    String apellidoPaterno = request.getParameter("apellidoPaterno");
                    String correo = request.getParameter("correo");
                    int perfil = Integer.parseInt(request.getParameter("perfil"));
                    String query = "INSERT INTO Usuario (DNI, Nombres, ApellidoPaterno, CorreoElectronico, Clave, FechaCreacion, EstadoRegistro) "
                            + "VALUES (?, ?, ?, ?, ?, NOW(), 1)";
                    ps = con.prepareStatement(query);
                    ps.setString(1, dni);
                    ps.setString(2, nombres);
                    ps.setString(3, apellidoPaterno);
                    ps.setString(4, correo);
                    ps.setString(5, "clave_generica");  // Puedes generar una contraseña aleatoria aquí
                    ps.executeUpdate();
                    // Asignar el perfil al usuario en la tabla intermedia
                    query = "INSERT INTO Usuario_Perfiles (IdUsuario, IdPerfil, EstadoRegistro) VALUES (LAST_INSERT_ID(), ?, 1)";
                    ps = con.prepareStatement(query);
                    ps.setInt(1, perfil);
                    ps.executeUpdate();
                    response.sendRedirect("mantenimiento.jsp?success=usuarioRegistrado");
                        break;
                    }
                case "registrarPerfil":{
                    // Lógica para registrar un nuevo perfil
                    String nombrePerfil = request.getParameter("nombrePerfil");
                    String descripcionPerfil = request.getParameter("descripcionPerfil");
                    String query = "INSERT INTO Perfiles (Nombre, Descripcion, EstadoRegistro) VALUES (?, ?, 1)";
                    ps = con.prepareStatement(query);
                    ps.setString(1, nombrePerfil);
                    ps.setString(2, descripcionPerfil);
                    ps.executeUpdate();
                    response.sendRedirect("mantenimiento.jsp?success=perfilRegistrado");
                        break;
                    }
                case "editarUsuario":{
                    // Editar un usuario existente
                    int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
                    String dni = request.getParameter("dni");
                    String nombres = request.getParameter("nombres");
                    String apellidoPaterno = request.getParameter("apellidoPaterno");
                    String correo = request.getParameter("correo");
                    int perfil = Integer.parseInt(request.getParameter("perfil"));  // Obtener el perfil actualizado
                    // Actualizar los datos del usuario
                    String query = "UPDATE Usuario SET DNI=?, Nombres=?, ApellidoPaterno=?, CorreoElectronico=?, FechaModificacion=NOW() WHERE IdUsuario=?";
                    ps = con.prepareStatement(query);
                    ps.setString(1, dni);
                    ps.setString(2, nombres);
                    ps.setString(3, apellidoPaterno);
                    ps.setString(4, correo);
                    ps.setInt(5, idUsuario);
                    ps.executeUpdate();
                    // Actualizar el perfil del usuario en la tabla Usuario_Perfiles
                    query = "UPDATE Usuario_Perfiles SET IdPerfil=? WHERE IdUsuario=?";
                    ps = con.prepareStatement(query);
                    ps.setInt(1, perfil);  // Actualizar con el nuevo perfil
                    ps.setInt(2, idUsuario);
                    ps.executeUpdate();
                    // Actualizar la sesión si es el usuario actual
                    HttpSession session = request.getSession();
                    Integer idUsuarioSesion = (Integer) session.getAttribute("idUsuario");
                    if (idUsuarioSesion != null && idUsuarioSesion == idUsuario) {
                        session.setAttribute("nombre", nombres);  // Actualiza el nombre en la sesión
                    }       response.sendRedirect("mantenimiento.jsp?success=usuarioEditado");
                        break;
                    }
                case "eliminarUsuario":{
                    // Lógica para eliminar un usuario
                    int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
                    String query = "DELETE FROM Usuario WHERE IdUsuario = ?";
                    ps = con.prepareStatement(query);
                    ps.setInt(1, idUsuario);
                    ps.executeUpdate();
                    response.sendRedirect("mantenimiento.jsp?success=usuarioEliminado");
                        break;
                    }
                default:
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
