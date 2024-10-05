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
import java.sql.ResultSet;
import modelo.Conexion;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String dni = request.getParameter("dni");
        String clave = request.getParameter("clave");

        try {
            // Conectar a la base de datos
            Connection con = Conexion.getConnection();
            
            // Consultar el usuario por DNI y clave
            String query = "SELECT u.Nombres, p.Nombre as Perfil FROM Usuario u " +
                           "JOIN Usuario_Perfiles up ON u.IdUsuario = up.IdUsuario " +
                           "JOIN Perfiles p ON up.IdPerfil = p.IdPerfil " +
                           "WHERE u.DNI = ? AND u.Clave = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, dni);
            ps.setString(2, clave);
            
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Obtener el nombre y perfil del usuario
                String nombre = rs.getString("Nombres");
                String perfil = rs.getString("Perfil");
                
                // Crear una sesión para el usuario autenticado
                HttpSession session = request.getSession();
                session.setAttribute("nombre", nombre);
                session.setAttribute("perfil", perfil);
                
                // Redirigir a la página que muestra el perfil
                response.sendRedirect("perfilUsuario.jsp");
            } else {
                // Si el login falla, redirigir a una página de error
                response.sendRedirect("errorLogin.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("errorLogin.jsp");
        }
    }
}
