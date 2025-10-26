package com.proyectosigma.teams.model;
public class Pairing {
  private final String teamA; private final String teamB;
  public Pairing(String teamA, String teamB){ this.teamA=teamA; this.teamB=teamB; }
  public String getTeamA(){ return teamA; } public String getTeamB(){ return teamB; }
}