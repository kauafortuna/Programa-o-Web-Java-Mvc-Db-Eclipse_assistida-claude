package com.bancoapp.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class SenhaUtil {

    private static final int ITERACOES = 120000;
    private static final int TAMANHO_CHAVE = 256;

    // Gera "salt:hash". O salt é um valor aleatório que torna cada hash único.
    public static String gerarHash(String senha) {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        byte[] hash = pbkdf2(senha, salt);
        return Base64.getEncoder().encodeToString(salt) + ":"
             + Base64.getEncoder().encodeToString(hash);
    }

    // Refaz o hash da senha digitada com o mesmo salt e compara.
    public static boolean verificar(String senha, String armazenado) {
        try {
            String[] partes = armazenado.split(":");
            byte[] salt = Base64.getDecoder().decode(partes[0]);
            byte[] esperado = Base64.getDecoder().decode(partes[1]);
            byte[] calculado = pbkdf2(senha, salt);
            return MessageDigest.isEqual(esperado, calculado);
        } catch (Exception e) {
            return false;
        }
    }

    private static byte[] pbkdf2(String senha, byte[] salt) {
        try {
            PBEKeySpec spec = new PBEKeySpec(senha.toCharArray(), salt, ITERACOES, TAMANHO_CHAVE);
            return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
                                   .generateSecret(spec).getEncoded();
        } catch (Exception e) {
            throw new RuntimeException("Erro ao gerar hash da senha", e);
        }
    }
}