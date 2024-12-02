package modelo;

import java.sql.*;
import java.util.Date;

public class UsuarioDAO {

    public boolean registrarUsuario(Usuario usuario) {
        boolean registrado = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Establecer conexión con la base de datos
            con = Conexion.getConnection();

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
            ps.setString(7, usuario.getClave());
            ps.setTimestamp(8, new java.sql.Timestamp(new Date().getTime())); // Fecha de creación
            ps.setBoolean(9, usuario.isEstadoRegistro()); // Estado del registro (activo o inactivo)

            // Ejecutar la inserción
            int filas = ps.executeUpdate();

            if (filas > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int idUsuario = rs.getInt(1); // Obtener el ID del usuario recién insertado
                    usuario.setIdUsuario(idUsuario);

                    // Actualizar los campos UsuarioCreacion, UsuarioModificacion y FechaModificacion con el ID del usuario recién insertado
                    String sqlUpdate = "UPDATE Usuario SET UsuarioCreacion = ?, UsuarioModificacion = ?, FechaModificacion = ? WHERE IdUsuario = ?";
                    try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdate)) {
                        psUpdate.setInt(1, idUsuario); // UsuarioCreacion
                        psUpdate.setInt(2, idUsuario); // UsuarioModificacion
                        psUpdate.setTimestamp(3, new java.sql.Timestamp(new Date().getTime())); // Fecha de modificación igual a la de creación
                        psUpdate.setInt(4, idUsuario); // ID del usuario a actualizar
                        psUpdate.executeUpdate();
                    }

                    // Insertar los perfiles asociados al usuario
                    String sqlPerfiles = "INSERT INTO Usuario_Perfiles (IdUsuario, IdPerfil, EstadoRegistro) VALUES (?, ?, ?)";
                    try (PreparedStatement psPerfiles = con.prepareStatement(sqlPerfiles)) {
                        for (Integer idPerfil : usuario.getPerfiles()) {
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
            e.printStackTrace(); // Añadir logging o manejo de excepciones más detallado si es necesario
        } finally {
            // Cerrar recursos de base de datos
            closeResources(rs, ps, con);
        }
        return registrado;
    }

    // Método para actualizar un usuario existente en la base de datos
    public boolean actualizarUsuario(Usuario usuario) {
        boolean actualizado = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            // Obtener conexión a la base de datos
            con = Conexion.getConnection();

            // Sentencia SQL para actualizar un usuario
            String sql = "UPDATE Usuario SET DNI = ?, Nombres = ?, ApellidoPaterno = ?, ApellidoMaterno = ?, Celular = ?, CorreoElectronico = ?, Clave = ?, UsuarioModificacion = ?, FechaModificacion = ?, EstadoRegistro = ? WHERE IdUsuario = ?";
            ps = con.prepareStatement(sql);

            // Asignación de valores del usuario a los parámetros SQL
            ps.setString(1, usuario.getDni());
            ps.setString(2, usuario.getNombres());
            ps.setString(3, usuario.getApellidoPaterno());
            ps.setString(4, usuario.getApellidoMaterno());
            ps.setString(5, usuario.getCelular());
            ps.setString(6, usuario.getCorreoElectronico());
            ps.setString(7, usuario.getClave());
            ps.setInt(8, usuario.getUsuarioModificacion()); // Usuario que modifica el registro
            ps.setTimestamp(9, new java.sql.Timestamp(new Date().getTime())); // Fecha de modificación
            ps.setBoolean(10, usuario.isEstadoRegistro());
            ps.setInt(11, usuario.getIdUsuario()); // ID del usuario que se está actualizando

            // Ejecutar la sentencia de actualización
            int filas = ps.executeUpdate();
            if (filas > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Añadir logging o manejo de excepciones más detallado si es necesario
        } finally {
            // Cerrar recursos de base de datos
            closeResources(null, ps, con);
        }
        return actualizado;
    }

    // Método para cerrar recursos de base de datos
    private void closeResources(ResultSet rs, PreparedStatement ps, Connection con) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}
