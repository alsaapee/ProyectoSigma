<%-- src/main/webapp/login.jsp (si lo necesitas) --%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
  String error = (String) request.getAttribute("error");
%>
<!doctype html>
<html lang="es" data-bs-theme="dark">
<head>
  <meta charset="UTF-8">
  <title>ProyectoSigma · Acceder</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      min-height: 100vh;
      background: radial-gradient(1200px 800px at 20% -10%, #1e293b 0%, #0f172a 60%);
      color: #e2e8f0; display: grid; place-items: center; padding: 2rem;
    }
    .card { background: rgba(17, 24, 39, 0.85); border: 1px solid rgba(148,163,184,0.15); backdrop-filter: blur(6px); border-radius: 18px; }
    .brand { font-weight: 800; letter-spacing: .5px; text-shadow: 0 0 18px rgba(59,130,246,0.35); }
  </style>
</head>
<body>
  <div class="container" style="max-width: 440px;">
    <div class="text-center mb-4">
      <div class="brand fs-2">ProyectoSigma</div>
      <div class="text-secondary">Clasificación LoL · Acceso</div>
    </div>

    <div class="card shadow-lg">
      <div class="card-body p-4">
        <% if (error != null) { %>
          <div class="alert alert-danger mb-3"><%= error %></div>
        <% } %>
        <form action="<%=request.getContextPath()%>/login" method="post" class="vstack gap-3">
          <div>
            <label class="form-label">Usuario</label>
            <input type="text" name="username" class="form-control" placeholder="admin" required>
          </div>
          <div>
            <label class="form-label">Contraseña</label>
            <input type="password" name="password" class="form-control" placeholder="••••••••" required>
          </div>
          <button class="btn btn-primary w-100 py-2">Entrar</button>
        </form>
        <div class="text-secondary small mt-3">
          Demo: <code>admin/admin123</code>, <code>analista/analista123</code>, <code>visor/visor123</code>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
