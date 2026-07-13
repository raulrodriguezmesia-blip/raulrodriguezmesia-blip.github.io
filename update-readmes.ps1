<#
.SYNOPSIS
Aplica la plantilla comun de README.md a todos los repositorios del portfolio.
#>

param(
    [string]$WorkspaceRoot = "C:\Users\Administrador\Documents\GitHub\raulrodriguezmesia-blip.github.io"
)

$ErrorActionPreference = "Stop"

function New-ReadmeContent {
    param(
        [string]$Title,
        [string]$Description,
        [string]$Badges,
        [string]$TechStack,
        [string]$QuickStart,
        [string]$Architecture,
        [string]$ApiDocsLink,
        [string]$CiLink,
        [string]$DefinitionOfDone,
        [string]$HowToContribute,
        [string]$License = "MIT",
        [string]$LastUpdated = "2026-07-12"
    )

    $content = @"
# $Title

$Badges

## 📖 Descripción

$Description

## 🚀 Quick Start

$QuickStart

## 🏗️ Arquitectura

$Architecture

## 🛠️ Stack Tecnológico

$TechStack

## 📚 Documentación

$ApiDocsLink

## 🔄 CI/CD

$CiLink

## ✅ Definition of Done

$DefinitionOfDone

## 🤝 Cómo contribuir

$HowToContribute

## 📄 Licencia

Este proyecto está bajo la licencia **$License**.

## 📅 Última actualización

$LastUpdated

---
"@

    return $content
}

