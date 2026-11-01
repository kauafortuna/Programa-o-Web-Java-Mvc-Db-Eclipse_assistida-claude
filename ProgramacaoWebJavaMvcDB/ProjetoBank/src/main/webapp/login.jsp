<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bancoapp.util.HtmlUtil" %>
<%
    String erro = (String) request.getAttribute("erro");
    String email = (String) request.getAttribute("email");
    boolean recemCadastrado = "ok".equals(request.getParameter("cadastro"));
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Entrar</title>
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
    <h1>Entrar</h1>
    <p class="sub">Acesse sua conta para continuar.</p>

    <% if (recemCadastrado) { %>
      <div class="msg ok">Conta criada com sucesso. Faça login.</div>
    <% } %>
    <% if (erro != null) { %>
      <div class="msg erro"><%= HtmlUtil.esc(erro) %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/login" method="post">
      <div class="campo">
        <label for="email">E-mail</label>
        <input type="email" id="email" name="email" value="<%= HtmlUtil.esc(email) %>" required>
      </div>
      <div class="campo">
        <label for="senha">Senha</label>
        <input type="password" id="senha" name="senha" required>
      </div>
      <button type="submit" class="btn">Entrar</button>
    </form>

    <p class="link">Não tem conta? <a href="<%= request.getContextPath() %>/cadastro.jsp">Criar conta</a></p>
  </main>
</body>
</html>