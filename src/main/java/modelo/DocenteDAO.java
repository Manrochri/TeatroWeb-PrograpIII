/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;



import java.sql.*;

public class DocenteDAO {

    public boolean registrarDocente(int idUsuario, int idGradoAcademico, String descripcion) {
        boolean registrado = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = Conexion.getConnection();
            String sql = "INSERT INTO Docente (IdUsuario, IdGradoAcademico, Descripcion, FechaCreacion) VALUES (?, ?, ?, NOW())";
            ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ps.setInt(2, idGradoAcademico);
            ps.setString(3, descripcion);
            registrado = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
            if (con != null) try { con.close(); } catch (SQLException ignore) {}
        }
        return registrado;
    }

    public Docente obtenerDocente(int idUsuario) {
        Docente docente = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = Conexion.getConnection();
            String sql = "SELECT d.IdDocente, d.Descripcion, g.Nombre AS GradoAcademico "
                       + "FROM Docente d "
                       + "INNER JOIN GradoAcademico g ON d.IdGradoAcademico = g.IdGradoAcademico "
                       + "WHERE d.IdUsuario = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            if (rs.next()) {
                docente = new Docente();
                docente.setIdDocente(rs.getInt("IdDocente"));
                docente.setDescripcion(rs.getString("Descripcion"));
                docente.setGradoAcademico(rs.getString("GradoAcademico"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
            if (con != null) try { con.close(); } catch (SQLException ignore) {}
        }
        return docente;
    }
}
