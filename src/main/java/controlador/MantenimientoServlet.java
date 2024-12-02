package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import modelo.Conexion;

@WebServlet("/MantenimientoServlet")
public class MantenimientoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = Conexion.getConnection();


            if (accion != null) {
                switch (accion) {
                    case "registrarUsuario": {
                        // Lógica para registrar un nuevo usuario
                        String dni = request.getParameter("dni");
                        String nombres = request.getParameter("nombres");
                        String apellidoPaterno = request.getParameter("apellidoPaterno");
                        String apellidoMaterno = request.getParameter("apellidoMaterno");
                        String correo = request.getParameter("correo");
                        int perfil = Integer.parseInt(request.getParameter("perfil"));
                        
                        //Para pasar a mayúsculas
                        nombres= nombres.toUpperCase();
                        apellidoPaterno = apellidoPaterno.toUpperCase();
                        apellidoMaterno = apellidoMaterno.toUpperCase();
                        correo = correo.toUpperCase();
                        
                        
                        String query = "INSERT INTO Usuario (DNI, Nombres, ApellidoPaterno, ApellidoMaterno, CorreoElectronico, Clave, FechaCreacion, EstadoRegistro) "
                                     + "VALUES (?, ?, ?, ?, ?, ?, NOW(), 1)";
                        ps = con.prepareStatement(query);
                        ps.setString(1, dni);
                        ps.setString(2, nombres);
                        ps.setString(3, apellidoPaterno);
                        ps.setString(4, apellidoMaterno);
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

                    case "registrarPerfil": {
                        // Lógica para registrar un nuevo perfil
                        String nombrePerfil = request.getParameter("nombrePerfil");
                        String descripcionPerfil = request.getParameter("descripcionPerfil");
                        
                        nombrePerfil = nombrePerfil.toUpperCase();
                        descripcionPerfil = descripcionPerfil.toUpperCase();
                        
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

                        nombrePerfil = nombrePerfil.toUpperCase();
                        descripcionPerfil = descripcionPerfil.toUpperCase();
                        
                        String query = "UPDATE Perfiles SET Nombre=?, Descripcion=? WHERE IdPerfil=?";
                        ps = con.prepareStatement(query);
                        ps.setString(1, nombrePerfil);
                        ps.setString(2, descripcionPerfil);
                        ps.setInt(3, idPerfil);
                        ps.executeUpdate();

                        response.sendRedirect("mantenimiento.jsp?success=perfilEditado");
                        break;
                    }
                    
                    case "eliminarPerfil": {
                        // Lógica para eliminar un perfil académico
                        int idPerfil = Integer.parseInt(request.getParameter("idPerfil"));
                        String query = "DELETE FROM perfiles WHERE IdPerfil = ?";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, idPerfil);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=perfilEliminado");
                        break;
                    }

                    case "editarUsuario": {
                        int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
                        String dni = request.getParameter("dni");
                        String nombres = request.getParameter("nombres");
                        String apellidoPaterno = request.getParameter("apellidoPaterno");
                        String apellidoMaterno = request.getParameter("apellidoMaterno");
                        String correo = request.getParameter("correo");
                        int perfil = Integer.parseInt(request.getParameter("perfil"));
                        
                        //MAYÚSCULAS 
                        nombres= nombres.toUpperCase();
                        apellidoPaterno = apellidoPaterno.toUpperCase();
                        apellidoMaterno = apellidoMaterno.toUpperCase();
                        correo = correo.toUpperCase();
                        
                        
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
                    case "registrarGrado": {
                        // Lógica para registrar un nuevo grado académico
                        String nombreGrado = request.getParameter("nombreGrado");
                        
                        //MAYÚSCULAS 
                        nombreGrado = nombreGrado.toUpperCase();
                        
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
                        
                        //MAYÚSCULAS
                        nombreGrado = nombreGrado.toUpperCase();
                        
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
                    
                     case "registrarCategoria": {
                        String nombreCategoria = request.getParameter("nombreCategoria");
                        
                        //Mayus
                        nombreCategoria = nombreCategoria.toUpperCase();
                        
                        
                        String query = "INSERT INTO CategoriaCurso (Nombre, EstadoRegistro) VALUES (?, 1)";
                        ps = con.prepareStatement(query);
                        ps.setString(1, nombreCategoria);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=categoriaRegistrada");
                        break;
                    }

                    case "editarCategoria": {
                        // Lógica para editar una categoría existente
                        int idCategoria = Integer.parseInt(request.getParameter("idCategoria"));
                        String nombreCategoria = request.getParameter("nombreCategoria");
                        
                        //MAYUS
                        nombreCategoria = nombreCategoria.toUpperCase();
                        
                        String query = "UPDATE CategoriaCurso SET Nombre=? WHERE IdCategoria=?";
                        ps = con.prepareStatement(query);
                        ps.setString(1, nombreCategoria);
                        ps.setInt(2, idCategoria);
                        ps.executeUpdate();

                        response.sendRedirect("mantenimiento.jsp?success=categoriaEditada");
                        break;
                    }


                    case "eliminarCategoria": {
                        int idCategoria = Integer.parseInt(request.getParameter("idCategoria"));
                        String query = "DELETE FROM CategoriaCurso WHERE IdCategoria=?";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, idCategoria);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=categoriaEliminada");
                        break;
                    }
                    // CRUD DuracionCurso
                    case "registrarDuracion": {
                        String nombreDuracion = request.getParameter("nombreDuracion");
                        
                        nombreDuracion= nombreDuracion.toUpperCase();
                                
                        String query = "INSERT INTO DuracionCurso (Nombre, EstadoRegistro) VALUES (?, 1)";
                        ps = con.prepareStatement(query);
                        ps.setString(1, nombreDuracion);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=duracionRegistrada");
                        break;
                    }

                    case "editarDuracion": {
                        int idDuracion = Integer.parseInt(request.getParameter("idDuracion"));
                        String nombreDuracion = request.getParameter("nombreDuracion");
                        
                        nombreDuracion= nombreDuracion.toUpperCase();

                        String query = "UPDATE DuracionCurso SET Nombre=? WHERE IdDuracion=?";
                        ps = con.prepareStatement(query);
                        ps.setString(1, nombreDuracion);
                        ps.setInt(2, idDuracion);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=duracionEditada");
                        break;
                    }

                    case "eliminarDuracion": {
                        int idDuracion = Integer.parseInt(request.getParameter("idDuracion"));
                        String query = "DELETE FROM DuracionCurso WHERE IdDuracion=?";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, idDuracion);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=duracionEliminada");
                        break;
                    }

                    // NUEVO CRUD PARA IDIOMA CURSO
                    case "registrarIdioma": {
                        String nombreIdioma = request.getParameter("nombreIdioma");
                        
                        nombreIdioma = nombreIdioma.toUpperCase();
                        
                        String query = "INSERT INTO IdiomaCurso (Nombre, EstadoRegistro) VALUES (?, 1)";
                        ps = con.prepareStatement(query);
                        ps.setString(1, nombreIdioma);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=idiomaRegistrado");
                        break;
                    }

                    case "editarIdioma": {
                        int idIdioma = Integer.parseInt(request.getParameter("idIdioma"));
                        String nombreIdioma = request.getParameter("nombreIdioma");
                        
                        nombreIdioma = nombreIdioma.toUpperCase();
                        
                        String query = "UPDATE IdiomaCurso SET Nombre=? WHERE IdIdioma=?";
                        ps = con.prepareStatement(query);
                        ps.setString(1, nombreIdioma);
                        ps.setInt(2, idIdioma);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=idiomaEditado");
                        break;
                    }

                    case "eliminarIdioma": {
                        int idIdioma = Integer.parseInt(request.getParameter("idIdioma"));
                        String query = "UPDATE IdiomaCurso SET EstadoRegistro=0 WHERE IdIdioma=?";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, idIdioma);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=idiomaEliminado");
                        break;
                    }

                    // NUEVO CRUD PARA RANGO EDADES CURSO
                    case "registrarRango": {
                        String descripcionRango = request.getParameter("descripcionRango");
                        
                        descripcionRango = descripcionRango.toUpperCase();
                        
                        String query = "INSERT INTO RangoEdadesCurso (Descripcion, EstadoRegistro) VALUES (?, 1)";
                        ps = con.prepareStatement(query);
                        ps.setString(1, descripcionRango);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=rangoRegistrado");
                        break;
                    }

                    case "editarRango": {
                        int idRango = Integer.parseInt(request.getParameter("idRango"));
                        String descripcionRango = request.getParameter("descripcionRango");
                        
                        descripcionRango = descripcionRango.toUpperCase();
                        
                        String query = "UPDATE RangoEdadesCurso SET Descripcion=? WHERE IdRango=?";
                        ps = con.prepareStatement(query);
                        ps.setString(1, descripcionRango);
                        ps.setInt(2, idRango);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=rangoEditado");
                        break;
                    }

                    case "eliminarRango": {
                        int idRango = Integer.parseInt(request.getParameter("idRango"));
                        String query = "UPDATE RangoEdadesCurso SET EstadoRegistro=0 WHERE IdRango=?";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, idRango);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=rangoEliminado");
                        break;
                    }
                    
                    case "editarCurso":{
                        // Lógica para editar un curso existente
                        int idCurso = Integer.parseInt(request.getParameter("idCurso"));
                        String nombreCurso = request.getParameter("nombreCurso");
                        int capacidad = Integer.parseInt(request.getParameter("capacidad"));
                        String fechaInicio = request.getParameter("fechaInicio");
                        String fechaFin = request.getParameter("fechaFin");
                        double precio = Double.parseDouble(request.getParameter("precio"));
                        int categoria = Integer.parseInt(request.getParameter("categoria"));
                        int duracion = Integer.parseInt(request.getParameter("duracion"));
                        int idioma = Integer.parseInt(request.getParameter("idioma"));
                        int rango = Integer.parseInt(request.getParameter("rango"));
                        
                        nombreCurso = nombreCurso.toUpperCase();
                        

                        String updateQuery = "UPDATE Curso SET Nombre = ?, Capacidad = ?, FechaInicio = ?, FechaFin = ?, Precio = ?, " +
                                             "IdCategoria = ?, IdDuracion = ?, IdIdioma = ?, IdRango = ? WHERE IdCurso = ?";
                        ps = con.prepareStatement(updateQuery);
                        ps.setString(1, nombreCurso);
                        ps.setInt(2, capacidad);
                        ps.setString(3, fechaInicio);
                        ps.setString(4, fechaFin);
                        ps.setDouble(5, precio);
                        ps.setInt(6, categoria);
                        ps.setInt(7, duracion);
                        ps.setInt(8, idioma);
                        ps.setInt(9, rango);
                        ps.setInt(10, idCurso);

                        // Ejecutar la actualización
                        int rowsUpdated = ps.executeUpdate();

                        // Redireccionar dependiendo del resultado
                        if (rowsUpdated > 0) {
                            response.sendRedirect("mantenimiento.jsp?success=cursoEditado");
                        } else {
                            response.sendRedirect("mantenimiento.jsp?error=cursoNoEditado");
                        }
                        break;
                }
                    
             
                    case "registrarCurso": {
                        // Obtener parámetros del formulario
                        String nombreCurso = request.getParameter("nombreCurso");
                        int capacidad = Integer.parseInt(request.getParameter("capacidad"));
                        String fechaInicio = request.getParameter("fechaInicio");
                        String fechaFin = request.getParameter("fechaFin");
                        double precio = Double.parseDouble(request.getParameter("precio"));
                        int idCategoria = Integer.parseInt(request.getParameter("categoria"));
                        int idDuracion = Integer.parseInt(request.getParameter("duracion"));
                        int idIdioma = Integer.parseInt(request.getParameter("idioma"));
                        int idRango = Integer.parseInt(request.getParameter("rango"));
                        
                        nombreCurso = nombreCurso.toUpperCase();
                      
                        String query = "INSERT INTO Curso (Nombre, Capacidad, FechaRegistro, FechaInicio, FechaFin, Precio, IdCategoria, IdDuracion, IdIdioma, IdRango, EstadoRegistro) "
                                     + "VALUES (?, ?, NOW(), ?, ?, ?, ?, ?, ?, ?, 1)";
                        ps = con.prepareStatement(query);
                        ps.setString(1, nombreCurso);
                        ps.setInt(2, capacidad);
                        ps.setString(3, fechaInicio);
                        ps.setString(4, fechaFin);
                        ps.setDouble(5, precio);
                        ps.setInt(6, idCategoria);
                        ps.setInt(7, idDuracion);
                        ps.setInt(8, idIdioma);
                        ps.setInt(9, idRango);

                        // Ejecutar la inserción
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=cursoRegistrado");
                        break;
                    }
                    case "eliminarCurso": {
                        int idCurso = Integer.parseInt(request.getParameter("idCurso"));

                        // Eliminar las relaciones en la tabla intermedia Curso_Docentes
                        //modificaciones a update
                        String query = "UPDATE Curso_Docente SET EstadoRegistro=0 WHERE IdCurso = ?";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, idCurso);
                        ps.executeUpdate();

                        // Ahora eliminar el curso
                        query = "UPDATE Curso SET EstadoRegistro=0 WHERE IdCurso = ?";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, idCurso);
                        ps.executeUpdate();

                        response.sendRedirect("mantenimiento.jsp?success=cursoEliminado");
                        break;
                    }
                    
