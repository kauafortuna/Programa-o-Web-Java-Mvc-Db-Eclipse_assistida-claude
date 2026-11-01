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

@WebServlet("/cadastro")
public class CadastroServlet extends HttpServlet {

    private final UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/cadastro.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String nome = limpar(req.getParameter("nome"));
        String email = limpar(req.getParameter("email")).toLowerCase();
        String senha = req.getParameter("senha") == null ? "" : req.getParameter("senha");
        String confirmar = req.getParameter("confirmar") == null ? "" : req.getParameter("confirmar");

        String erro = null;
        if (nome.length() < 2) {
            erro = "Informe seu nome.";
        } else if (!email.matches("^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)+$")) {
            erro = "E-mail inválido.";
        } else if (senha.length() < 6) {
            erro = "A senha deve ter pelo menos 6 caracteres.";
        } else if (!senha.equals(confirmar)) {
            erro = "As senhas não conferem.";
        }

        try {
            if (erro == null && dao.emailExiste(email)) {
                erro = "Este e-mail já está cadastrado.";
            }
            if (erro == null) {
                Usuario u = new Usuario();
                u.setNome(nome);
                u.setEmail(email);
                u.setSenhaHash(SenhaUtil.gerarHash(senha));
                dao.cadastrar(u);
                resp.sendRedirect(req.getContextPath() + "/login.jsp?cadastro=ok");
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            erro = "Não foi possível acessar o banco de dados. Tente novamente.";
        }

        // Deu erro: volta pra tela mantendo nome e e-mail (a senha nunca é devolvida)
        req.setAttribute("erro", erro);
        req.setAttribute("nome", nome);
        req.setAttribute("email", email);
        req.getRequestDispatcher("/cadastro.jsp").forward(req, resp);
    }

    private String limpar(String s) {
        return s == null ? "" : s.trim();
    }
}