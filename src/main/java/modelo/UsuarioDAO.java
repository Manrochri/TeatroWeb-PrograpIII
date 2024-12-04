package modelo;

import java.sql.*;
import java.util.Date;

public class UsuarioDAO {

    // Método para registrar un nuevo usuario
    public boolean registrarUsuario(Usuario usuario) {
        boolean registrado = false;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = Conexion.getConnection();
            String sql = "INSERT INTO Usuario (DNI, Nombres, ApellidoPaterno, ApellidoMaterno, Celular, CorreoElectronico, Clave, FechaCreacion, EstadoRegistro) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, usuario.getDni());
            ps.setString(2, usuario.getNombres());
            ps.setString(3, usuario.getApellidoPaterno());
            ps.setString(4, usuario.getApellidoMaterno());
            ps.setString(5, usuario.getCelular());
            ps.setString(6, usuario.getCorreoElectronico());
            ps.setString(7, usuario.getClave());
            ps.setTimestamp(8, new java.sql.Timestamp(new Date().getTime()));
            ps.setBoolean(9, usuario.isEstadoRegistro());

            int filas = ps.executeUpdate();

            if (filas > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int idUsuario = rs.getInt(1);
                    usuario.setIdUsuario(idUsuario);

                    // Actualizar campos de auditoría
                    String sqlUpdate = "UPDATE Usuario SET UsuarioCreacion = ?, UsuarioModificacion = ?, FechaModificacion = ? WHERE IdUsuario = ?";
                    try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdate)) {
                        psUpdate.setInt(1, idUsuario);
                        psUpdate.setInt(2, idUsuario);
                        psUpdate.setTimestamp(3, new java.sql.Timestamp(new Date().getTime()));
                        psUpdate.setInt(4, idUsuario);
                        psUpdate.executeUpdate();
                    }

                    // Insertar perfiles asociados
                    String sqlPerfiles = "INSERT INTO Usuario_Perfiles (IdUsuario, IdPerfil, EstadoRegistro) VALUES (?, ?, ?)";
                    try (PreparedStatement psPerfiles = con.prepareStatement(sqlPerfiles)) {
                        for (Integer idPerfil : usuario.getPerfiles()) {
                            psPerfiles.setInt(1, idUsuario);
                            psPerfiles.setInt(2, idPerfil);
                            psPerfiles.setBoolean(3, true);
                            psPerfiles.executeUpdate();
                        }
                    }

                    registrado = true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, ps, con);
        }
        return registrado;
    }

    // Método para actualizar un usuario existente
    public boolean actualizarUsuario(Usuario usuario) {
        boolean actualizado = false;

        String sql = "UPDATE Usuario SET DNI = ?, Nombres = ?, ApellidoPaterno = ?, ApellidoMaterno = ?, Celular = ?, CorreoElectronico = ?, Clave = ?, UsuarioModificacion = ?, FechaModificacion = ?, EstadoRegistro = ? WHERE IdUsuario = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario.getDni());
            ps.setString(2, usuario.getNombres());
            ps.setString(3, usuario.getApellidoPaterno());
            ps.setString(4, usuario.getApellidoMaterno());
            ps.setString(5, usuario.getCelular());
            ps.setString(6, usuario.getCorreoElectronico());
            ps.setString(7, usuario.getClave());
            ps.setInt(8, usuario.getUsuarioModificacion());
            ps.setTimestamp(9, new java.sql.Timestamp(new Date().getTime()));
            ps.setBoolean(10, usuario.isEstadoRegistro());
            ps.setInt(11, usuario.getIdUsuario());

            int filas = ps.executeUpdate();
            if (filas > 0) {
                actualizado = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return actualizado;
    }

    // Método para verificar si un DNI ya existe
    public boolean existeDni(String dni) {
        String sql = "SELECT COUNT(*) FROM Usuario WHERE DNI = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, dni);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Método para cerrar recursos de base de datos
    private void closeResources(ResultSet rs, PreparedStatement ps, Connection con) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}
