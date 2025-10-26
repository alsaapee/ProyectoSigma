# 📘 ProyectoSigma

Aplicación web desarrollada en **Java** para la gestión y simulación de torneos de **League of Legends**, con autenticación de usuarios, emparejamientos automáticos, simulaciones BO3 y ranking dinámico de victorias.

---

## 🚀 Descripción general

**ProyectoSigma** permite añadir equipos, generar torneos con diferentes tipos de clasificación y simular partidas automáticamente.  
El sistema incluye un login con roles de usuario simulados, un ranking de victorias y exportación de resultados a CSV.

El proyecto está construido bajo el patrón **MVC (Modelo - Vista - Controlador)**, separando la lógica de negocio, las vistas JSP y los controladores servlet.

---

## ⚙️ Tecnologías utilizadas

- ☕ **Java 17**
- 🧩 **Apache Maven**
- 🌐 **JSP / Servlets**
- 🐱 **Apache Tomcat 9 (WebApp Runner embebido)**
- 🎨 **Bootstrap 5**
- 💻 **HTML5 / CSS3**

---

## 🧠 Arquitectura del proyecto

| Capa | Descripción | Ejemplos |
|------|--------------|-----------|
| **Model** | Entidades y estructuras de datos | `Pairing`, `MatchResult`, `TournamentType` |
| **Business** | Lógica de negocio y servicios | `TeamService`, `RankingService`, `AuthService` |
| **Web** | Controladores y filtros | `TeamServlet`, `AuthServlet`, `AuthFilter` |
| **Webapp (Vistas)** | Interfaz JSP + Bootstrap | `index.jsp`, `login.jsp` |

---

## 🧩 Funcionalidades principales

- 🔐 **Login y roles simulados** (admin, analista, visor)
- 🧾 **Gestión de equipos**: alta manual o carga automática del preset de LoL
- ⚔️ **Simulación de torneos** con distintos tipos de clasificación:
  - Simple
  - Eliminación directa
  - Doble eliminación (simulada)
- 🎮 **Partidas BO3 (Best of 3)** con resultados automáticos
- 🏆 **Ranking dinámico** de victorias por equipo
- 📤 **Exportación de resultados** en formato CSV
- 🎨 **Interfaz moderna** con Bootstrap 5 y tema oscuro responsive

---

## 🛠️ Instalación y ejecución local

### 🔧 Requisitos previos
- JDK 17 o superior  
- Apache Maven 3.9+  
- Apache Tomcat 9 (o WebApp Runner)

### 🏗️ Compilar el proyecto
```bash
mvn clean package
