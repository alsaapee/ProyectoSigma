// src/main/java/com/proyectosigma/teams/web/AuthFilter.java
package com.proyectosigma.teams.web;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class AuthFilter implements Filter {

    private static final Set<String> PUBLIC_PATHS = new HashSet<>(Arrays.asList(
            "/login", "/logout", "/favicon.ico"
    ));

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String ctx = req.getContextPath();
        String path = req.getRequestURI().substring(ctx.length());

        // Permite login/logout y raíz (para que el TeamServlet reenvíe a index.jsp)
        if (isPublic(path) || "/".equals(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession ses = req.getSession(false);
        if (ses != null && ses.getAttribute("usuario") != null) {
            chain.doFilter(request, response);
        } else {
            resp.sendRedirect(ctx + "/login");
        }
    }

    private boolean isPublic(String path) {
        if (path == null) return false;
        for (String p : PUBLIC_PATHS) {
            if (path.equals(p) || path.startsWith(p)) return true;
        }
        return false;
    }
}
