package com.bancoapp.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexaoDB {

    private static final String URL =
        "jdbc:mysql://localhost:3306/bancoapp"
        + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=America/Sao_Paulo";
    private static final String USUARIO = "bancoapp";
    private static final String SENHA = "bancoapp123";

    public static Connection getConexao() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver do MySQL não encontrado em WEB-INF/lib", e);
        }
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }
}