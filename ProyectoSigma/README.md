# ProyectoSigma

Aplicación web Java clásica (Servlet + JSP + Maven) para gestionar equipos de League of Legends,
generar emparejamientos y simular resultados **BO3**. Incluye preset de equipos y exportación a CSV.

## Requisitos
- JDK 8+
- Maven 3+
- Tomcat 9+

## Compilar
```bash
mvn clean package
```
Genera `target/ProyectoSigma.war`.

## Desplegar
- Copia el WAR a `TOMCAT_HOME/webapps/` y arranca Tomcat, o
- Usa la extensión **Tomcat for Java** en VS Code → *Add Webapp…*

## URL
```
http://localhost:8080/ProyectoSigma/
```

## Funcionalidades
- Añadir equipos (evita duplicados).
- Cargar **preset LoL** (T1, G2, Fnatic, Gen.G, etc.).
- Elegir tipo de clasificación (simple, eliminación directa, doble *simulada*).
- Simular **BO3** por emparejamiento (resultado 2-0 / 2-1).
- **Exportar CSV** con los últimos resultados simulados.

## Estructura
- `business/TeamService.java`: lógica de negocio, pairing, BO3 y CSV.
- `model/*`: `Pairing`, `MatchResult`, `TournamentType`.
- `web/TeamServlet.java`: controlador; maneja acciones y pasa datos a `index.jsp`.
- `index.jsp`: interfaz Bootstrap.
