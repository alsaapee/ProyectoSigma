
git init

# 1) chore
git add pom.xml src/main/webapp/WEB-INF/web.xml
git commit -m "chore: inicializa ProyectoSigma con estructura Maven y Servlet"

# 2) feat: negocio base
git add src/main/java/com/proyectosigma/teams/model/TournamentType.java ^
    src/main/java/com/proyectosigma/teams/model/Pairing.java ^
    src/main/java/com/proyectosigma/teams/business/TeamService.java
git commit -m "feat: añade capa de negocio con presets LoL y pairing básico"

# 3) feat: BO3 y clasificación
git add src/main/java/com/proyectosigma/teams/model/MatchResult.java ^
    src/main/java/com/proyectosigma/teams/web/TeamServlet.java
git commit -m "feat: incorpora simulación BO3 y selector de tipo de clasificación"

# 4) feat: CSV
git commit --allow-empty -m "feat: exportación a CSV de resultados simulados"

# 5) ui
git add src/main/webapp/index.jsp
git commit -m "ui: rediseño Bootstrap (tema oscuro), cards y badges"

# 6) refactor
git commit --allow-empty -m "refactor: nombres claros en español y comentarios"

# 7) docs
git add README.md COMMIT_MESSAGES_ES.txt
git commit -m "docs: README con instrucciones de compilación y despliegue"
