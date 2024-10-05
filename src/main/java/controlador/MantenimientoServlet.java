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
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import modelo.Conexion;

@WebServlet("/MantenimientoServlet")
public class MantenimientoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        try {
            Connection con = Conexion.getConnection();
            PreparedStatement ps;

            if ("registrarUsuario".equals(accion)) {
                // Lógica para registrar un nuevo usuario
                String dni = request.getParameter("dni");
                String nombres = request.getParameter("nombres");
                String apellidoPaterno = request.getParameter("apellidoPaterno");
                String correo = request.getParameter("correo");
                int perfil = Integer.parseInt(request.getParameter("perfil"));

                String query = "INSERT INTO Usuario (DNI, Nombres, ApellidoPaterno, CorreoElectronico, Clave, FechaCreacion, EstadoRegistro) " +
                               "VALUES (?, ?, ?, ?, ?, NOW(), 1)";
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
            } else if ("registrarPerfil".equals(accion)) {
                // Lógica para registrar un nuevo perfil
                String nombrePerfil = request.getParameter("nombrePerfil");
                String descripcionPerfil = request.getParameter("descripcionPerfil");

                String query = "INSERT INTO Perfiles (Nombre, Descripcion, EstadoRegistro) VALUES (?, ?, 1)";
                ps = con.prepareStatement(query);
                ps.setString(1, nombrePerfil);
                ps.setString(2, descripcionPerfil);
                ps.executeUpdate();

                response.sendRedirect("mantenimiento.jsp?success=perfilRegistrado");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
