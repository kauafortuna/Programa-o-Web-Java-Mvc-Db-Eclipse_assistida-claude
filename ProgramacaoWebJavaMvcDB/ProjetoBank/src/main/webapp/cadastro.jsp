<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bancoapp.util.HtmlUtil" %>
<%
    String erro = (String) request.getAttribute("erro");
    String nome = (String) request.getAttribute("nome");
    String email = (String) request.getAttribute("email");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Criar conta</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<script>
  // Esconde a tela de entrada assim que a página termina de carregar
  window.addEventListener("load", function () {
    var tela = document.getElementById("telaEntrada");
    if (tela) setTimeout(() => tela.classList.add("escondida"), 250);
  });

  // Mostra a barra de progresso ao clicar em links internos ou enviar formulários
  (function () {
    var barra = document.getElementById("barraCarregamento");
    if (!barra) return;

    document.addEventListener("click", function (e) {
      var link = e.target.closest("a");
      if (link && link.origin === location.origin && !link.target && !e.ctrlKey && !e.metaKey) {
        barra.classList.add("ativa");
      }
    });

    document.addEventListener("submit", function () {
      barra.classList.add("ativa");
    });

    window.addEventListener("beforeunload", function () {
      barra.classList.add("ativa");
    });
  })();
</script>

<body>
<div id="telaEntrada">
  <div class="logo-entrada"><span class="ponto"></span>Kaligrafo</div>
</div>
<div id="barraCarregamento"></div>
  <main class="card">
    <h1>Criar conta</h1>
    <p class="sub">Comece a gerenciar seu saldo em segundos.</p>

    <% if (erro != null) { %>
      <div class="msg erro"><%= HtmlUtil.esc(erro) %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/cadastro" method="post">
      <div class="campo">
        <label for="nome">Nome</label>
        <input type="text" id="nome" name="nome" value="<%= HtmlUtil.esc(nome) %>" required>
      </div>
      <div class="campo">
        <label for="email">E-mail</label>
        <input type="email" id="email" name="email" value="<%= HtmlUtil.esc(email) %>" required>
      </div>
      <div class="campo">
        <label for="senha">Senha</label>
        <input type="password" id="senha" name="senha" minlength="6" required>
      </div>
      <div class="campo">
        <label for="confirmar">Confirmar senha</label>
        <input type="password" id="confirmar" name="confirmar" minlength="6" required>
      </div>
      <button type="submit" class="btn">Criar conta</button>
    </form>

    <p class="link">Já tem conta? <a href="<%= request.getContextPath() %>/login.jsp">Entrar</a></p>
  </main>
</body>
</html>