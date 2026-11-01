<div align="center">

<img src="https://readme-typing-svg.demolab.com?font=SF+Pro+Display&size=32&duration=2800&pause=800&color=2997FF&center=true&vCenter=true&width=460&lines=Kaligrafo;Seu+banco+digital;Java+%2B+JSP+%2B+MySQL" alt="Kaligrafo" />

<p>Banco digital acadêmico com login, cadastro, depósito, saque e conversor de moeda em tempo real.</p>

![Java](https://img.shields.io/badge/Java-21-2997FF?style=for-the-badge&logo=openjdk&logoColor=white)
![JSP](https://img.shields.io/badge/JSP%2FServlet-Jakarta%20EE-0A84FF?style=for-the-badge&logo=apache-tomcat&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.4-BF5AF2?style=for-the-badge&logo=mysql&logoColor=white)
![Status](https://img.shields.io/badge/status-finalizado-30D158?style=for-the-badge)

</div>

<br>

## 💡 Sobre o projeto

**Kaligrafo** é um banco digital simples desenvolvido como projeto da disciplina de Programação Web. Construído em **Java + JSP + Servlets**, seguindo o padrão **MVC**, com persistência em **MySQL**.

> Projeto incremental — construído aula a aula, evoluindo de telas estáticas até um fluxo completo de autenticação e transações financeiras.

<br>

## ✨ Funcionalidades

| | |
|---|---|
| 🔐 | Cadastro e login com senha protegida por hash (PBKDF2 + salt) |
| 💳 | Painel com saldo em tempo real |
| ⬇️ | Depósito |
| ⬆️ | Saque, com validação de saldo insuficiente |
| ⇄ | Conversor de moeda Real ↔ Dólar, instantâneo |
| 📜 | Extrato das últimas movimentações |
| 🌓 | Tema dark, inspirado na identidade visual da Apple |
| 🚀 | Landing page, splash screen e barra de carregamento animada |

<br>

## 🛠️ Stack

- **Backend:** Java 21, Servlets (Jakarta EE), JDBC
- **Frontend:** JSP, HTML5, CSS3, JavaScript puro
- **Banco de dados:** MySQL 8.4
- **Servidor:** Apache Tomcat 11
- **IDE:** Eclipse (Dynamic Web Project)

<br>

## 🏗️ Arquitetura (MVC)

```
Model       →  Usuario, Transacao, UsuarioDAO
View        →  index.jsp, login.jsp, cadastro.jsp, home.jsp
Controller  →  CadastroServlet, LoginServlet, LogoutServlet,
               HomeServlet, TransacaoServlet, AuthFilter
```

<br>

## ▶️ Como rodar localmente

```bash
# 1. Crie o banco
mysql -u root -p < database/schema.sql

# 2. Importe o projeto no Eclipse
File > Import > Existing Projects into Workspace

# 3. Configure o Tomcat 11 + JDK 21 no Eclipse
# 4. Run As > Run on Server
```

Acesse: `http://localhost:8080/ProjetoBank/`

<br>

<div align="center">
<sub>Desenvolvido como projeto acadêmico · Programação Web</sub>
</div>
