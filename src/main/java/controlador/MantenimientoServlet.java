package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import modelo.Conexion;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.ws.rs.Path;
import java.io.FileWriter;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.UUID;
import org.apache.commons.io.FilenameUtils;






@MultipartConfig
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
                        String query = "UPDATE CategoriaCurso SET EstadoRegistro=0 WHERE IdCategoria=?";
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
                    
                    
                    case "registrarCurso": {
                 
                        try {
                            // Configurar el procesamiento de multipart
                            String nombreCurso = "";
                            int capacidad = 0;
                            String fechaInicio = "";
                            String fechaFin = "";
                            double precio = 0.0;
                            int idCategoria = 0;
                            int idDuracion = 0;
                            int idIdioma = 0;
                            int idRango = 0;
                            String imagenURL = null;

                            // Obtener las partes del request
                            for (Part part : request.getParts()) {
                                if (part.getName().equals("imagenCurso") && part.getSize() > 0) {
                                    // Procesar el archivo subido
                                    // Obtener la ruta base desde el contexto
                                     // Obtener la ruta del contexto desplegado
                                        String deployedPath = getServletContext().getRealPath("/");

                                        // Convertir a Path y retroceder dos niveles (de target/TEATROWEB-01 a TEATROWEB)
                                        java.nio.file.Path projectRootPath = Paths.get(deployedPath).getParent().getParent();

                                        // Construir la ruta deseada
                                        java.nio.file.Path desiredPath = projectRootPath.resolve("src/main/webapp/images/cursos");

                                        // Convertir a cadena
                                        String folderPath = desiredPath.toString();

                                    System.out.println("Ruta calculada: " + folderPath);

                                    File uploadDir = new File(folderPath);
                                    if (!uploadDir.exists()) {
                                        uploadDir.mkdirs();
                                    }
                                    
                                    String uniqueFileName = UUID.randomUUID().toString() + "."
                                            + FilenameUtils.getExtension(part.getSubmittedFileName());

                                    String filePath = folderPath + File.separator + uniqueFileName;
                                    part.write(filePath);

                                    

                                    // Guardar la URL relativa para la base de datos
                                    imagenURL = "images/cursos/" + uniqueFileName;
                                } else if (part.getName().equals("nombreCurso")) {
                                    nombreCurso = request.getParameter("nombreCurso").toUpperCase();
                                } else if (part.getName().equals("capacidad")) {
                                    capacidad = Integer.parseInt(request.getParameter("capacidad"));
                                } else if (part.getName().equals("fechaInicio")) {
                                    fechaInicio = request.getParameter("fechaInicio");
                                } else if (part.getName().equals("fechaFin")) {
                                    fechaFin = request.getParameter("fechaFin");
                                } else if (part.getName().equals("precio")) {
                                    precio = Double.parseDouble(request.getParameter("precio"));
                                } else if (part.getName().equals("categoria")) {
                                    idCategoria = Integer.parseInt(request.getParameter("categoria"));
                                } else if (part.getName().equals("duracion")) {
                                    idDuracion = Integer.parseInt(request.getParameter("duracion"));
                                } else if (part.getName().equals("idioma")) {
                                    idIdioma = Integer.parseInt(request.getParameter("idioma"));
                                } else if (part.getName().equals("rango")) {
                                    idRango = Integer.parseInt(request.getParameter("rango"));
                                }
                            }

                            // Query para insertar el curso en la base de datos
                            String query = "INSERT INTO Curso (Nombre, Capacidad, FechaRegistro, FechaInicio, FechaFin, Precio, IdCategoria, IdDuracion, IdIdioma, IdRango, EstadoRegistro, ImagenURL) "
                                    + "VALUES (?, ?, NOW(), ?, ?, ?, ?, ?, ?, ?, 1, ?)";

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
                            ps.setString(10, imagenURL);

                            // Ejecutar la inserción
                            ps.executeUpdate();

                            // Redirigir con un mensaje de éxito
                            response.sendRedirect("mantenimiento.jsp?success=cursoRegistrado");

                        } catch (Exception e) {
                            e.printStackTrace();
                            response.sendRedirect("error.jsp?error=cursoNoRegistrado");
                        }

                        break;
}




                    
case "editarCurso": {
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
    String imagenURL = null;
    
    nombreCurso = nombreCurso.toUpperCase();

    // Variable para almacenar la URL de la imagen anterior
    String imagenAnterior = null;

    // Verificar si se ha subido una nueva imagen
    for (Part part : request.getParts()) {
        if (part.getName().equals("imagenCurso") && part.getSize() > 0) {
            // Procesar el archivo subido
            // Ruta absoluta cambiar
          String deployedPath = getServletContext().getRealPath("/");

          // Convertir a Path y retroceder dos niveles (de target/TEATROWEB-01 a TEATROWEB)
          java.nio.file.Path projectRootPath = Paths.get(deployedPath).getParent().getParent();

          // Construir la ruta deseada
          java.nio.file.Path desiredPath = projectRootPath.resolve("src/main/webapp/images/cursos");

          // Convertir a cadena
          String folderPath = desiredPath.toString();
            System.out.println("Ruta calculada: " + folderPath);

            File uploadDir = new File(folderPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Generar un nombre único para la imagen
            String uniqueFileName = UUID.randomUUID().toString() + "_" + Paths.get(part.getSubmittedFileName()).getFileName().toString();
            String filePath = folderPath + File.separator + uniqueFileName;
            part.write(filePath);

            // Guardar la URL relativa para la base de datos
            imagenURL = "images/cursos/" + uniqueFileName;
        }
    }

    // Si no se sube una nueva imagen, mantener la imagen actual en la base de datos
    if (imagenURL == null) {
        // Obtener la imagen actual desde la base de datos
        String selectQuery = "SELECT ImagenURL FROM Curso WHERE IdCurso = ?";
        ps = con.prepareStatement(selectQuery);
        ps.setInt(1, idCurso);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            imagenAnterior = rs.getString("ImagenURL");
            imagenURL = imagenAnterior; // Si no se sube una nueva imagen, mantener la anterior
        }
    }

    // Si hay una imagen anterior y se está subiendo una nueva, eliminar la imagen anterior
    if (imagenAnterior != null && !imagenAnterior.equals(imagenURL)) {
        // Eliminar la imagen anterior del servidor
        String folderPath = "C:\\Users\\ASUS\\Documents\\Trabajos\\Programacion_aplicada_III\\TEATROWEB\\src\\main\\webapp\\images\\cursos";
        File oldImage = new File(folderPath + File.separator + imagenAnterior.substring(imagenAnterior.lastIndexOf("/") + 1));
        if (oldImage.exists()) {
            oldImage.delete(); // Eliminar el archivo físico de la imagen anterior
        }
    }

    // Actualizar el curso en la base de datos
    String updateQuery = "UPDATE Curso SET Nombre = ?, Capacidad = ?, FechaInicio = ?, FechaFin = ?, Precio = ?, " +
                         "IdCategoria = ?, IdDuracion = ?, IdIdioma = ?, IdRango = ?, ImagenURL = ? WHERE IdCurso = ?";
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
    ps.setString(10, imagenURL); // Establecer la URL de la imagen, ya sea nueva o la actual
    ps.setInt(11, idCurso);

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
                        int idUsuario = Integer.parseInt(request.getParameter("idUsuarioDocente"));
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
                        
                        tipoSesion = tipoSesion.toUpperCase();
                        
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
                        
                        tipoSesion = tipoSesion.toUpperCase();
                        
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
                        
                        nombreSesion = nombreSesion.toUpperCase();
                        
                        
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
                    
                    nombreSesion = nombreSesion.toUpperCase();
                    
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
                        
                        tipoAsistencia= tipoAsistencia.toUpperCase();
                        
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
                        
                        tipoAsistencia= tipoAsistencia.toUpperCase();
                        
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
                        
                        redSocial = redSocial.toUpperCase();
                        

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
                        
                        redSocial = redSocial.toUpperCase();
                        
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
                    case "registrarMatricula1": {
                        try {
                            String idAlumnoStr = request.getParameter("idAlumno");
                            String idCursoStr = request.getParameter("idCurso");
                            String fechaMatricula = request.getParameter("fechaMatricula");

                            if (idAlumnoStr == null || idCursoStr == null || fechaMatricula == null) {
                                request.setAttribute("errorMessage", "Datos inválidos. Por favor, inténtalo nuevamente.");
                                request.getRequestDispatcher("matricula.jsp?idCurso=" + idCursoStr).forward(request, response);
                                return;
                            }

                            int idAlumno = Integer.parseInt(idAlumnoStr);
                            int idCurso = Integer.parseInt(idCursoStr);

                            String consulta = "INSERT INTO Matriculas (IdAlumno, IdCurso, FechaMatricula, EstadoRegistro) VALUES (?, ?, ?, 1)";
                            ps = con.prepareStatement(consulta);
                            ps.setInt(1, idAlumno);
                            ps.setInt(2, idCurso);
                            ps.setDate(3, java.sql.Date.valueOf(fechaMatricula));

                            ps.executeUpdate();

                            request.setAttribute("successMessage", "¡Te has matriculado exitosamente en el curso!");
                            request.getRequestDispatcher("matricula.jsp?idCurso=" + idCursoStr).forward(request, response);

                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                            request.setAttribute("errorMessage", "Error en el formato de los datos enviados.");
                            request.getRequestDispatcher("matricula.jsp?idCurso=" + request.getParameter("idCurso")).forward(request, response);
                        } catch (Exception e) {
                            e.printStackTrace();
                            request.setAttribute("errorMessage", "Ocurrió un error al intentar matricularte. Por favor, inténtalo de nuevo.");
                            request.getRequestDispatcher("matricula.jsp?idCurso=" + request.getParameter("idCurso")).forward(request, response);
                        } finally {
                            if (ps != null) try {
                                ps.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                            if (con != null) try {
                                con.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                        break;
                            }
                    
                    // Alumnos y Curso Alumnos
                    case "registrarMatricula": {
                        try {
                            int idAlumno = Integer.parseInt(request.getParameter("idAlumno"));
                            int idCurso = Integer.parseInt(request.getParameter("idCurso"));
                            String fechaMatricula = request.getParameter("fechaMatricula");

                            String consulta = "INSERT INTO Matriculas (IdAlumno, IdCurso, FechaMatricula, EstadoRegistro) VALUES (?, ?, ?, 1)";
                            ps = con.prepareStatement(consulta);
                            ps.setInt(1, idAlumno);
                            ps.setInt(2, idCurso);
                            ps.setDate(3, java.sql.Date.valueOf(fechaMatricula));
                            ps.executeUpdate();

                            response.sendRedirect("mantenimiento.jsp?success=matriculaRegistrada");
                        } catch (Exception e) {
                            e.printStackTrace();
                            response.sendRedirect("mantenimiento.jsp?error=matriculaNoRegistrada");
                        }
                        break;
                            }

                    case "editarMatricula": {
                            try {
                                int idMatricula = Integer.parseInt(request.getParameter("idMatricula"));
                                int idAlumno = Integer.parseInt(request.getParameter("idAlumno"));
                                int idCurso = Integer.parseInt(request.getParameter("idCurso"));
                                String fechaMatricula = request.getParameter("fechaMatricula");

                                String consulta = "UPDATE Matriculas SET IdAlumno=?, IdCurso=?, FechaMatricula=? WHERE IdMatricula=?";
                                ps = con.prepareStatement(consulta);
                                ps.setInt(1, idAlumno);
                                ps.setInt(2, idCurso);
                                ps.setDate(3, java.sql.Date.valueOf(fechaMatricula));
                                ps.setInt(4, idMatricula);
                                ps.executeUpdate();

                                response.sendRedirect("mantenimiento.jsp?success=matriculaEditada");
                            } catch (Exception e) {
                                e.printStackTrace();
                                response.sendRedirect("mantenimiento.jsp?error=matriculaNoEditada");
                            }
                            break;
                            }
                    case "eliminarMatricula": {
                        try {
                            int idMatricula = Integer.parseInt(request.getParameter("idMatricula"));

                            String consulta = "UPDATE Matriculas SET EstadoRegistro=0 WHERE IdMatricula=?";
                            ps = con.prepareStatement(consulta);
                            ps.setInt(1, idMatricula);
                            ps.executeUpdate();

                            response.sendRedirect("mantenimiento.jsp?success=matriculaEliminada");
                        } catch (Exception e) {
                            e.printStackTrace();
                            response.sendRedirect("mantenimiento.jsp?error=matriculaNoEliminada");
                        }
                        break;
                    }
                    
                    case "registrarAlumno": {
                        int idUsuario = Integer.parseInt(request.getParameter("idUsuario")); // Captura el IdUsuario
                        int idIdioma = Integer.parseInt(request.getParameter("idIdioma")); // Captura el IdIdioma

                        String consulta = "INSERT INTO Alumno (IdUsuario, IdIdioma) VALUES (?, ?)";
                        ps = con.prepareStatement(consulta);
                        ps.setInt(1, idUsuario);
                        ps.setInt(2, idIdioma);

                        ps.executeUpdate();
                        response.sendRedirect("mantenimiento.jsp?success=alumnoRegistrado");
                        break;
                    }
                    
                    case "editarAlumno": {
                        int idAlumno = Integer.parseInt(request.getParameter("idAlumno"));
                        int idUsuario = Integer.parseInt(request.getParameter("idUsuario")); // Captura el IdUsuario
                        int idIdioma = Integer.parseInt(request.getParameter("idIdioma")); // Captura el IdIdioma

                        String consulta = "UPDATE Alumno SET IdUsuario=?, IdIdioma=? WHERE IdAlumno=?";
                        ps = con.prepareStatement(consulta);
                        ps.setInt(1, idUsuario);
                        ps.setInt(2, idIdioma);
                        ps.setInt(3, idAlumno);

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

          case "registrarOpcionMenu": {
    // Obtener los parámetros del formulario
    String nombreMenu = request.getParameter("nombreMenu");
    String descripcionMenu = request.getParameter("descripcionMenu");
    String urlMenu = request.getParameter("urlMenu");
    String estadoMenu = request.getParameter("estadoMenu");
    String menuPadre = request.getParameter("menuPadre"); // Esto puede ser null si el menú es principal
    String tipoMenu = request.getParameter("tipoMenu");  // Obtenemos el tipo de menú (menú o submenú)
    String perfilesString = request.getParameter("perfiles"); // Obtenemos el string de los perfiles seleccionados

    // Convertir a mayúsculas para mantener uniformidad en la base de datos
    nombreMenu = nombreMenu.toUpperCase();
    descripcionMenu = descripcionMenu.toUpperCase();
    urlMenu = urlMenu.toLowerCase(); // Por convención, URL suele ir en minúsculas

    try {
        // Lógica para obtener el IdPadre dependiendo del tipo de menú
        Integer idPadre = null;
        if (tipoMenu.equals("submenu") && menuPadre != null && !menuPadre.isEmpty()) {
            // Si es un submenú, asignar el IdPadre del menú seleccionado
            idPadre = Integer.parseInt(menuPadre);
        } else {
            // Si es un menú principal, el IdPadre es null (o 0 si lo prefieres)
            idPadre = null;
        }

        // Inserción de la nueva opción de menú
        String query = "INSERT INTO OpcionesMenu (Nombre, Descripcion, UrlMenu, EstadoRegistro, IdPadre) VALUES (?, ?, ?, ?, ?)";
        ps = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, nombreMenu);
        ps.setString(2, descripcionMenu);
        ps.setString(3, urlMenu);
        ps.setInt(4, Integer.parseInt(estadoMenu));
        ps.setObject(5, idPadre); // Usamos setObject para permitir null en IdPadre

        int rowsAffected = ps.executeUpdate();

        // Obtener el ID de la nueva opción de menú
        ResultSet rs = ps.getGeneratedKeys();
        int idOpcionMenu = 0;
        if (rs.next()) {
            idOpcionMenu = rs.getInt(1);
        }

        // Asociar los perfiles seleccionados a la nueva opción de menú
        if (perfilesString != null && !perfilesString.isEmpty()) {
            // Dividir los perfiles seleccionados en una lista de Strings
            String[] perfiles = perfilesString.split(",");

            String perfilQuery = "INSERT INTO OpcionesMenu_Perfiles (IdOpcionMenu, IdPerfil, Orden, EstadoRegistro) VALUES (?, ?, ?, ?)";
            int orden = 1;  // Puedes ajustar el valor de 'orden' si es necesario para tus necesidades
            for (String perfilId : perfiles) {
                ps = con.prepareStatement(perfilQuery);
                ps.setInt(1, idOpcionMenu);
                ps.setInt(2, Integer.parseInt(perfilId)); // Convertir el IdPerfil de String a Integer
                ps.setInt(3, orden);  // Establecer el valor de 'Orden'
                ps.setInt(4, 1);  // Establecer EstadoRegistro como activo (1)
                ps.executeUpdate();
                orden++;  // Incrementar el orden para cada perfil seleccionado
            }
        }

        // Redirigir a la página de mantenimiento con éxito
        response.sendRedirect("mantenimiento.jsp?success=opcionMenuRegistrada");

    } catch (SQLException e) {
        e.printStackTrace();
        // Manejar la excepción (si es necesario)
        response.sendRedirect("mantenimiento.jsp?error=registroFallido");
    }

    break;
}
          
   case "editarOpcionMenu": {
    try {
        // Capturar los parámetros enviados desde el formulario
        int idOpcionMenu = Integer.parseInt(request.getParameter("idOpcionMenu"));
        String nombre = request.getParameter("nombreMenu");
        String urlMenu = request.getParameter("urlMenu");
        String descripcion = request.getParameter("descripcionMenu");
        String tipoMenu = request.getParameter("tipoMenu");
        String idPadreStr = request.getParameter("menuPadre");
        int estadoRegistro = Integer.parseInt(request.getParameter("estadoMenu"));
        String[] perfilesSeleccionados = request.getParameterValues("perfilesCheckbox");

        // Determinar si tiene un menú padre (solo si es un submenú)
        Integer idPadre = null;
        if ("submenu".equals(tipoMenu) && idPadreStr != null && !idPadreStr.isEmpty()) {
            idPadre = Integer.parseInt(idPadreStr);
        }

        // Actualizar los datos básicos de la opción de menú
        String consultaActualizar = "UPDATE OpcionesMenu SET Nombre=?, UrlMenu=?, Descripcion=?, IdPadre=?, EstadoRegistro=? WHERE IdOpcionMenu=?";
        PreparedStatement psActualizar = con.prepareStatement(consultaActualizar);
        psActualizar.setString(1, nombre);
        psActualizar.setString(2, urlMenu);
        psActualizar.setString(3, descripcion);
        if (idPadre != null) {
            psActualizar.setInt(4, idPadre);
        } else {
            psActualizar.setNull(4, java.sql.Types.INTEGER);
        }
        psActualizar.setInt(5, estadoRegistro);
        psActualizar.setInt(6, idOpcionMenu);

        psActualizar.executeUpdate();

        // Eliminar perfiles existentes
        String consultaEliminarPerfiles = "DELETE FROM OpcionesMenu_Perfiles WHERE IdOpcionMenu=?";
        PreparedStatement psEliminarPerfiles = con.prepareStatement(consultaEliminarPerfiles);
        psEliminarPerfiles.setInt(1, idOpcionMenu);
        psEliminarPerfiles.executeUpdate();

        // Insertar nuevos perfiles seleccionados
        if (perfilesSeleccionados != null) {
            String consultaInsertarPerfil = "INSERT INTO OpcionesMenu_Perfiles (IdOpcionMenu, IdPerfil, Orden, EstadoRegistro) VALUES (?, ?, ?, 1)";
            PreparedStatement psInsertarPerfil = con.prepareStatement(consultaInsertarPerfil);

            for (String perfil : perfilesSeleccionados) {
                int idPerfil = Integer.parseInt(perfil);
                psInsertarPerfil.setInt(1, idOpcionMenu);
                psInsertarPerfil.setInt(2, idPerfil);
                psInsertarPerfil.setInt(3, 0); // Orden predeterminado
                psInsertarPerfil.addBatch();
            }

            psInsertarPerfil.executeBatch();
            psInsertarPerfil.close();
        }

        // Redirigir con mensaje de éxito
        response.sendRedirect("mantenimiento.jsp?success=opcionEditada");
    } catch (Exception e) {
        e.printStackTrace();
        
        // Redirigir con mensaje de error en caso de fallo
        response.sendRedirect("mantenimiento.jsp?error=opcionNoEditada");
    }
    break;
}

   case "eliminarOpcionMenu": {
    try {
        // Capturar el ID de la opción de menú a eliminar
        int idOpcionMenu = Integer.parseInt(request.getParameter("idOpcionMenu"));

        // Actualizar EstadoRegistro a 0 para el menú padre
        String consultaActualizarPadre = "UPDATE OpcionesMenu SET EstadoRegistro = 0 WHERE IdOpcionMenu = ?";
        PreparedStatement psActualizarPadre = con.prepareStatement(consultaActualizarPadre);
        psActualizarPadre.setInt(1, idOpcionMenu);
        psActualizarPadre.executeUpdate();

        // Actualizar EstadoRegistro a 0 para todos los menús hijos
        String consultaActualizarHijos = "UPDATE OpcionesMenu SET EstadoRegistro = 0 WHERE IdPadre = ?";
        PreparedStatement psActualizarHijos = con.prepareStatement(consultaActualizarHijos);
        psActualizarHijos.setInt(1, idOpcionMenu);
        psActualizarHijos.executeUpdate();

        // Redirigir con mensaje de éxito
        response.sendRedirect("mantenimiento.jsp?success=opcionEliminada");
    } catch (Exception e) {
        e.printStackTrace();
        
        // Redirigir con mensaje de error en caso de fallo
        response.sendRedirect("mantenimiento.jsp?error=opcionNoEliminada");
    }
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
