package com.bancoapp.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Transacao {
    private String tipo;
    private BigDecimal valor;
    private Timestamp data;

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public BigDecimal getValor() { return valor; }
    public void setValor(BigDecimal valor) { this.valor = valor; }

    public Timestamp getData() { return data; }
    public void setData(Timestamp data) { this.data = data; }
}