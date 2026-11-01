const TAXA_USD = 5.40;

const selecaoDirecao = document.getElementById("direcao");
const labelEntrada = document.getElementById("labelEntrada");
const campoEntrada = document.getElementById("valorEntrada");
const botaoConverter = document.getElementById("btnConverter");
const caixaResultado = document.getElementById("resultadoConversor");
const valorResultado = document.getElementById("valorResultado");

function paraNumero(texto) {
  const limpo = texto.replace(/\./g, "").replace(",", ".");
  const n = parseFloat(limpo);
  return isNaN(n) ? NaN : n;
}

function formatar(n, moeda) {
  return n.toLocaleString("pt-BR", { style: "currency", currency: moeda });
}

if (selecaoDirecao && campoEntrada && botaoConverter) {

  selecaoDirecao.addEventListener("change", () => {
    labelEntrada.textContent = selecaoDirecao.value === "real-dolar"
      ? "Valor em Real (R$)"
      : "Valor em Dólar (US$)";
    campoEntrada.value = "";
    caixaResultado.style.display = "none";
  });

  botaoConverter.addEventListener("click", () => {
    const valor = paraNumero(campoEntrada.value);

    if (isNaN(valor) || valor <= 0) {
      alert("Digite um valor válido, maior que zero.");
      return;
    }

    let resultado, moedaResultado;
    if (selecaoDirecao.value === "real-dolar") {
      resultado = valor / TAXA_USD;
      moedaResultado = "USD";
    } else {
      resultado = valor * TAXA_USD;
      moedaResultado = "BRL";	
    }

    valorResultado.textContent = formatar(resultado, moedaResultado);
    caixaResultado.style.display = "block";
  });

  // Permite apertar Enter no campo para converter
  campoEntrada.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      e.preventDefault();
      botaoConverter.click();
    }
  });
}