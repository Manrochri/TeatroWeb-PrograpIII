package modelo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PerfilDAO {

    // Método existente para obtener perfiles activos
    public List<Perfil> obtenerPerfiles() {
        List<Perfil> listaPerfiles = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = Conexion.getConnection();
            String sql = "SELECT IdPerfil, Nombre FROM Perfiles WHERE EstadoRegistro = ?";
            ps = con.prepareStatement(sql);
            ps.setBoolean(1, true); // Solo perfiles activos
            rs = ps.executeQuery();
            while (rs.next()) {
                Perfil perfil = new Perfil();
                perfil.setIdPerfil(rs.getInt("IdPerfil"));
                perfil.setNombre(rs.getString("Nombre"));
                listaPerfiles.add(perfil);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // Cerrar los recursos
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return listaPerfiles;
    }

    // Nuevo método para registrar un perfil
    public boolean registrarPerfil(Perfil perfil) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = Conexion.getConnection();
            String sql = "INSERT INTO Perfiles (Nombre, Descripcion, EstadoRegistro) VALUES (?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, perfil.getNombre());
            ps.setString(2, perfil.getDescripcion());
            ps.setBoolean(3, true);  // EstadoRegistro activo

            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            // Cerrar los recursos
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
    