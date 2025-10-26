package com.proyectosigma.teams.business;

import com.proyectosigma.teams.model.MatchResult;
import com.proyectosigma.teams.model.Pairing;
import com.proyectosigma.teams.model.TournamentType;
import java.util.*;

public class TeamService {
  private final Random random = new Random(System.nanoTime());
  public void addTeam(List<String> teams, String teamName){
    if(teamName==null) return; String t=teamName.trim(); if(t.isEmpty()) return;
    boolean exists = teams.stream().anyMatch(s->s.equalsIgnoreCase(t)); if(!exists) teams.add(t);
  }
  public void addLolPreset(List<String> teams){
    List<String> lol = Arrays.asList("T1","G2 Esports","Fnatic","Gen.G","JDG","BLG","Top Esports","DRX","Cloud9","Team Liquid","FlyQuest","MAD Lions","KT Rolster","Hanwha Life","NRG","PSG Talon");
    for(String t: lol) addTeam(teams,t);
  }
  public void clearTeams(List<String> teams){ teams.clear(); }
  public List<String> getTeams(List<String> teams){ return new ArrayList<>(teams); }

  public static class PairingResult{
    private final List<Pairing> pairings; private final String byeTeam; private final List<MatchResult> simulatedResults;
    public PairingResult(List<Pairing> p,String bye,List<MatchResult> r){ this.pairings=p; this.byeTeam=bye; this.simulatedResults=r; }
    public List<Pairing> getPairings(){return pairings;} public String getByeTeam(){return byeTeam;} public List<MatchResult> getSimulatedResults(){return simulatedResults;}
  }

  public PairingResult pairTeams(List<String> teams, TournamentType type, boolean simulateBo3){
    List<String> shuffled = new ArrayList<>(teams); Collections.shuffle(shuffled, random);
    List<Pairing> pairings = new ArrayList<>(); List<MatchResult> results = new ArrayList<>(); String bye=null;
    int i=0,n=shuffled.size(); while(i+1<n){ String a=shuffled.get(i), b=shuffled.get(i+1); pairings.add(new Pairing(a,b)); if(simulateBo3) results.add(simulateBo3(a,b)); i+=2; }
    if(n%2==1) bye=shuffled.get(n-1);
    if(type==TournamentType.DOBLE && results.size()>=2){ MatchResult r1=results.get(0), r2=results.get(1);
      String loser1 = r1.getScoreA()>r1.getScoreB()? r1.getTeamB(): r1.getTeamA();
      String loser2 = r2.getScoreA()>r2.getScoreB()? r2.getTeamB(): r2.getTeamA();
      if(loser1!=null && loser2!=null) results.add(simulateBo3(loser1,loser2));
    }
    return new PairingResult(pairings, bye, results);
  }

  public MatchResult simulateBo3(String a,String b){
    int wa=0, wb=0; while(wa<2 && wb<2){ if(random.nextBoolean()) wa++; else wb++; }
    String winner = wa>wb? a:b; return new MatchResult(a,b,wa,wb,3,winner);
  }

  public String toCsv(List<MatchResult> results){
    StringBuilder sb = new StringBuilder("EquipoA,EquipoB,Marcador,Formato,Ganador\n");
    for(MatchResult r: results) sb.append(r.toCsv()).append("\n");
    return sb.toString();
  }
}
