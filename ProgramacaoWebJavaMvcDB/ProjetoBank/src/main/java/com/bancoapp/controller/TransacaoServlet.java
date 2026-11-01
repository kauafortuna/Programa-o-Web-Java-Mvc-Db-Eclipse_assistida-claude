package com.bancoapp.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;

import com.bancoapp.dao.UsuarioDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({ "/depositar", "/sacar" })
public class TransacaoServlet extends HttpServlet {

    private final UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession sessao = req.getSession(false);
        int usuarioId = (int) sessao.getAttribute("usuarioId");
        String acao = req.getServletPath(); // "/depositar" ou "/sacar"

        String mensagem;
        try {
            BigDecimal valor = new BigDecimal(req.getParameter("valor").replace(",", "."))
                                    .setScale(2, RoundingMode.HALF_UP);

            if (valor.compareTo(new BigDecimal("0.01")) < 0) {
                mensagem = "erro:Informe um valor válido, maior que zero.";
            } else if (acao.equals("/depositar")) {
                dao.depositar(usuarioId, valor);
                mensagem = "ok:Depósito realizado com sucesso.";
            } else {
                boolean sucesso = dao.sacar(usuarioId, valor);
                mensagem = sucesso ? "ok:Saque realizado com sucesso." : "erro:Saldo insuficiente.";
            }
        } catch (NumberFormatException e) {
            mensagem = "erro:Valor inválido.";
        } catch (SQLException e) {
            e.printStackTrace();
            mensagem = "erro:Erro ao acessar o banco de dados.";
        }

        // Guarda o resultado na sessão só até a próxima página carregar ("flash message")
        sessao.setAttribute("flash", mensagem);
        resp.sendRedirect(req.getContextPath() + "/home");
    }
}