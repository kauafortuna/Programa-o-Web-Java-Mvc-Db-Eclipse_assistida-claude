<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Kaligrafo · Seu banco digital</title>
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
<body class="pagina-landing">

  <div id="telaEntrada">
    <div class="logo-entrada"><span class="ponto"></span>Kaligrafo</div>
  </div>
  <div id="barraCarregamento"></div>

  <nav class="nav-landing">
    <span class="logo-nav">Kaligrafo</span>
    <div class="nav-botoes">
      <a href="<%= request.getContextPath() %>/login.jsp" class="nav-link">Entrar</a>
      <a href="<%= request.getContextPath() %>/cadastro.jsp" class="btn btn-nav">Criar conta</a>
    </div>
  </nav>

  <header class="hero">
    <p class="hero-tag">Banco digital · 100% online</p>
    <h1 class="hero-titulo">Seu dinheiro,<br>em qualquer lugar.</h1>
    <p class="hero-sub">Deposite, saque e converta entre real e dólar em segundos.
       Simples, rápido e sempre com você.</p>
    <div class="hero-botoes">
      <a href="<%= request.getContextPath() %>/cadastro.jsp" class="btn btn-grande">Abrir minha conta</a>
      <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-sec btn-grande">Já tenho conta</a>
    </div>
  </header>

  <section class="secao-recursos">
    <div class="recurso">
      <div class="icone-recurso">💳</div>
      <h3>Saldo em tempo real</h3>
      <p>Acompanhe cada movimentação assim que ela acontece, sem esperar.</p>
    </div>
    <div class="recurso">
      <div class="icone-recurso">⇄</div>
      <h3>Conversor embutido</h3>
      <p>Converta entre real e dólar instantaneamente, direto no painel.</p>
    </div>
    <div class="recurso">
      <div class="icone-recurso">🔒</div>
      <h3>Seguro por padrão</h3>
      <p>Suas senhas nunca são armazenadas em texto simples, apenas hashes protegidos.</p>
    </div>
  </section>

  <footer class="rodape-landing">
    <p>Kaligrafo · Projeto acadêmico desenvolvido em Java, JSP e MySQL.</p>
  </footer>

  <script>
    window.addEventListener("load", function () {
      var tela = document.getElementById("telaEntrada");
      if (tela) setTimeout(() => tela.classList.add("escondida"), 250);
    });
    (function () {
      var barra = document.getElementById("barraCarregamento");
      if (!barra) return;
      document.addEventListener("click", function (e) {
        var link = e.target.closest("a");
        if (link && link.origin === location.origin && !link.target) {
          barra.classList.add("ativa");
        }
      });
    })();
  </script>
</body>
</html>