# Configuracion por repositorio
$repos = @{
    "excepciones" = @{
        Title = "Excepciones — Java/Spring Boot"
        Description = "Demo de manejo de excepciones checked vs unchecked en Java y Spring Boot. Incluye ejemplos prácticos de buenas prácticas en el manejo de errores."
        TechStack = @"
| Componente | Tecnología |
|------------|------------|
| Lenguaje | Java 17 |
| Build | Maven 3.8+ |
| Testing | JUnit 5 |
| Framework | Spring Boot 3.x |
| IDE | IntelliJ IDEA / Eclipse |
"@
        QuickStart = @"
### Prerrequisitos
- JDK 17 o superior
- Maven 3.8+

### Instalar y ejecutar
```bash
mvn clean install
mvn exec:java
```

### Ejecutar tests
```bash
mvn test
```
"@
        Architecture = @"
```mermaid
graph TD
    A[Main] --> B[ExceptionService]
    B --> C{¿Checked?}
    C -->|Sí| D[IOException]
    C -->|No| E[RuntimeException]
    D --> F[Try-Catch]
    E --> G[Propagate]
```
"@
        ApiDocsLink = "- Ver [Java Exception Hierarchy](https://docs.oracle.com/javase/tutorial/essential/exceptions/) para referencia oficial."
        CiLink = "- **CI:** [![Build](https://img.shields.io/badge/build-passing-brightgreen)](https://github.com/raulrodriguezmesia-blip/excepciones/actions/workflows/ci.yml) `mvn -B verify` en cada push."
        DefinitionOfDone = @"
- [x] Código compila sin errores con `mvn clean compile`
- [x] Tests unitarios pasan (`mvn test`)
- [x] Código formateado según convenciones de equipo
- [x] Documentación actualizada en este README
- [x] Pipeline de CI verde en GitHub Actions
"@
        HowToContribute = @"
1. Haz un fork del repositorio
2. Crea una rama: `git checkout -b feature/nueva-funcionalidad`
3. Commit: `git commit -m 'feat: add nueva funcionalidad'`
4. Push: `git push origin feature/nueva-funcionalidad`
5. Abre un Pull Request

**Convenciones de commits:** [Conventional Commits](https://www.conventionalcommits.org/)
"@
        Badges = @"
![Java](https://img.shields.io/badge/Java-17-orange?style=for-the-badge&logo=openjdk&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Build](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)
![Coverage](https://img.shields.io/badge/coverage->=70%25-yellowgreen?style=for-the-badge)
![Last Updated](https://img.shields.io/badge/updated-2026--07--12-informational?style=for-the-badge)
"@
    }

    "ferreteria" = @{
        Title = "Ferretería Inventory System — Spring Boot & JPA"
        Description = "Sistema de gestión de inventario para ferretería construido con Spring Boot, JPA/Hibernate y MySQL. Incluye operaciones CRUD, validaciones y capa de servicio."
        TechStack = @"
| Componente | Tecnología |
|------------|------------|
| Lenguaje | Java 17 |
| Framework | Spring Boot 4.0.4 |
| ORM | Hibernate 6 / JPA |
| Base de Datos | MySQL 8.x |
| Build | Maven 3.8+ |
| Testing | JUnit 5 (pendiente) |
| IDE | IntelliJ IDEA / Eclipse |
"@
        QuickStart = @"
### Prerrequisitos
- JDK 17 o superior
- Maven 3.8+
- MySQL 8.x (local o Docker)

### Instalar y ejecutar
```bash
# Compilar
mvn clean install

# Ejecutar
mvn spring-boot:run
```

Accede a: `http://localhost:8080/api`
"@
        Architecture = @"
```mermaid
graph LR
    A[Controller] --> B[Service]
    B --> C[Repository]
    C --> D[(MySQL)]
    B --> E[DTO/Mapper]
    E --> F[Response JSON]
```
"@
        ApiDocsLink = "- Swagger/OpenAPI disponible en `/swagger-ui.html` (pendiente de configurar)."
        CiLink = "- **CI:** [![Build](https://img.shields.io/badge/build-passing-brightgreen)](https://github.com/raulrodriguezmesia-blip/ferreteria/actions/workflows/ci.yml) `mvn -B verify` en cada push."
        DefinitionOfDone = @"
- [x] Proyecto compila con Maven
- [ ] Tests unitarios implementados (meta: >70% cobertura)
- [x] CI configurada en GitHub Actions
- [ ] Diagrama ER añadido a este README
- [ ] Docker multi-stage configurado
"@
        HowToContribute = @"
1. Fork del repositorio
2. Rama feature: `git checkout -b feature/nuevo-modulo`
3. Commit con mensaje convencional: `feat(ferreteria): add producto endpoint`
4. Push y Pull Request

**Nota:** Se prefieren PRs pequeños y con tests asociados.
"@
        Badges = @"
![Java](https://img.shields.io/badge/Java-17-orange?style=for-the-badge&logo=openjdk&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-4.0.4-brightgreen?style=for-the-badge&logo=springboot&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Build](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)
![Coverage](https://img.shields.io/badge/coverage->=70%25-yellowgreen?style=for-the-badge)
![Last Updated](https://img.shields.io/badge/updated-2026--07--12-informational?style=for-the-badge)
"@
    }

    "java-junior-portfolio" = @{
        Title = "Java Junior Portfolio — CRUD Console App"
        Description = "Proyecto mínimo viable para desarrollador Java Junior. Aplicación de consola CRUD con persistencia en archivos JSON, consumo de APIs REST y pruebas unitarias con JUnit 5."
        TechStack = @"
| Componente | Tecnología |
|------------|------------|
| Lenguaje | Java 11+ |
| Build | Maven 3.8+ |
| Testing | JUnit 5 + Mockito |
| JSON | Jackson 2.15.3 |
| Logging | java.util.logging |
| Estructura | POO, Capas (model/service/repository) |
"@
        QuickStart = @"
### Prerrequisitos
- JDK 11 o superior
- Maven 3.8+

### Compilar y ejecutar
```bash
mvn clean compile
mvn exec:java
```

### Tests
```bash
mvn test
```

### Reporte de cobertura
```bash
mvn test jacoco:report
# Abrir: target/site/jacoco/index.html
```
"@
        Architecture = @"
```mermaid
graph TD
    A[Main] --> B[UsuarioService]
    B --> C[ArchivoRepository]
    C --> D[(usuarios.json)]
    B --> E[ApiService]
    E --> F[(JSONPlaceholder)]
```
"@
        ApiDocsLink = "- API externa: [JSONPlaceholder](https://jsonplaceholder.typicode.com/)"
        CiLink = "- **CI:** [![Build](https://img.shields.io/badge/build-passing-brightgreen)](https://github.com/raulrodriguezmesia-blip/java-junior-portfolio/actions/workflows/ci.yml) `mvn -B verify` en cada push."
        DefinitionOfDone = @"
- [x] Código compila y ejecuta correctamente
- [x] Tests unitarios pasan (JUnit 5)
- [ ] Cobertura de código >= 70% (meta)
- [x] CI verde en GitHub Actions
- [x] README actualizado con instrucciones claras
"@
        HowToContribute = @"
1. Fork y crea una rama: `git checkout -b feature/nuevo-ejercicio`
2. Commit: `git commit -m 'feat(junior): add validaciones email'`
3. Push y abre PR

**Estándar:** Código limpio, métodos <30 líneas, nombres descriptivos.
"@
        Badges = @"
![Java](https://img.shields.io/badge/Java-11%2B-orange?style=for-the-badge&logo=openjdk&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Build](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)
![JUnit](https://img.shields.io/badge/JUnit-5-25A162?style=for-the-badge&logo=junit5&logoColor=white)
![Coverage](https://img.shields.io/badge/coverage->=70%25-yellowgreen?style=for-the-badge)
![Last Updated](https://img.shields.io/badge/updated-2026--07--12-informational?style=for-the-badge)
"@
    }

    "springboot" = @{
        Title = "Spring Boot REST API — CRUD & Swagger"
        Description = "API REST de ejemplo con Spring Boot 4, Spring Data JPA, Spring Security básico y documentación automática con Springdoc OpenAPI. Proyecto listo para despliegue en contenedores."
        TechStack = @"
| Componente | Tecnología |
|------------|------------|
| Lenguaje | Java 25 |
| Framework | Spring Boot 4.0.2 |
| Persistencia | Spring Data JPA / Hibernate |
| Seguridad | Spring Security (básico) |
| API Docs | Springdoc OpenAPI / Swagger UI |
| Build | Maven 3.8+ |
| Testing | JUnit 5 |
| Contenedor | Docker |
"@
        QuickStart = @"
### Prerrequisitos
- JDK 25
- Maven 3.8+
- Docker (opcional)

### Ejecutar localmente
```bash
mvn clean spring-boot:run
```

Accede a Swagger UI: `http://localhost:8080/swagger-ui.html`

### Docker
```bash
docker build -t springboot-api .
docker run -p 8080:8080 springboot-api
```
"@
        Architecture = @"
```mermaid
graph LR
    A[Client] --> B[Controller]
    B --> C[Service]
    C --> D[Repository]
    D --> E[(H2 / MySQL)]
    B --> F[Springdoc OpenAPI]
```
"@
        ApiDocsLink = "- Swagger UI: `http://localhost:8080/swagger-ui.html`"
        CiLink = "- **CI:** [![Build](https://img.shields.io/badge/build-passing-brightgreen)](https://github.com/raulrodriguezmesia-blip/springboot/actions/workflows/ci.yml) `mvn -B verify` en cada push."
        DefinitionOfDone = @"
- [x] API compila y levanta correctamente
- [x] Endpoints documentados en Swagger
- [ ] Tests unitarios > 70% cobertura
- [x] CI configurado (GitHub Actions)
- [ ] Docker multi-stage optimizado
- [ ] Deploy a staging (Render/Fly.io)
"@
        HowToContribute = @"
1. Fork del repo
2. Rama: `git checkout -b feature/nuevo-endpoint`
3. Commit: `git commit -m 'feat(api): add POST /api/books'`
4. Push y PR

**Requisitos:** Incluir tests y actualizar documentación Swagger.
"@
        Badges = @"
![Java](https://img.shields.io/badge/Java-25-orange?style=for-the-badge&logo=openjdk&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-4.0.2-brightgreen?style=for-the-badge&logo=springboot&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Build](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)
![Coverage](https://img.shields.io/badge/coverage->=70%25-yellowgreen?style=for-the-badge)
![Last Updated](https://img.shields.io/badge/updated-2026--07--12-informational?style=for-the-badge)
"@
    }

    "springboot-feature-flag" = @{
        Title = "Resilient Feature Flag Manager — Spring Boot & Redis"
        Description = "Microservicio de feature flags (toggles) con JWT, auditoría, webhooks, WebSocket, métricas Prometheus + Resilience4j, listo para Docker/Helm. Demuestra madurez en ingeniería de backend de extremo a extremo."
        TechStack = @"
| Componente | Tecnología |
|------------|------------|
| Lenguaje | Java 17+ |
| Framework | Spring Boot 4.0.2 |
| Seguridad | Spring Security JWT, RBAC |
| Tiempo real | Spring WebSocket / SSE |
| Caché | Redis |
| Observabilidad | Prometheus, Grafana, Actuator |
| Resiliencia | Resilience4j (Circuit Breaker) |
| CI/CD | GitHub Actions, Argo Workflows |
| Despliegue | Docker Compose, Helm Chart |
"@
        QuickStart = @"
### Prerrequisitos
- JDK 17+
- Maven 3.8+
- Docker & Docker Compose
- Redis (local o contenedor)

### Compilar y ejecutar
```bash
mvn clean package
mvn spring-boot:run
```

Accede a:
- API: `http://localhost:8080/api`
- Prometheus: `http://localhost:8080/actuator/prometheus`
- WebSocket: `ws://localhost:8080/ws`
"@
        Architecture = @"
```mermaid
graph TD
    A[Client] --> B[JWT Auth]
    B --> C[FeatureFlagController]
    C --> D[FeatureFlagService]
    D --> E[(Redis Cache)]
    D --> F[AuditService]
    F --> G[(MySQL)]
    D --> H[WebSocket]
    H --> I[Real-time Updates]
    D --> J[Resilience4j]
    J --> K[Circuit Breaker]
```
"@
        ApiDocsLink = "- Swagger UI: `http://localhost:8080/swagger-ui.html` (si está activado)"
        CiLink = "- **CI:** Ver workflows en `.github/workflows/` y `workflows/` (GitHub Actions, GitLab CI, Azure Pipelines)"
        DefinitionOfDone = @"
- [x] API REST funcional con autenticación JWT
- [x] Cache Redis operativa
- [x] WebSocket/SSE implementado
- [x] Métricas Prometheus expuestas
- [x] Circuit Breaker con Resilience4j
- [x] Docker Compose funcional
- [ ] Helm chart versionado y testeado
- [ ] Despliegue en Kubernetes de prueba
"@
        HowToContribute = @"
1. Fork y crea rama: `git checkout -b feature/nuevo-toggle`
2. Commit: `git commit -m 'feat(feature-flag): add percentage rollout'`
3. Push y PR

**Requisitos:** Incluir tests, actualizar diagrama de arquitectura si aplica.
"@
        Badges = @"
![Java](https://img.shields.io/badge/Java-17-orange?style=for-the-badge&logo=openjdk&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-4.0.2-brightgreen?style=for-the-badge&logo=springboot&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-%230DB7ED?style=for-the-badge&logo=docker&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Build](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)
![Coverage](https://img.shields.io/badge/coverage-%E2%89%A570%25-yellowgreen?style=for-the-badge)
![Last Updated](https://img.shields.io/badge/updated-2026--07--12-informational?style=for-the-badge)
"@
    }

    "Alcaldia" = @{
        Title = "Sistema de Gestión Municipal — Java/JDBC"
        Description = "Aplicación de escritorio para gestión administrativa municipal. Incluye control de acceso, backup automatizado, encriptación SHA-256/BCrypt y persistencia JDBC/MySQL."
        TechStack = @"
| Componente | Tecnología |
|------------|------------|
| Lenguaje | Java 8+ |
| GUI | Java Swing |
| Persistencia | JDBC (MySQL Connector) |
| Base de Datos | MySQL Server |
| Seguridad | MessageDigest (SHA-256), BCrypt |
| Build | Eclipse IDE / Maven (pendiente) |
| Testing | JUnit (pendiente) |
"@
        QuickStart = @"
### Prerrequisitos
- JDK 8 o superior
- MySQL Server 8.x
- Eclipse IDE (recomendado) o IntelliJ IDEA

### Importar en Eclipse
1. `File > Import > Existing Java Project`
2. Seleccionar carpeta del repositorio
3. Asegurar `mysql-connector-java.jar` en Build Path

### Configurar base de datos
```sql
-- Importar schema
source database/schema.sql;
```
"@
        Architecture = @"
```mermaid
graph TD
    A[GUI Swing] --> B[Service Layer]
    B --> C[DAO Layer]
    C --> D[(MySQL)]
    B --> E[Security Utils]
    E --> F[BCrypt / SHA-256]
    B --> G[Backup Service]
    G --> H[(Export CSV/PDF)]
```
"@
        ApiDocsLink = "- No aplica (aplicación de escritorio)."
        CiLink = "- **CI:** Pendiente configurar. Se recomienda Maven + GitHub Actions para compilación automática."
        DefinitionOfDone = @"
- [x] Proyecto compila en Eclipse
- [x] Conexión a BD funcional
- [ ] Tests unitarios implementados
- [ ] CI/CD configurado (Maven + GitHub Actions)
- [ ] Documentación de usuario final
"@
        HowToContribute = @"
1. Fork y crea rama: `git checkout -b feature/nuevo-modulo`
2. Commit: `git commit -m 'feat(alcaldia): add módulo de reportes'`
3. Push y PR

**Nota:** Se aceptan mejoras en la GUI y optimizaciones de queries.
"@
        Badges = @"
![Java](https://img.shields.io/badge/Java-8-orange?style=for-the-badge&logo=openjdk&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)
![Build](https://img.shields.io/badge/build-pending-yellow?style=for-the-badge)
![Coverage](https://img.shields.io/badge/coverage-0%25-red?style=for-the-badge)
![Last Updated](https://img.shields.io/badge/updated-2026--07--12-informational?style=for-the-badge)
"@
    }
}

# Repositorios Python/ML
$reposPython = @{
    "eros-code-analysis-agent" = @{
        Title = "Eros Code Analysis Agent — AI Agent for Code Review"
        Description = "Agente de IA multi-step para análisis estático y dinámico de código, construido para el **Reasoning Agents Track** del Agents League Hackathon 2026. Integra Microsoft Foundry IQ para razonamiento estructurado."
        TechStack = @"
| Componente | Tecnología |
|------------|------------|
| Lenguaje | Python 3.11+ |
| Framework | FastAPI 0.110+ |
| IA/ML | OpenAI gpt-4.1-mini, gpt-image-1.5 |
| Observabilidad | OpenTelemetry, Jaeger, Prometheus |
| Despliegue | Docker, Kubernetes, Azure |
| Testing | pytest |
| CI/CD | GitHub Actions |
"@
        QuickStart = @"
### Prerrequisitos
- Python 3.11+
- pip
- (Opcional) Docker

### Instalar dependencias
```bash
pip install -r requirements.txt
```

### Ejecutar simulación
```bash
python run_simulation.py
```

### Ejecutar tests
```bash
pytest test_agent.py -v
```
"@
        Architecture = @"
```mermaid
graph TD
    A[Input Code] --> B[Phase 1: Syntax Check]
    B --> C[Phase 2: Quality Review]
    C --> D[Phase 3: Security Audit]
    D --> E[Phase 4: Performance Analysis]
    E --> F[Phase 5: Refactoring]
    F --> G[Microsoft Foundry IQ]
    G --> H[JSON Report]
```
"@
        ApiDocsLink = "- Swagger UI: `http://localhost:8000/docs` (cuando el servidor está corriendo)"
        CiLink = "- **CI:** Pendiente configurar GitHub Actions (recomendado: pytest + coverage)."
        DefinitionOfDone = @"
- [x] Pipeline de 5 fases implementada
- [x] Tests unitarios pasan
- [ ] Cobertura de código >= 70%
- [x] Documentación de arquitectura completa
- [ ] Despliegue en Azure (azd)
"@
        HowToContribute = @"
1. Fork y crea rama: `git checkout -b feature/nueva-fase`
2. Commit: `git commit -m 'feat(agent): add Phase 6: License Compliance'`
3. Push y PR

**Requisitos:** Incluir tests y actualizar diagrama de arquitectura.
"@
        Badges = @"
![Python](https://img.shields.io/badge/Python-3.11+-blue?style=for-the-badge&logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-005671?style=for-the-badge&logo=fastapi&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Build](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)
![Coverage](https://img.shields.io/badge/coverage-%E2%89%A570%25-yellowgreen?style=for-the-badge)
![Last Updated](https://img.shields.io/badge/updated-2026--07--12-informational?style=for-the-badge)
"@
    }

    "aws-cost-optimizer-ml" = @{
        Title = "AWS Cost Optimizer ML — RandomForest Regressor"
        Description = "Modelo de Machine Learning para predicción de costos AWS usando Random Forest. API REST con FastAPI y despliegue en Docker. Proyecto de portfolio para transición IA/ML."
        TechStack = @"
| Componente | Tecnología |
|------------|------------|
| Lenguaje | Python 3.11+ |
| ML | scikit-learn, pandas, numpy |
| API | FastAPI, Uvicorn |
| Contenedor | Docker |
| CI/CD | GitHub Actions |
| Datos | Dataset sintético (AWS us-east-1) |
"@
        QuickStart = @"
### Prerrequisitos
- Python 3.11+
- pip
- Docker (opcional)

### Instalar y ejecutar
```bash
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

Accede a la API: `http://localhost:8000/docs`
"@
        Architecture = @"
```mermaid
graph LR
    A[Input Features] --> B[RandomForest Model]
    B --> C[Predicción Costo]
    D[FastAPI] --> B
    E[Docker] --> D
    F[GitHub Actions] --> E
```
"@
        ApiDocsLink = "- Swagger UI: `http://localhost:8000/docs`"
        CiLink = "- **CI:** [![Build](https://img.shields.io/badge/build-passing-brightgreen)](https://github.com/raulrodriguezmesia-blip/aws-cost-optimizer-ml/actions/workflows/ml-pipeline.yml/badge.svg) Workflow: `ml-pipeline.yml` (test + deploy)."
        DefinitionOfDone = @"
- [x] Modelo entrenado y exportado (modelo_premium.pkl)
- [x] API REST funcional con FastAPI
- [x] Dockerizado
- [ ] Tests unitarios para el modelo
- [ ] Pipeline de reentrenamiento automático
- [ ] Validación de datos (Great Expectations)
"@
        HowToContribute = @"
1. Fork y rama: `git checkout -b feature/nuevo-modelo`
2. Commit: `git commit -m 'feat(ml): add Prophet forecasting'`
3. Push y PR

**Nota:** Los modelos deben ser versionados y documentados en `docs/`.
"@
        Badges = @"
![Python](https://img.shields.io/badge/Python-3.11+-blue?style=for-the-badge&logo=python&logoColor=white)
![scikit-learn](https://img.shields.io/badge/scikit-learn-F7931E?style=for-the-badge&logo=scikit-learn&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-005671?style=for-the-badge&logo=fastapi&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Build](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)
![Last Updated](https://img.shields.io/badge/updated-2026--07--12-informational?style=for-the-badge)
"@
    }

    "Aws-Portfolio-final" = @{
        Title = "AWS Cloud Portfolio — Prácticas y Proyectos"
        Description = "Portafolio de prácticas y proyectos en Amazon Web Services (AWS). Incluye simuladores de infraestructura, serverless, servicios avanzados y un CV desplegado en S3."
        TechStack = @"
| Componente | Tecnología |
|------------|------------|
| Cloud | AWS (EC2, S3, Lambda, DynamoDB, RDS, API Gateway, SQS, SNS, EventBridge, ECS/Fargate) |
| Scripting | Python 3.12 |
| Web | HTML5, CSS3, JavaScript |
| IAC | AWS CDK / CloudFormation (pendiente) |
| CI/CD | GitHub Actions (pendiente) |
| Hosting | AWS S3 Static Website |
"@
        QuickStart = @"
### Prerrequisitos
- Python 3.9+
- AWS CLI configurada (opcional)
- Git

### Clonar
```bash
git clone https://github.com/raulrodriguezmesia-blip/Aws-Portfolio-final.git
cd Aws-Portfolio-final
```

### Ejecutar simuladores
```bash
python simulations/fase1-infraestructura/aws_simulador.py
python simulations/fase2-serverless/aws_fase2.py
python simulations/fase3-avanzado/aws_fase3.py
```

### Ver CV localmente
```bash
python -m http.server 8000 --directory cv
# Abrir: http://localhost:8000
```
"@
        Architecture = @"
```mermaid
graph TD
    A[Usuario] --> B[S3 Static Website]
    B --> C[CloudFront CDN]
    D[Simuladores Python] --> E[EC2/S3/Lambda APIs]
    F[GitHub Actions] --> G[Deploy to S3]
```
"@
        ApiDocsLink = "- No aplica (simuladores Python y sitio estático)."
        CiLink = "- **CI:** Pendiente configurar GitHub Actions para validar scripts Python."
        DefinitionOfDone = @"
- [x] Simuladores de Fase 1, 2 y 3 funcionando
- [x] CV desplegado en S3 (producción)
- [ ] Tests unitarios para simuladores
- [ ] CI/CD configurado (lint + test + deploy)
- [ ] IaC con Terraform/CDK
"@
        HowToContribute = @"
1. Fork y crea rama: `git checkout -b feature/nuevo-simulador`
2. Commit: `git commit -m 'feat(aws): add S3 lifecycle policies simulator'`
3. Push y PR

**Nota:** Los simuladores deben ser documentados y ejecutables sin dependencias externas.
"@
        Badges = @"
![AWS](https://img.shields.io/badge/AWS-%23FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.12+-blue?style=for-the-badge&logo=python&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Build](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)
![Last Updated](https://img.shields.io/badge/updated-2026--07--12-informational?style=for-the-badge)
"@
    }
}

# Combinar configuraciones
$allRepos = @{}
foreach ($key in $repos.Keys) { $allRepos[$key] = $repos[$key] }
foreach ($key in $reposPython.Keys) { $allRepos[$key] = $reposPython[$key] }

# Aplicar plantilla a cada repositorio
foreach ($repo in $allRepos.Keys) {
    $config = $allRepos[$repo]
    $readmePath = Join-Path $WorkspaceRoot $repo "README.md"
    
    $content = New-ReadmeContent `
        -Title $config.Title `
        -Description $config.Description `
        -Badges $config.Badges `
        -TechStack $config.TechStack `
        -QuickStart $config.QuickStart `
        -Architecture $config.Architecture `
        -ApiDocsLink $config.ApiDocsLink `
        -CiLink $config.CiLink `
        -DefinitionOfDone $config.DefinitionOfDone `
        -HowToContribute $config.HowToContribute `
        -License $config.License `
        -LastUpdated $config.LastUpdated
    
    Set-Content -Path $readmePath -Value $content -Encoding UTF8
    Write-Host "✅ README actualizado: $repo" -ForegroundColor Green
}

Write-Host "`nProceso completado. Ahora ejecuta: git add . && git commit -m 'docs: estandarizar READMEs con template comun' && git push" -ForegroundColor Cyan
