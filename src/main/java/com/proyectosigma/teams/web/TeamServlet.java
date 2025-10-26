// src/main/java/com/proyectosigma/teams/web/TeamServlet.java
package com.proyectosigma.teams.web;

import com.proyectosigma.teams.business.TeamService;
import com.proyectosigma.teams.model.MatchResult;
import com.proyectosigma.teams.model.TournamentType;
import com.proyectosigma.teams.business.RankingService;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class TeamServlet extends HttpServlet {

  private static final String SESSION_TEAMS = "equipos";
  private static final String SESSION_RESULTS = "resultados";

  private static final String ATTR_PAIRINGS = "pairings";
  private static final String ATTR_BYE = "byeTeam";
  private static final String ATTR_RESULTS = "simulatedResults";
  private static final String ATTR_TYPE = "selectedType";
  private static final String ATTR_SIMULATE = "simulateBo3";
  private static final String SESSION_RANKING = "ranking";

  private final TeamService service = new TeamService();

  @SuppressWarnings("unchecked")
  private List<String> getOrInitTeams(HttpSession session) {
    Object obj = session.getAttribute(SESSION_TEAMS);
    if (obj == null) {
      List<String> list = new ArrayList<>();
      session.setAttribute(SESSION_TEAMS, list);
      return list;
    }
    return (List<String>) obj;
  }

  @SuppressWarnings("unchecked")
  private List<MatchResult> getOrInitResults(HttpSession session) {
    Object obj = session.getAttribute(SESSION_RESULTS);
    if (obj == null) {
      List<MatchResult> list = new ArrayList<>();
      session.setAttribute(SESSION_RESULTS, list);
      return list;
    }
    return (List<MatchResult>) obj;
  }

  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws IOException, ServletException {

    String action = req.getParameter("action");
    if ("exportCsv".equalsIgnoreCase(action)) {
      // Permisos: ADMIN y MEDIO pueden exportar
      HttpSession ses = req.getSession(false);
      String rol = ses != null ? (String) ses.getAttribute("rol") : null;
      if (!"ADMIN".equals(rol) && !"MEDIO".equals(rol)) {
        resp.sendError(HttpServletResponse.SC_FORBIDDEN);
        return;
      }
      List<MatchResult> results = getOrInitResults(req.getSession(true));
      String csv = service.toCsv(results);
      byte[] bytes = csv.getBytes(StandardCharsets.UTF_8);

      resp.setContentType("text/csv; charset=UTF-8");
      resp.setHeader("Content-Disposition", "attachment; filename=\"resultados_proyecto_sigma.csv\"");
      resp.setContentLength(bytes.length);
      resp.getOutputStream().write(bytes);
      return;
    }

    req.getRequestDispatcher("/index.jsp").forward(req, resp);
  }

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws IOException, ServletException {

    req.setCharacterEncoding("UTF-8");
    HttpSession session = req.getSession(true);
    List<String> teams = getOrInitTeams(session);
    List<MatchResult> storedResults = getOrInitResults(session);
    String rol = (String) session.getAttribute("rol"); // ADMIN | MEDIO | VISOR

    String action = req.getParameter("action");
    if (action == null)
      action = "add";

    switch (action) {
      case "add":
        // ADMIN y MEDIO pueden añadir; VISOR no.
        if ("VISOR".equals(rol)) {
          resp.sendError(HttpServletResponse.SC_FORBIDDEN);
          return;
        }
        service.addTeam(teams, req.getParameter("teamName"));
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
        return;

      case "presetLol":
        // Solo ADMIN
        if (!"ADMIN".equals(rol)) {
          resp.sendError(HttpServletResponse.SC_FORBIDDEN);
          return;
        }
        service.addLolPreset(teams);
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
        return;

      case "clear":
        // Solo ADMIN
        if (!"ADMIN".equals(rol)) {
          resp.sendError(HttpServletResponse.SC_FORBIDDEN);
          return;
        }
        service.clearTeams(teams);
        storedResults.clear();
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
        return;

      case "pair": {
        String typeStr = req.getParameter("tournamentType");
        String simulateStr = req.getParameter("simulateBo3");
        TournamentType type = parseType(typeStr);
        boolean simulate = "on".equalsIgnoreCase(simulateStr) || "true".equalsIgnoreCase(simulateStr);

        TeamService.PairingResult result = service.pairTeams(teams, type, simulate);

        // >>> NUEVO: actualizar ranking con los ganadores simulados
        RankingService ranking = getOrInitRanking(session);
        for (MatchResult mr : result.getSimulatedResults()) {
          ranking.registrarVictorias(mr.getWinner());
        }

        req.setAttribute(ATTR_PAIRINGS, result.getPairings());
        req.setAttribute(ATTR_BYE, result.getByeTeam());
        req.setAttribute(ATTR_RESULTS, result.getSimulatedResults());
        req.setAttribute(ATTR_TYPE, type);
        req.setAttribute(ATTR_SIMULATE, simulate);

        // Persistimos últimos resultados por si exportan a CSV
        storedResults.clear();
        storedResults.addAll(result.getSimulatedResults());

        // >>> OPCIONAL: exponer ranking al request (no imprescindible si lo coges de
        // sesión en el JSP)
        req.setAttribute("ranking", ranking);

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
        return;
      }

      default:
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }
  }

  private TournamentType parseType(String typeStr) {
    if (typeStr == null)
      return TournamentType.SIMPLE;
    try {
      return TournamentType.valueOf(typeStr);
    } catch (IllegalArgumentException e) {
      return TournamentType.SIMPLE;
    }
  }

  private RankingService getOrInitRanking(HttpSession session) {
    Object obj = session.getAttribute(SESSION_RANKING);
    if (obj == null) {
      RankingService r = new RankingService();
      session.setAttribute(SESSION_RANKING, r);
      return r;
    }
    return (RankingService) obj;
  }

}
