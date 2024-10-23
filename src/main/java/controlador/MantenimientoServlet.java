package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
                case "registrarUsuario": {
                        // Para registrar Usuario en la BD
                        String dni = request.getParameter("dni");
                        String nombres = request.getParameter("nombres");
                        String apellidoPaterno = request.getParameter("apellidoPaterno");
                        String apellidoMaterno = request.getParameter("apellidoMaterno"); // Nuevo campo
                        String correo = request.getParameter("correo");
                        int perfil = Integer.parseInt(request.getParameter("perfil"));

                        String query = "INSERT INTO Usuario (DNI, Nombres, ApellidoPaterno, ApellidoMaterno, CorreoElectronico, Clave, FechaCreacion, EstadoRegistro) "
                                     + "VALUES (?, ?, ?, ?, ?, ?, NOW(), 1)";
                        ps = con.prepareStatement(query);
                        ps.setString(1, dni);
                        ps.setString(2, nombres);
                        ps.setString(3, apellidoPaterno);
                        ps.setString(4, apellidoMaterno); // Asignar el valor de ApellidoMaterno
                        ps.setString(5, correo);
                        ps.setString(6, "clave_generica");
                        ps.executeUpdate();

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

                case "editarPerfil": {
                    int idPerfil = Integer.parseInt(request.getParameter("idPerfil"));
                    String nombrePerfil = request.getParameter("nombrePerfil");
                    String descripcionPerfil = request.getParameter("descripcionPerfil");

                    String query = "UPDATE Perfiles SET Nombre=?, Descripcion=? WHERE IdPerfil=?";
                    ps = con.prepareStatement(query);
                    ps.setString(1, nombrePerfil);
                    ps.setString(2, descripcionPerfil);
                    ps.setInt(3, idPerfil);
                    ps.executeUpdate();

                    response.sendRedirect("mantenimiento.jsp?success=perfilEditado");
                    break;
                }
                
                case "editarUsuario": {
                    // Editar un usuario existente
                    int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
                    String dni = request.getParameter("dni");
                    String nombres = request.getParameter("nombres");
                    String apellidoPaterno = request.getParameter("apellidoPaterno");
                    String apellidoMaterno = request.getParameter("apellidoMaterno"); // Nuevo campo
                    String correo = request.getParameter("correo");
                    int perfil = Integer.parseInt(request.getParameter("perfil"));

                    String query = "UPDATE Usuario SET DNI=?, Nombres=?, ApellidoPaterno=?, ApellidoMaterno=?, CorreoElectronico=?, FechaModificacion=NOW() WHERE IdUsuario=?";
                    ps = con.prepareStatement(query);
                    ps.setString(1, dni);
                    ps.setString(2, nombres);
                    ps.setString(3, apellidoPaterno);
                    ps.setString(4, apellidoMaterno);
                    ps.setString(5, correo);
                    ps.setInt(6, idUsuario);
                    ps.executeUpdate();

                    query = "UPDATE Usuario_Perfiles SET IdPerfil=? WHERE IdUsuario=?";
                    ps = con.prepareStatement(query);
                    ps.setInt(1, perfil);
                    ps.setInt(2, idUsuario);
                    ps.executeUpdate();

                    response.sendRedirect("mantenimiento.jsp?success=usuarioEditado");
                    break;
                }


                case "eliminarUsuario": {
                    int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));

                    String query = "DELETE FROM Usuario_Perfiles WHERE IdUsuario = ?";
                    ps = con.prepareStatement(query);
                    ps.setInt(1, idUsuario);
                    ps.executeUpdate();

                    query = "DELETE FROM Usuario WHERE IdUsuario = ?";
                    ps = con.prepareStatement(query);
                    ps.setInt(1, idUsuario);
                    ps.executeUpdate();

                    response.sendRedirect("mantenimiento.jsp?success=usuarioEliminado");
                    break;
                }

                // NUEVO CRUD PARA GRADOS ACADÉMICOS
                case "registrarGrado": {
                    // Lógica para registrar un nuevo grado académico
                    String nombreGrado = request.getParameter("nombreGrado");
                    String query = "INSERT INTO GradoAcademico (Nombre, EstadoRegistro) VALUES (?, 1)";
                    ps = con.prepareStatement(query);
                    ps.setString(1, nombreGrado);
                    ps.executeUpdate();
                    response.sendRedirect("mantenimiento.jsp?success=gradoRegistrado");
                    break;
                }

                case "editarGrado": {
                    // Lógica para editar un grado académico existente
                    int idGrado = Integer.parseInt(request.getParameter("idGrado"));
                    String nombreGrado = request.getParameter("nombreGrado");
                    String query = "UPDATE GradoAcademico SET Nombre=? WHERE IdGradoAcademico=?";
                    ps = con.prepareStatement(query);
                    ps.setString(1, nombreGrado);
                    ps.setInt(2, idGrado);
                    ps.executeUpdate();
                    response.sendRedirect("mantenimiento.jsp?success=gradoEditado");
                    break;
                }

                case "eliminarGrado": {
                    // Lógica para eliminar un grado académico
                    int idGrado = Integer.parseInt(request.getParameter("idGrado"));
                    String query = "UPDATE GradoAcademico SET EstadoRegistro=0 WHERE IdGradoAcademico=?";
                    ps = con.prepareStatement(query);
                    ps.setInt(1, idGrado);
                    ps.executeUpdate();
                    response.sendRedirect("mantenimiento.jsp?success=gradoEliminado");
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
