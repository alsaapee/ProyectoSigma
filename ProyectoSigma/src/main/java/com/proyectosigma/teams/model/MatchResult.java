package com.proyectosigma.teams.model;
public class MatchResult {
  private final String teamA, teamB; private final int scoreA, scoreB, bestOf; private final String winner;
  public MatchResult(String teamA,String teamB,int scoreA,int scoreB,int bestOf,String winner){
    this.teamA=teamA; this.teamB=teamB; this.scoreA=scoreA; this.scoreB=scoreB; this.bestOf=bestOf; this.winner=winner;
  }
  public String getTeamA(){return teamA;} public String getTeamB(){return teamB;}
  public int getScoreA(){return scoreA;} public int getScoreB(){return scoreB;}
  public int getBestOf(){return bestOf;} public String getWinner(){return winner;}
  public String toCsv(){ return String.format("%s,%s,%d-%d,BO%d,%s",teamA,teamB,scoreA,scoreB,bestOf,winner); }
}