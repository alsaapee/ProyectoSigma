<%-- src/main/webapp/index.jsp --%>
  <%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <% String usuario=(String) session.getAttribute("usuario"); String rol=(String) session.getAttribute("rol"); if
      (rol==null) rol="VISOR" ; java.util.List<String> teams = (java.util.List<String>) session.getAttribute("equipos");
        if (teams == null) {
        teams = new java.util.ArrayList<>();
          session.setAttribute("equipos", teams);
          }

          RankingService ranking = (RankingService) session.getAttribute("ranking");
          if (ranking == null) {
          ranking = new RankingService();
          session.setAttribute("ranking", ranking);
          }


          java.util.List<com.proyectosigma.teams.model.Pairing> pairings =
            (java.util.List<com.proyectosigma.teams.model.Pairing>) request.getAttribute("pairings");
              java.util.List<com.proyectosigma.teams.model.MatchResult> simulatedResults =
                (java.util.List<com.proyectosigma.teams.model.MatchResult>) request.getAttribute("simulatedResults");
                  String byeTeam = (String) request.getAttribute("byeTeam");
                  com.proyectosigma.teams.model.TournamentType selectedType =
                  (com.proyectosigma.teams.model.TournamentType) request.getAttribute("selectedType");
                  Boolean simulateBo3 = (Boolean) request.getAttribute("simulateBo3");
                  if (simulateBo3 == null) simulateBo3 = Boolean.TRUE;

                  boolean canAdd = "ADMIN".equals(rol) || "MEDIO".equals(rol);
                  boolean canPair = "ADMIN".equals(rol) || "MEDIO".equals(rol);
                  boolean canClear = "ADMIN".equals(rol);
                  boolean canPreset= "ADMIN".equals(rol);
                  boolean canExport= "ADMIN".equals(rol) || "MEDIO".equals(rol);
                  %>


                  <%@ page import="java.util.Map" %>
                    <%@ page import="com.proyectosigma.teams.business.RankingService" %>

                      <!doctype html>
                      <html lang="es" data-bs-theme="dark">

                      <head>
                        <meta charset="UTF-8">
                        <title>ProyectoSigma · Clasificación LoL</title>
                        <meta name="viewport" content="width=device-width, initial-scale=1">
                        <!-- Bootstrap & Icons -->
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                          rel="stylesheet">
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                          rel="stylesheet">
                        <style>
                          body {
                            background: radial-gradient(1600px 950px at 10% -10%, #1e293b 0%, #0f172a 55%);
                            color: #e2e8f0;
                          }

                          .navbar {
                            background: rgba(2, 6, 23, 0.85);
                            border-bottom: 1px solid rgba(148, 163, 184, 0.15);
                            backdrop-filter: blur(6px);
                          }

                          .card {
                            background: rgba(17, 24, 39, 0.85);
                            border: 1px solid rgba(148, 163, 184, 0.15);
                            border-radius: 18px;
                          }

                          .badge-lol {
                            background: #1d4ed8;
                          }

                          .panel-title {
                            letter-spacing: .3px;
                          }

                          .chip {
                            padding: .25rem .6rem;
                            border: 1px solid rgba(148, 163, 184, 0.2);
                            border-radius: 999px;
                          }

                          .disabled-area {
                            pointer-events: none;
                            opacity: .55;
                          }
                        </style>
                      </head>

                      <body>
                        <nav class="navbar navbar-expand-lg sticky-top">
                          <div class="container">
                            <span class="navbar-brand fw-bold">ProyectoSigma</span>
                            <div class="ms-auto d-flex align-items-center gap-3">
                              <span class="chip text-secondary">
                                <i class="bi bi-person-badge"></i>
                                <%= usuario !=null ? usuario : "Invitado" %> · <%= rol %>
                              </span>
                              <a class="btn btn-outline-light btn-sm" href="<%=request.getContextPath()%>/logout">
                                <i class="bi bi-box-arrow-right"></i> Salir
                              </a>
                            </div>
                          </div>
                        </nav>

                        <div class="container py-4">
                          <div class="row g-4">
                            <div class="col-12 col-lg-5">
                              <div class="card mb-3">
                                <div class="card-header panel-title">Gestión de equipos</div>
                                <div class="card-body <%= canAdd ? "" : " disabled-area" %>">
                                  <form action="<%=request.getContextPath()%>/teams" method="post" class="row g-3">
                                    <input type="hidden" name="action" value="add">
                                    <div class="col-12">
                                      <label class="form-label">Nombre del equipo</label>
                                      <input type="text" name="teamName" class="form-control"
                                        placeholder="Ej. G2 Esports">
                                    </div>
                                    <div class="col-12 d-flex gap-2">
                                      <button type="submit" class="btn btn-primary" <%=canAdd ? "" : "disabled" %> >
                                        <i class="bi bi-plus-circle"></i> Añadir
                                      </button>
                                      <button type="submit" class="btn btn-outline-danger"
                                        formaction="<%=request.getContextPath()%>/teams"
                                        onclick="this.form.action=this.form.action;document.querySelector('input[name=action]').value='clear';"
                                        <%=canClear ? "" : "disabled" %>>
                                        <i class="bi bi-trash"></i> Vaciar
                                      </button>
                                    </div>
                                  </form>

                                  <hr class="border-secondary">

                                  <form action="<%=request.getContextPath()%>/teams" method="post" class="row g-3">
                                    <input type="hidden" name="action" value="presetLol">
                                    <div class="col-12 d-grid">
                                      <button type="submit" class="btn btn-secondary" <%=canPreset ? "" : "disabled" %>>
                                        <i class="bi bi-lightning-charge"></i> Cargar preset LoL
                                      </button>
                                    </div>
                                  </form>
                                </div>
                              </div>

                              <div class="card">
                                <div class="card-header panel-title">Configuración del torneo</div>
                                <div class="card-body <%= canPair ? "" : " disabled-area" %>">
                                  <form action="<%=request.getContextPath()%>/teams" method="post" class="row g-3">
                                    <input type="hidden" name="action" value="pair">
                                    <div class="col-12">
                                      <label class="form-label">Tipo de clasificación</label>
                                      <select class="form-select" name="tournamentType" <%=canPair ? "" : "disabled" %>>
                                        <option value="SIMPLE"
                                          <%=(selectedType==com.proyectosigma.teams.model.TournamentType.SIMPLE)?"selected":""
                                          %> >Simple</option>
                                        <option value="ELIMINACION_DIRECTA"
                                          <%=(selectedType==com.proyectosigma.teams.model.TournamentType.ELIMINACION_DIRECTA)?"selected":""
                                          %> >Eliminación directa</option>
                                        <option value="DOBLE"
                                          <%=(selectedType==com.proyectosigma.teams.model.TournamentType.DOBLE)?"selected":""
                                          %> >Doble (simulada)</option>
                                      </select>
                                    </div>
                                    <div class="col-12 form-check">
                                      <input class="form-check-input" type="checkbox" id="simulateBo3"
                                        name="simulateBo3" <%=simulateBo3 ? "checked" : "" %>
                                      <%= canPair ? "" : "disabled" %> >
                                        <label class="form-check-label" for="simulateBo3">Simular BO3 al
                                          emparejar</label>
                                    </div>
                                    <div class="col-12 d-grid">
                                      <button type="submit" class="btn btn-success" <%=(canPair && teams.size()>= 2) ?
                                        "" :
                                        "disabled" %>>
                                        <i class="bi bi-diagram-3"></i> Crear emparejamientos
                                      </button>
                                    </div>
                                  </form>

                                  <div class="mt-3">
                                    <a class="btn btn-outline-info btn-sm <%= canExport ? "" : " disabled" %>"
                                      href="<%= canExport ? (request.getContextPath()+"/teams?action=exportCsv") : "#"
                                        %>">
                                        <i class="bi bi-filetype-csv"></i> Exportar resultados (CSV)
                                    </a>
                                  </div>
                                  <h6 class="mt-4">🏆 Ranking de victorias</h6>
                                  <table class="table table-sm table-dark table-striped">
                                    <tr>
                                      <th>Equipo</th>
                                      <th>Victorias</th>
                                    </tr>
                                    <% for (Map.Entry<String,Integer> e : ranking.topVictorias()) { %>
                                      <tr>
                                        <td>
                                          <%= e.getKey() %>
                                        </td>
                                        <td>
                                          <%= e.getValue() %>
                                        </td>
                                      </tr>
                                      <% } %>
                                  </table>

                                </div>
                              </div>
                            </div>

                            <div class="col-12 col-lg-7">
                              <div class="card mb-3">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                  <span>Equipos (<%= teams.size() %>)</span>
                                  <span class="badge badge-lol">League of Legends</span>
                                </div>
                                <div class="card-body">
                                  <% if (teams.isEmpty()) { %>
                                    <p class="text-secondary mb-0">No hay equipos. Carga el preset o añade alguno.</p>
                                    <% } else { %>
                                      <div class="row row-cols-1 row-cols-md-2 g-2">
                                        <% for (String t : teams) { %>
                                          <div class="col">
                                            <div class="p-2 border rounded-3">
                                              <%= t %>
                                            </div>
                                          </div>
                                          <% } %>
                                      </div>
                                      <% } %>
                                </div>
                              </div>

                              <% if (pairings !=null) { %>
                                <div class="card">
                                  <div class="card-header">Emparejamientos <small class="text-secondary">
                                      (<%= request.getAttribute("selectedType") !=null ?
                                        request.getAttribute("selectedType").toString() : "SIMPLE" %>)
                                    </small></div>
                                  <div class="card-body">
                                    <% if (pairings.isEmpty()) { %>
                                      <p class="text-secondary">No hay suficientes equipos para emparejar.</p>
                                      <% } else { %>
                                        <div class="row row-cols-1 g-3">
                                          <% for (com.proyectosigma.teams.model.Pairing p : pairings) { %>
                                            <div class="col">
                                              <div
                                                class="p-3 border rounded-3 d-flex justify-content-between align-items-center">
                                                <div><strong>
                                                    <%= p.getTeamA() %>
                                                  </strong> vs <strong>
                                                    <%= p.getTeamB() %>
                                                  </strong></div>
                                                <span class="badge bg-primary">BO3</span>
                                              </div>
                                            </div>
                                            <% } %>
                                        </div>
                                        <% } %>

                                          <% if (simulatedResults !=null && !simulatedResults.isEmpty()) { %>
                                            <hr class="border-secondary">
                                            <h6 class="mb-3">Resultados simulados</h6>
                                            <div class="row row-cols-1 g-3">
                                              <% for (com.proyectosigma.teams.model.MatchResult r : simulatedResults) {
                                                %>
                                                <div class="col">
                                                  <div class="p-3 border rounded-3">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                      <div>
                                                        <strong>
                                                          <%= r.getTeamA() %>
                                                        </strong> vs <strong>
                                                          <%= r.getTeamB() %>
                                                        </strong>
                                                        <span class="ms-2 badge bg-success">
                                                          <%= r.getScoreA() %> - <%= r.getScoreB() %>
                                                        </span>
                                                      </div>
                                                      <div><span class="badge bg-info">Ganador: <%= r.getWinner() %>
                                                        </span>
                                                      </div>
                                                    </div>
                                                    <div class="text-secondary small">Formato: BO<%= r.getBestOf() %>
                                                    </div>
                                                  </div>
                                                </div>
                                                <% } %>
                                            </div>
                                            <% } %>

                                              <% if (byeTeam !=null) { %>
                                                <div class="alert alert-info mt-3 mb-0">
                                                  <strong>
                                                    <%= byeTeam %>
                                                  </strong> descansa esta ronda.
                                                </div>
                                                <% } %>
                                  </div>
                                </div>
                                <% } %>
                            </div>
                          </div>
                        </div>
                      </body>

                      </html>