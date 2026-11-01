<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.NumberFormat, java.util.List, java.util.Locale" %>
<%@ page import="com.bancoapp.model.Usuario, com.bancoapp.model.Transacao, com.bancoapp.util.HtmlUtil" %>
<%
    Usuario usuario = (Usuario) request.getAttribute("usuario");
    List<Transacao> transacoes = (List<Transacao>) request.getAttribute("transacoes");
    String flashTipo = (String) request.getAttribute("flashTipo");
    String flashTexto = (String) request.getAttribute("flashTexto");
    NumberFormat moeda = NumberFormat.getCurrencyInstance(Locale.of("pt", "BR"));
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Painel · BancoApp</title>
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

<body class="pagina-home">
<div id="telaEntrada">
  <div class="logo-entrada"><span class="ponto"></span>Kaligrafo</div>
</div>
<div id="barraCarregamento"></div>
  <div class="container-home">

    <header class="topo-home">
      <div>
        <p class="sub" style="margin-bottom:2px">Olá, <%= HtmlUtil.esc(usuario.getNome()) %> 👋</p>
        <h1>Painel</h1>
      </div>
      <form action="<%= request.getContextPath() %>/logout" method="post">
        <button type="submit" class="btn btn-sec btn-pequeno">Sair</button>
      </form>
    </header>

    <% if (flashTexto != null) { %>
      <div class="msg <%= "ok".equals(flashTipo) ? "ok" : "erro" %>" id="flashMsg"><%= HtmlUtil.esc(flashTexto) %></div>
    <% } %>

    <section class="card-home card-saldo">
      <p class="rotulo-saldo">💳 Saldo disponível</p>
      <p class="saldo" id="saldoAtual" data-valor="<%= usuario.getSaldo() %>"><%= moeda.format(usuario.getSaldo()) %></p>
    </section>

    <div class="grid-2">
      <section class="card-home">
        <p class="titulo-card"><span class="icone-card icone-deposito">↓</span>Depositar</p>
        <form action="<%= request.getContextPath() %>/depositar" method="post" class="form-valor" onsubmit="desabilitar(this)">
          <div class="campo">
            <label for="valorDep">Valor (R$)</label>
            <input type="text" id="valorDep" name="valor" inputmode="decimal" placeholder="0,00" required>
          </div>
          <button type="submit" class="btn">Depositar</button>
        </form>
      </section>

      <section class="card-home">
        <p class="titulo-card"><span class="icone-card icone-saque">↑</span>Sacar</p>
        <form action="<%= request.getContextPath() %>/sacar" method="post" class="form-valor" onsubmit="desabilitar(this)">
          <div class="campo">
            <label for="valorSaq">Valor (R$)</label>
            <input type="text" id="valorSaq" name="valor" inputmode="decimal" placeholder="0,00" required>
          </div>
          <button type="submit" class="btn btn-saque">Sacar</button>
        </form>
      </section>
    </div>

    <section class="card-home">
      <p class="titulo-card"><span class="icone-card icone-conversor">⇄</span>Conversor de moeda</p>
      <p class="sub" id="taxaInfo">1 BRL = 0,1852 USD · taxa fixa de referência</p>

      <div class="conversor">
        <div class="conversor-campo">
          <label for="valorReal">Real brasileiro</label>
          <div class="conversor-input">
            <span class="moeda-prefixo">R$</span>
            <input type="text" id="valorReal" inputmode="decimal" placeholder="0,00" autocomplete="off">
          </div>
        </div>

        <button type="button" id="btnTrocar" class="btn-trocar" title="Inverter" aria-label="Inverter moedas">⇄</button>

        <div class="conversor-campo">
          <label for="valorDolar">Dólar americano</label>
          <div class="conversor-input">
            <span class="moeda-prefixo">US$</span>
            <input type="text" id="valorDolar" inputmode="decimal" placeholder="0,00" autocomplete="off">
          </div>
        </div>
      </div>
    </section>

    <section class="card-home">
      <p class="titulo-card"><span class="icone-card icone-extrato">≡</span>Últimas movimentações</p>
      <% if (transacoes == null || transacoes.isEmpty()) { %>
        <p class="vazio-extrato">Nenhuma movimentação ainda. Faça seu primeiro depósito!</p>
      <% } else { %>
        <table class="tabela-extrato">
          <% for (Transacao t : transacoes) { %>
            <tr>
              <td><span class="tag <%= t.getTipo().equals("DEPOSITO") ? "tag-dep" : "tag-saq" %>">
                  <%= t.getTipo().equals("DEPOSITO") ? "↓ Depósito" : "↑ Saque" %></span></td>
              <td class="valor-extrato"><%= moeda.format(t.getValor()) %></td>
              <td class="data-extrato"><%= t.getData() %></td>
            </tr>
          <% } %>
        </table>
      <% } %>
    </section>

  </div>

  <script>
    // Conversor em tempo real
    (function () {
      const TAXA_USD = 5.40;
      const campoReal = document.getElementById("valorReal");
      const campoDolar = document.getElementById("valorDolar");
      const botaoTrocar = document.getElementById("btnTrocar");

      function paraNumero(texto) {
        const limpo = texto.replace(/\./g, "").replace(",", ".");
        const n = parseFloat(limpo);
        return isNaN(n) ? 0 : n;
      }
      function formatar(n) {
        return n.toLocaleString("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
      }

      if (campoReal && campoDolar) {
        campoReal.addEventListener("input", function () {
          const reais = paraNumero(campoReal.value);
          campoDolar.value = reais > 0 ? formatar(reais / TAXA_USD) : "";
        });
        campoDolar.addEventListener("input", function () {
          const dolares = paraNumero(campoDolar.value);
          campoReal.value = dolares > 0 ? formatar(dolares * TAXA_USD) : "";
        });
      }
      if (botaoTrocar) {
        botaoTrocar.addEventListener("click", function () {
          const temp = campoReal.value;
          campoReal.value = campoDolar.value;
          campoDolar.value = temp;
          botaoTrocar.classList.add("girar");
          setTimeout(() => botaoTrocar.classList.remove("girar"), 400);
        });
      }
    })();

    // Desabilita o botão ao enviar, evitando clique duplo
    function desabilitar(form) {
      const btn = form.querySelector("button[type=submit]");
      if (btn) {
        btn.disabled = true;
        btn.textContent = "Enviando...";
      }
    }

    // Toast de mensagem some sozinho depois de alguns segundos
    (function () {
      const flash = document.getElementById("flashMsg");
      if (flash) {
        setTimeout(() => {
          flash.style.transition = "opacity 0.4s ease, transform 0.4s ease";
          flash.style.opacity = "0";
          flash.style.transform = "translateY(-8px)";
          setTimeout(() => flash.remove(), 400);
        }, 4000);
      }
    })();

    // Pequena animação de "subida" no número do saldo ao carregar a página
    (function () {
      const el = document.getElementById("saldoAtual");
      if (!el) return;
      el.style.filter = "blur(4px)";
      el.style.opacity = "0";
      requestAnimationFrame(() => {
        el.style.transition = "filter 0.5s ease, opacity 0.5s ease";
        el.style.filter = "none";
        el.style.opacity = "1";
      });
    })();
  </script>
</body>
</html>