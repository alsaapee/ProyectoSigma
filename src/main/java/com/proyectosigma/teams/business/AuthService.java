package com.proyectosigma.teams.business;

import java.util.HashMap;
import java.util.Map;

/**
 * Servicio de autenticación con "BD" en memoria.
 * Usuarios demo y roles: ADMIN, MEDIO, VISOR (básico).
 */
public class AuthService {

    private final Map<String, String> users = new HashMap<>();
    private final Map<String, String> roles = new HashMap<>();

    public AuthService() {
        users.put("admin", "admin123");
        roles.put("admin", "ADMIN");

        users.put("analista", "analista123");
        roles.put("analista", "MEDIO");

        users.put("visor", "visor123");
        roles.put("visor", "VISOR");
    }

    public boolean authenticate(String username, String password) {
        if (username == null || password == null) return false;
        String key = username.trim().toLowerCase();
        String stored = users.get(key);
        return stored != null && stored.equals(password);
    }

    public String getRole(String username) {
        if (username == null) return "VISOR";
        String r = roles.get(username.trim().toLowerCase());
        return r != null ? r : "VISOR";
    }
}