case "registrarDocente": {
    // Obtener parámetros del formulario para registrar un nuevo docente
    int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
    int idGradoAcademico = Integer.parseInt(request.getParameter("idGradoAcademico"));
    String descripcion = request.getParameter("descripcion");
 
    // Obtener el nombre y apellido concatenado del usuario seleccionado
    String nombresConcatenados = "";
    try {
        String queryUsuario = "SELECT Nombres, ApellidoPaterno FROM Usuario WHERE IdUsuario = ?";
        ps = con.prepareStatement(queryUsuario);
        ps.setInt(1, idUsuario);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            nombresConcatenados = rs.getString("Nombres") + " " + rs.getString("ApellidoPaterno");
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("mantenimiento.jsp?error=errorObteniendoUsuario");
        break;
    }
 
    // Consulta para insertar el nuevo docente con el nombre concatenado
    String query = "INSERT INTO Docente (IdUsuario, IdGradoAcademico, Descripcion, Nombres) VALUES (?, ?, ?, ?)";
    ps = con.prepareStatement(query);
    ps.setInt(1, idUsuario);
    ps.setInt(2, idGradoAcademico);
    ps.setString(3, descripcion);
    ps.setString(4, nombresConcatenados);
 
    // Ejecutar la inserción
    ps.executeUpdate();
    response.sendRedirect("mantenimiento.jsp?success=docenteRegistrado");
    break;
}
 
 
case "editarDocente": {
    // Obtener parámetros del formulario para editar un docente existente
    int idDocente = Integer.parseInt(request.getParameter("idDocente"));
    int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
    int idGradoAcademico = Integer.parseInt(request.getParameter("idGradoAcademico"));
    String descripcion = request.getParameter("descripcion");
 
    // Obtener el nombre y apellido concatenado del usuario seleccionado si el idUsuario ha cambiado
    String nombresConcatenados = "";
    try {
        String queryUsuario = "SELECT Nombres, ApellidoPaterno FROM Usuario WHERE IdUsuario = ?";
        ps = con.prepareStatement(queryUsuario);
        ps.setInt(1, idUsuario);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            nombresConcatenados = rs.getString("Nombres") + " " + rs.getString("ApellidoPaterno");
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("mantenimiento.jsp?error=errorObteniendoUsuario");
        break;
    }
 
    // Consulta para actualizar el docente existente con el nombre concatenado
    String query = "UPDATE Docente SET IdUsuario = ?, IdGradoAcademico = ?, Descripcion = ?, Nombres = ? WHERE IdDocente = ?";
    ps = con.prepareStatement(query);
    ps.setInt(1, idUsuario);
    ps.setInt(2, idGradoAcademico);
    ps.setString(3, descripcion);
    ps.setString(4, nombresConcatenados);
    ps.setInt(5, idDocente);
 
    // Ejecutar la actualización
    int rowsUpdated = ps.executeUpdate();
 
    // Redireccionar dependiendo del resultado
    if (rowsUpdated > 0) {
        response.sendRedirect("mantenimiento.jsp?success=docenteEditado");
    } else {
        response.sendRedirect("mantenimiento.jsp?error=docenteNoEditado");
    }
    break;
}

                    case "eliminarDocente": {
                        // Obtener el ID del docente a eliminar
                        int idDocente = Integer.parseInt(request.getParameter("idDocente"));

                        // Consulta para eliminar el docente
                        String query = "DELETE FROM Docente WHERE IdDocente = ?";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, idDocente);

                        // Ejecutar la eliminación
                        int rowsDeleted = ps.executeUpdate();

                        // Redireccionar dependiendo del resultado
                        if (rowsDeleted > 0) {
                            response.sendRedirect("mantenimiento.jsp?success=docenteEliminado");
                        } else {
                            response.sendRedirect("mantenimiento.jsp?error=docenteNoEliminado");
                        }
                        break;
                    }
                    case "asignarDocenteCurso": {
                        // Obtener los parámetros del formulario de asignación
                        int idDocente = Integer.parseInt(request.getParameter("idDocente"));
                        int idCurso = Integer.parseInt(request.getParameter("idCurso"));

                        try {
                            // Verificar si la asignación ya existe
                            String checkQuery = "SELECT COUNT(*) FROM Curso_Docente WHERE IdCurso = ? AND IdDocente = ?";
                            ps = con.prepareStatement(checkQuery);
                            ps.setInt(1, idCurso);
                            ps.setInt(2, idDocente);
                            ResultSet rs = ps.executeQuery();
                            rs.next();
                            int count = rs.getInt(1);

                            if (count == 0) {
                                // Insertar la nueva asignación si no existe
                                String insertQuery = "INSERT INTO Curso_Docente (IdCurso, IdDocente) VALUES (?, ?)";
                                ps = con.prepareStatement(insertQuery);
                                ps.setInt(1, idCurso);
                                ps.setInt(2, idDocente);
                                ps.executeUpdate();
                                response.sendRedirect("mantenimiento.jsp?success=docenteAsignado");
                            } else {
                                // Si la asignación ya existe, redirigir con mensaje de advertencia
                                response.sendRedirect("mantenimiento.jsp?error=asignacionYaExiste");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            response.sendRedirect("mantenimiento.jsp?error=errorAsignacionDocente");
                        }
                        break;
                    }
                    case "registrarTipoSesion": {
                        String tipoSesion = request.getParameter("tipoSesion");
                        String query = "INSERT INTO tiposesion (TipoSesion, EstadoRegistro) VALUES (?, 1)";
                        ps = con.prepareStatement(query);
                        ps.setString(1, tipoSesion);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=tipoSesionRegistrado");
                        break;
                    }

                    case "editarTipoSesion": {
                        int idTipoSesion = Integer.parseInt(request.getParameter("idTipoSesion"));
                        String tipoSesion = request.getParameter("tipoSesion");
                        String query = "UPDATE tiposesion SET TipoSesion = ? WHERE IdTipoSesion = ?";
                        ps = con.prepareStatement(query);
                        ps.setString(1, tipoSesion);
                        ps.setInt(2, idTipoSesion);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=tipoSesionEditado");
                        break;
                    }

                    case "eliminarTipoSesion": {
                        int idTipoSesion = Integer.parseInt(request.getParameter("idTipoSesion"));
                        String query = "DELETE FROM tiposesion WHERE IdTipoSesion = ?";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, idTipoSesion);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=tipoSesionEliminado");
                        break;
                    }

                    case "registrarSesion": {
                        // Obtener los parámetros del formulario
                        int numeroSesion = Integer.parseInt(request.getParameter("numeroSesion"));
                        String nombreSesion = request.getParameter("nombreSesion");
                        int tipoSesion = Integer.parseInt(request.getParameter("tipoSesion"));
                        int cursoSesion = Integer.parseInt(request.getParameter("cursoSesion"));
                        String fechaSesion = request.getParameter("fechaSesion");
                        
                        //Validación para evitar que se registre hasta antes de 5 días
                        LocalDate fechaIngresada = LocalDate.parse(fechaSesion, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        LocalDate fechaLimite = LocalDate.now().minus(5, ChronoUnit.DAYS);

                        
                        if (fechaIngresada.isBefore(fechaLimite)) {
                            response.sendRedirect("mantenimiento.jsp?error=fechaInvalida");
                            return;
                        }
                        // Consulta SQL para insertar la nueva sesión
                        String query = "INSERT INTO Sesion (NumeroSesion, NombreSesion, IdTipoSesion, IdCurso, FechaSesion, EstadoRegistro) VALUES (?, ?, ?, ?, ?, 1)";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, numeroSesion);
                        ps.setString(2, nombreSesion);
                        ps.setInt(3, tipoSesion);
                        ps.setInt(4, cursoSesion); // Relación con el curso
                        ps.setString(5, fechaSesion);

                        // Ejecutar la inserción
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=sesionRegistrada");
                        break;
                    }


                case "editarSesion": {
                    // Obtener parámetros del formulario
                    int idSesion = Integer.parseInt(request.getParameter("idSesion"));
                    int numeroSesion = Integer.parseInt(request.getParameter("numeroSesion"));
                    String nombreSesion = request.getParameter("nombreSesion");
                    int tipoSesionId = Integer.parseInt(request.getParameter("tipoSesion"));
                    String fechaSesion = request.getParameter("fechaSesion");

                    //Validación para evitar que se registre hasta antes de 5 días
                    LocalDate fechaIngresada = LocalDate.parse(fechaSesion, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                    LocalDate fechaLimite = LocalDate.now().minus(5, ChronoUnit.DAYS);


                    if (fechaIngresada.isBefore(fechaLimite)) {
                        response.sendRedirect("mantenimiento.jsp?error=fechaInvalida");
                        return;
                    }
                    
                    // Consulta SQL para actualizar la sesión
                    String query = "UPDATE sesion SET NumeroSesion = ?, NombreSesion = ?, IdTipoSesion = ?, FechaSesion = ? WHERE IdSesion = ?";
                    ps = con.prepareStatement(query);
                    ps.setInt(1, numeroSesion);
                    ps.setString(2, nombreSesion);
                    ps.setInt(3, tipoSesionId);
                    ps.setString(4, fechaSesion);
                    ps.setInt(5, idSesion);

                    // Ejecutar la actualización y redireccionar con mensaje de éxito
                    ps.executeUpdate();
                    response.sendRedirect("mantenimiento.jsp?success=sesionEditada");
                    break;
                }


                    case "eliminarSesion": {
                        int idSesion = Integer.parseInt(request.getParameter("idSesion"));
                        String query = "DELETE FROM sesion WHERE IdSesion = ?";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, idSesion);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=sesionEliminada");
                        break;
                    }

                    case "registrarEstadoAsistencia": {
                        String tipoAsistencia = request.getParameter("tipoAsistencia");

                        String query = "INSERT INTO EstadosAsistencia (TipoAsistencia, EstadoRegistro) VALUES (?, 1)";
                        ps = con.prepareStatement(query);
                        ps.setString(1, tipoAsistencia);

                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=estadoAsistenciaRegistrado");
                        break;
                    }

                    case "editarEstadoAsistencia": {
                        int idEstadoAsistencia = Integer.parseInt(request.getParameter("idEstadoAsistencia"));
                        String tipoAsistencia = request.getParameter("tipoAsistencia");

                        String query = "UPDATE EstadosAsistencia SET TipoAsistencia = ? WHERE IdEstadoAsistencia = ?";
                        ps = con.prepareStatement(query);
                        ps.setString(1, tipoAsistencia);
                        ps.setInt(2, idEstadoAsistencia);

                        int rowsUpdated = ps.executeUpdate();
                        if (rowsUpdated > 0) {
                            response.sendRedirect("mantenimiento.jsp?success=estadoAsistenciaEditado");
                        } else {
                            response.sendRedirect("mantenimiento.jsp?error=estadoAsistenciaNoEditado");
                        }
                        break;
                    }

                    case "eliminarEstadoAsistencia": {
                        int idEstadoAsistencia = Integer.parseInt(request.getParameter("idEstadoAsistencia"));

                        String query = "UPDATE EstadosAsistencia SET EstadoRegistro = 0 WHERE IdEstadoAsistencia = ?";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, idEstadoAsistencia);

                        int rowsDeleted = ps.executeUpdate();
                        if (rowsDeleted > 0) {
                            response.sendRedirect("mantenimiento.jsp?success=estadoAsistenciaEliminado");
                        } else {
                            response.sendRedirect("mantenimiento.jsp?error=estadoAsistenciaNoEliminado");
                        }
                        break;
                    }
                    // REDES SOCIALES CRUD
                    case "registrarRedSocial": {
                        // Lógica para registrar una nueva red social
                        String redSocial = request.getParameter("redSocial");

                        String query = "INSERT INTO RedesSociales (RedSocial, EstadoRegistro) VALUES (?, 1)";
                        ps = con.prepareStatement(query);
                        ps.setString(1, redSocial);
                        ps.executeUpdate();

                        response.sendRedirect("mantenimiento.jsp?success=redSocialRegistrada");
                        break;
                    }

                    case "editarRedSocial": {
                        // Lógica para editar una red social existente
                        int idRedSocial = Integer.parseInt(request.getParameter("idRedesSociales"));
                        String redSocial = request.getParameter("redSocial");

                        String query = "UPDATE RedesSociales SET RedSocial = ? WHERE IdRedesSociales = ?";
                        ps = con.prepareStatement(query);
                        ps.setString(1, redSocial);
                        ps.setInt(2, idRedSocial);
                        ps.executeUpdate();

                        response.sendRedirect("mantenimiento.jsp?success=redSocialEditada");
                        break;
                    }

                    case "eliminarRedSocial": {
                        // Lógica para eliminar (desactivar) una red social
                        int idRedSocial = Integer.parseInt(request.getParameter("idRedesSociales"));

                        String query = "UPDATE RedesSociales SET EstadoRegistro = 0 WHERE IdRedesSociales = ?";
                        ps = con.prepareStatement(query);
                        ps.setInt(1, idRedSocial);
                        ps.executeUpdate();

                        response.sendRedirect("mantenimiento.jsp?success=redSocialEliminada");
                        break;
                    }
                    
                    // Alumnos y Curso Alumnos
                    case "registrarMatricula": {
                        String dni = request.getParameter("dni");
                        int idCurso = Integer.parseInt(request.getParameter("idCurso"));
                        String consulta = "INSERT INTO Matriculas (DNI, IdCurso, EstadoRegistro) VALUES (?, ?, 1)";
                        ps = con.prepareStatement(consulta);
                        ps.setString(1, dni);
                        ps.setInt(2, idCurso);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=matriculaRegistrada");
                        break;
                    }
                    case "editarMatricula": {
                        int idMatricula = Integer.parseInt(request.getParameter("idMatricula"));
                        String dni = request.getParameter("dni");
                        int idCurso = Integer.parseInt(request.getParameter("idCurso"));
                        String consulta = "UPDATE Matriculas SET DNI=?, IdCurso=? WHERE IdMatricula=?";
                        ps = con.prepareStatement(consulta);
                        ps.setString(1, dni);
                        ps.setInt(2, idCurso);
                        ps.setInt(3, idMatricula);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=matriculaEditada");
                        break;
                    }
                    case "eliminarMatricula": {
                        int idMatricula = Integer.parseInt(request.getParameter("idMatricula"));
                        String consulta = "DELETE FROM Matriculas WHERE IdMatricula=?";
                        ps = con.prepareStatement(consulta);
                        ps.setInt(1, idMatricula);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=matriculaEliminada");
                        break;
                    }
                    case "registrarAlumno": {
                        String dni = request.getParameter("dni");
                        String nombres = request.getParameter("nombres");
                        String apellidoPaterno = request.getParameter("apellidoPaterno");
                        String apellidoMaterno = request.getParameter("apellidoMaterno");
                        String correoElectronico = request.getParameter("correoElectronico");
                        String celular = request.getParameter("celular");
                        int idUsuario = Integer.parseInt(request.getParameter("idUsuario")); // Captura el IdUsuario

                        String consulta = "INSERT INTO Alumno (DNI, Nombres, ApellidoPaterno, ApellidoMaterno, CorreoElectronico, Celular, IdUsuario) VALUES (?, ?, ?, ?, ?, ?, ?)";
                        ps = con.prepareStatement(consulta);
                        ps.setString(1, dni);
                        ps.setString(2, nombres);
                        ps.setString(3, apellidoPaterno);
                        ps.setString(4, apellidoMaterno);
                        ps.setString(5, correoElectronico);
                        ps.setString(6, celular);
             
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=alumnoRegistrado");
                        break;
                    }
                    case "editarAlumno": {
                        int idAlumno = Integer.parseInt(request.getParameter("idAlumno"));
                        String dni = request.getParameter("dni");
                        String nombres = request.getParameter("nombres");
                        String apellidoPaterno = request.getParameter("apellidoPaterno");
                        String apellidoMaterno = request.getParameter("apellidoMaterno");
                        String correoElectronico = request.getParameter("correoElectronico");
                        String celular = request.getParameter("celular");
                        String consulta = "UPDATE Alumno SET DNI=?, Nombres=?, ApellidoPaterno=?, ApellidoMaterno=?, CorreoElectronico=?, Celular=? WHERE IdAlumno=?";
                        ps = con.prepareStatement(consulta);
                        ps.setString(1, dni);
                        ps.setString(2, nombres);
                        ps.setString(3, apellidoPaterno);
                        ps.setString(4, apellidoMaterno);
                        ps.setString(5, correoElectronico);
                        ps.setString(6, celular);
                        ps.setInt(7, idAlumno);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=alumnoEditado");
                        break;
                    }
                    case "eliminarAlumno": {
                        int idAlumno = Integer.parseInt(request.getParameter("idAlumno"));
                        String consulta = "DELETE FROM Alumno WHERE IdAlumno=?";
                        ps = con.prepareStatement(consulta);
                        ps.setInt(1, idAlumno);
                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=alumnoEliminado");
                        break;
                    }

               
                    default:
                        response.sendRedirect("error.jsp?msg=Acción no válida");
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?msg=" + e.getMessage());
        } finally {
            // Cerrar los recursos
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
