package com.proyectosigma.teams.business;

import java.util.*;

public class RankingService {
    private final Map<String, Integer> victorias = new HashMap<>();

    
    public void registrarVictorias(String ganador) {
        if (ganador == null || ganador.trim().isEmpty()) return;
        String g = ganador.trim();
        victorias.put(g, victorias.getOrDefault(g, 0) + 1);
    }

    
    public List<Map.Entry<String, Integer>> topVictorias() {
        List<Map.Entry<String, Integer>> lista = new ArrayList<>(victorias.entrySet());
        lista.sort((a, b) -> b.getValue().compareTo(a.getValue()));
        return lista;
    }

    public boolean isEmpty() {
        return victorias.isEmpty();
    }

    public void reiniciar() {
        victorias.clear();
    }
}
