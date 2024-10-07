package modelo;

import java.sql.*;
import java.util.Date;
import org.mindrot.jbcrypt.BCrypt;

public class UsuarioDAO {

    // Método para registrar un nuevo usuario
    public boolean registrarUsuario(Usuario usuario) {
        boolean registrado = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Establecer conexión con la base de datos
            con = Conexion.getConnection();

            // Encriptar la clave del usuario antes de almacenarla
            String claveEncriptada = BCrypt.hashpw(usuario.getClave(), BCrypt.gensalt());

            // Sentencia SQL para insertar un nuevo usuario
            String sql = "INSERT INTO Usuario (DNI, Nombres, ApellidoPaterno, ApellidoMaterno, Celular, CorreoElectronico, Clave, FechaCreacion, EstadoRegistro) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            // Asignar los valores del objeto Usuario a la sentencia SQL
            ps.setString(1, usuario.getDni());
            ps.setString(2, usuario.getNombres());
            ps.setString(3, usuario.getApellidoPaterno());
            ps.setString(4, usuario.getApellidoMaterno());
            ps.setString(5, usuario.getCelular());
            ps.setString(6, usuario.getCorreoElectronico());
            ps.setString(7, claveEncriptada); // Guardar la clave encriptada
            ps.setTimestamp(8, new java.sql.Timestamp(new Date().getTime())); // Fecha de creación
            ps.setBoolean(9, usuario.isEstadoRegistro());

            // Ejecutar la inserción
            int filas = ps.executeUpdate();
            
            if (filas > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int idUsuario = rs.getInt(1); // Obtener el ID del usuario recién insertado
                    usuario.setIdUsuario(idUsuario);

                    // Actualizar campos adicionales
                    String sqlUpdate = "UPDATE Usuario SET UsuarioCreacion = ?, UsuarioModificacion = ?, FechaModificacion = ? WHERE IdUsuario = ?";
                    try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdate)) {
                        psUpdate.setInt(1, idUsuario); // UsuarioCreacion
                        psUpdate.setInt(2, idUsuario); // UsuarioModificacion
                        psUpdate.setTimestamp(3, new java.sql.Timestamp(new Date().getTime())); // Fecha de modificación
                        psUpdate.setInt(4, idUsuario);
                        psUpdate.executeUpdate();
                    } // UsuarioCreacion

                    // Insertar los perfiles asociados
                    for (Integer idPerfil : usuario.getPerfiles()) {
                        String sqlPerfiles = "INSERT INTO Usuario_Perfiles (IdUsuario, IdPerfil, EstadoRegistro) VALUES (?, ?, ?)";
                        try (PreparedStatement psPerfiles = con.prepareStatement(sqlPerfiles)) {
                            psPerfiles.setInt(1, idUsuario);
                            psPerfiles.setInt(2, idPerfil);
                            psPerfiles.setBoolean(3, true); // Estado activo
                            psPerfiles.executeUpdate();
                        }
                    }

                    registrado = true;
                }
            }
        } catch (SQLException e) {
        } finally {
            // Cerrar recursos
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
        return registrado;
    }

    // Método para actualizar un usuario existente en la base de datos
    public boolean actualizarUsuario(Usuario usuario) {
        boolean actualizado = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            // Obtener conexión
            con = Conexion.getConnection();

            // Encriptar la clave del usuario antes de almacenarla
            String claveEncriptada = BCrypt.hashpw(usuario.getClave(), BCrypt.gensalt());

            // Sentencia SQL para actualizar un usuario
            String sql = "UPDATE Usuario SET DNI = ?, Nombres = ?, ApellidoPaterno = ?, ApellidoMaterno = ?, Celular = ?, CorreoElectronico = ?, Clave = ?, UsuarioModificacion = ?, FechaModificacion = ?, EstadoRegistro = ? WHERE IdUsuario = ?";
            ps = con.prepareStatement(sql);

            // Asignación de valores
            ps.setString(1, usuario.getDni());
            ps.setString(2, usuario.getNombres());
            ps.setString(3, usuario.getApellidoPaterno());
            ps.setString(4, usuario.getApellidoMaterno());
            ps.setString(5, usuario.getCelular());
            ps.setString(6, usuario.getCorreoElectronico());
            ps.setString(7, claveEncriptada); // Guardar la clave encriptada
            ps.setInt(8, usuario.getUsuarioModificacion());
            ps.setTimestamp(9, new java.sql.Timestamp(new Date().getTime()));
            ps.setBoolean(10, usuario.isEstadoRegistro());
            ps.setInt(11, usuario.getIdUsuario());

            // Ejecutar la actualización
            int filas = ps.executeUpdate();
            if (filas > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
        } finally {
            // Cerrar recursos
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
        return actualizado;
    }
}