// src/main/java/com/proyectosigma/teams/web/AuthServlet.java
package com.proyectosigma.teams.web;

import com.proyectosigma.teams.business.AuthService;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class AuthServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String path = req.getServletPath();
        if ("/logout".equals(path)) {
            HttpSession ses = req.getSession(false);
            if (ses != null) ses.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String user = trim(req.getParameter("username"));
        String pass = trim(req.getParameter("password"));
        if (authService.authenticate(user, pass)) {
            HttpSession ses = req.getSession(true);
            ses.setAttribute("usuario", user);
            ses.setAttribute("rol", authService.getRole(user)); // ADMIN | MEDIO | VISOR
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        } else {
            req.setAttribute("error", "Usuario o contraseña incorrectos");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    private String trim(String s) { return s == null ? null : s.trim(); }
}
