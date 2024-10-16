/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Docente;
import modelo.DocenteDAO;

/**
 *
 * @author ASUS
 */
@WebServlet("/docentePerfil")
public class DocentePerfilServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idUsuario = Integer.parseInt(request.getParameter("id"));

        DocenteDAO docenteDAO = new DocenteDAO();
        Docente docente = docenteDAO.obtenerDocente(idUsuario);

        if (docente != null) {
            request.setAttribute("docente", docente);
            request.getRequestDispatcher("perfilDocente.jsp").forward(request, response);
        } else {
            response.sendRedirect("error.jsp");
        }
    }
}
