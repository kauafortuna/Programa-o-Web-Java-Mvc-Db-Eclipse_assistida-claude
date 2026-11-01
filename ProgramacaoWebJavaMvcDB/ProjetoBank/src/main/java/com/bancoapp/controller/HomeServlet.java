package com.bancoapp.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.bancoapp.dao.UsuarioDAO;
import com.bancoapp.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession sessao = req.getSession(false);
        int id = (int) sessao.getAttribute("usuarioId");

        try {
            Usuario usuario = dao.buscarPorId(id);
            if (usuario == null) {
                sessao.invalidate();
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            String flash = (String) sessao.getAttribute("flash");
            sessao.removeAttribute("flash"); // só mostra uma vez

            req.setAttribute("usuario", usuario);
            req.setAttribute("transacoes", dao.listarTransacoes(id, 10));
            if (flash != null) {
                String[] partes = flash.split(":", 2);
                req.setAttribute("flashTipo", partes[0]);   // ok ou erro
                req.setAttribute("flashTexto", partes[1]);
            }
            req.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Erro ao carregar usuário", e);
        }
    }
}