package com.bancoapp.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.bancoapp.model.Transacao;
import com.bancoapp.model.Usuario;
import com.bancoapp.util.ConexaoDB;

public class UsuarioDAO {

    public boolean emailExiste(String email) throws SQLException {
        String sql = "SELECT 1 FROM usuarios WHERE email = ?";
        try (Connection con = ConexaoDB.getConexao();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void cadastrar(Usuario u) throws SQLException {
        String sql = "INSERT INTO usuarios (nome, email, senha_hash) VALUES (?, ?, ?)";
        try (Connection con = ConexaoDB.getConexao();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getNome());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getSenhaHash());
            ps.executeUpdate();
        }
    }

    public Usuario buscarPorEmail(String email) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE email = ?";
        try (Connection con = ConexaoDB.getConexao();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    public Usuario buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM usuarios WHERE id = ?";
        try (Connection con = ConexaoDB.getConexao();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    public void depositar(int usuarioId, BigDecimal valor) throws SQLException {
        try (Connection con = ConexaoDB.getConexao()) {
            con.setAutoCommit(false);
            try {
                try (PreparedStatement ps = con.prepareStatement(
                        "UPDATE usuarios SET saldo = saldo + ? WHERE id = ?")) {
                    ps.setBigDecimal(1, valor);
                    ps.setInt(2, usuarioId);
                    ps.executeUpdate();
                }
                registrar(con, usuarioId, "DEPOSITO", valor);
                con.commit();
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
        }
    }

    // Retorna false se não houver saldo suficiente.
    public boolean sacar(int usuarioId, BigDecimal valor) throws SQLException {
        try (Connection con = ConexaoDB.getConexao()) {
            con.setAutoCommit(false);
            try {
                try (PreparedStatement ps = con.prepareStatement(
                        "UPDATE usuarios SET saldo = saldo - ? WHERE id = ? AND saldo >= ?")) {
                    ps.setBigDecimal(1, valor);
                    ps.setInt(2, usuarioId);
                    ps.setBigDecimal(3, valor);
                    if (ps.executeUpdate() == 0) {
                        con.rollback();
                        return false;
                    }
                }
                registrar(con, usuarioId, "SAQUE", valor);
                con.commit();
                return true;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
        }
    }

    public List<Transacao> listarTransacoes(int usuarioId, int limite) throws SQLException {
        String sql = "SELECT tipo, valor, criado_em FROM transacoes WHERE usuario_id = ? "
                   + "ORDER BY criado_em DESC LIMIT ?";
        List<Transacao> lista = new ArrayList<>();
        try (Connection con = ConexaoDB.getConexao();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setInt(2, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Transacao t = new Transacao();
                    t.setTipo(rs.getString("tipo"));
                    t.setValor(rs.getBigDecimal("valor"));
                    t.setData(rs.getTimestamp("criado_em"));
                    lista.add(t);
                }
            }
        }
        return lista;
    }

    private void registrar(Connection con, int usuarioId, String tipo, BigDecimal valor)
            throws SQLException {
        String sql = "INSERT INTO transacoes (usuario_id, tipo, valor) VALUES (?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            ps.setString(2, tipo);
            ps.setBigDecimal(3, valor);
            ps.executeUpdate();
        }
    }

    private Usuario mapear(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setId(rs.getInt("id"));
        u.setNome(rs.getString("nome"));
        u.setEmail(rs.getString("email"));
        u.setSenhaHash(rs.getString("senha_hash"));
        u.setSaldo(rs.getBigDecimal("saldo"));
        return u;
    }
}