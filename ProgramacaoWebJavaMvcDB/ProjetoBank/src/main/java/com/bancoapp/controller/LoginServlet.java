package com.bancoapp.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.bancoapp.dao.UsuarioDAO;
import com.bancoapp.model.Usuario;
import com.bancoapp.util.SenhaUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email") == null ? "" : req.getParameter("email").trim().toLowerCase();
        String senha = req.getParameter("senha") == null ? "" : req.getParameter("senha");

        String erro = null;
        try {
            Usuario u = dao.buscarPorEmail(email);
            if (u != null && SenhaUtil.verificar(senha, u.getSenhaHash())) {
                // Descarta a sessão antiga e cria uma nova (evita "session fixation")
                HttpSession antiga = req.getSession(false);
                if (antiga != null) antiga.invalidate();

                HttpSession sessao = req.getSession(true);
                sessao.setAttribute("usuarioId", u.getId());
                sessao.setMaxInactiveInterval(30 * 60); // expira após 30 min sem uso

                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }
            erro = "E-mail ou senha incorretos.";
        } catch (SQLException e) {
            e.printStackTrace();
            erro = "Não foi possível acessar o banco de dados. Tente novamente.";
        }

        req.setAttribute("erro", erro);
        req.setAttribute("email", email);
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}