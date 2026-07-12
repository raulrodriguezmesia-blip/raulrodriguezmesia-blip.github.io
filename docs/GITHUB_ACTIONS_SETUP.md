# Guía de Configuración — Reusable Workflows & Branch Protection

## 📋 Estructura Creada

```
.github/
├── actions/
│   ├── java-ci/
│   │   └── action.yml          # Composite action para Java/Maven
│   └── python-ci/
│       └── action.yml          # Composite action para Python/pytest
└── workflows/
    ├── reusable-java-ci.yml    # Reusable workflow Java (matriz 17/21)
    └── reusable-python-ci.yml  # Reusable workflow Python (matriz 3.11/3.12)

excepciones/.github/workflows/ci.yml      # Ejemplo de consumo (Java)
eros-code-analysis-agent/.github/workflows/ci.yml  # Ejemplo de consumo (Python)
```

---

## 1. Composite Actions (Acciones Compuestas)

### `.github/actions/java-ci/action.yml`

**Inputs:**
- `java-version` (requerido): Versión de JDK (ej: "17", "21")
- `maven-command` (opcional): Comando Maven (default: "verify")
- `working-directory` (opcional): Directorio del proyecto (default: ".")
- `run-coverage` (opcional): Habilitar reporte JaCoCo (default: false)
- `codecov-token` (opcional): Token para subir cobertura a Codecov

**Pasos:**
1. Checkout del código
2. Setup JDK con cache de Maven
3. Ejecuta `mvn -B <maven-command>`
4. (Opcional) Genera reporte JaCoCo
5. (Opcional) Sube cobertura a Codecov

### `.github/actions/python-ci/action.yml`

**Inputs:**
- `python-version` (requerido): Versión de Python (ej: "3.11", "3.12")
- `working-directory` (opcional): Directorio del proyecto (default: ".")
- `requirements-file` (opcional): Path a requirements.txt (default: "requirements.txt")
- `test-command` (opcional): Comando de tests (default: "pytest -v --cov --cov-report=xml")
- `lint-command` (opcional): Comando de linter (default: "ruff check .")
- `coverage-file` (opcional): Path al XML de cobertura (default: "coverage.xml")
- `codecov-token` (opcional): Token para Codecov

**Pasos:**
1. Checkout del código
2. Setup Python con cache de pip
3. Instala dependencias desde requirements.txt
4. Ejecuta linter (si está definido)
5. Ejecuta tests con cobertura
6. Sube reporte de cobertura a Codecov

---

## 2. Reusable Workflows (Workflows Reutilizables)

### `.github/workflows/reusable-java-ci.yml`

**Características:**
- Estrategia de matriz: Java 17 y Java 21
- Usa la composite action `java-ci`
- Genera resumen de cobertura en PRs
- Sube artifact de reporte Jacoco en pushes a main

**Uso desde otros repositorios:**
```yaml
jobs:
  call-java-ci:
    uses: ./.github/workflows/reusable-java-ci.yml
    with:
      java-versions: '["17", "21"]'
      maven-command: "verify"
      run-coverage: true
      working-directory: "."
      codecov-token: ${{ secrets.CODECOV_TOKEN }}
```

### `.github/workflows/reusable-python-ci.yml`

**Características:**
- Estrategia de matriz: Python 3.11 y 3.12
- Usa la composite action `python-ci`
- Incluye linting con ruff y tests con pytest
- Sube cobertura a Codecov

**Uso desde otros repositorios:**
```yaml
jobs:
  call-python-ci:
    uses: ./.github/workflows/reusable-python-ci.yml
    with:
      python-versions: '["3.11", "3.12"]'
      working-directory: "."
      requirements-file: "requirements.txt"
      test-command: "pytest -v --cov --cov-report=xml"
      lint-command: "ruff check ."
      coverage-file: "coverage.xml"
      codecov-token: ${{ secrets.CODECOV_TOKEN }}
```

---

## 3. Configuración de Branch Protection (GitHub UI)

### Para el repositorio principal (`raulrodriguezmesia-blip.github.io`):

1. Ve a: **Settings → Branches → Branch protection rules → Add rule**
2. Configuración recomendada:

| Campo | Valor |
|-------|-------|
| **Branch name pattern** | `main` |
| **Protect matching branches** | ✅ |
| **Require a pull request before merging** | ✅ |
| **Require approvals** | 1 (o más, según preferencia) |
| **Require status checks to pass before merging** | ✅ |
| **Require branches to be up to date before merging** | ✅ |
| **Status checks required** | `build` (nombre del job en el workflow) |
| **Include administrators** | ✅ (recomendado) |
| **Allow force pushes** | ❌ |
| **Allow deletions** | ❌ |

### Para los repositorios de proyectos (ej: `excepciones`, `springboot`, etc.):

Repetir la misma configuración en cada repositorio:
1. **Settings → Branches → Branch protection rules → Add rule**
2. Branch: `main`
3. Require PR: ✅
4. Require status checks: ✅
5. Status checks: `build` (o el nombre del job definido en el workflow)

**Nota:** Si usas el workflow de ejemplo `ci.yml` proporcionado, el nombre del job es `call-java-ci` o `call-python-ci`. Ajusta según corresponda.

---

## 4. Aplicación Masiva a Todos los Repositorios

### Opción A: Script PowerShell (recomendado)

Crea un archivo `apply-workflows.ps1` en el directorio raíz del workspace:

```powershell
$repos = @(
    "excepciones",
    "ferreteria",
    "java-junior-portfolio",
    "springboot",
    "springboot-feature-flag",
    "Alcaldia",
    "eros-code-analysis-agent",
    "aws-cost-optimizer-ml",
    "Aws-Portfolio-final",
    "sdk-springboot"
)

$javaRepos = @("excepciones", "ferreteria", "java-junior-portfolio", "springboot", "springboot-feature-flag", "Alcaldia", "sdk-springboot")
$pythonRepos = @("eros-code-analysis-agent", "aws-cost-optimizer-ml", "Aws-Portfolio-final")

foreach ($repo in $repos) {
    $workflowDir = Join-Path $repo ".github/workflows"
    $workflowPath = Join-Path $workflowDir "ci.yml"
    
    # Crear directorio si no existe
    if (-not (Test-Path $workflowDir)) {
        New-Item -ItemType Directory -Path $workflowDir -Force | Out-Null
    }
    
    $content = ""
    if ($javaRepos -contains $repo) {
        $content = @"
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  call-java-ci:
    uses: ./.github/workflows/reusable-java-ci.yml
    with:
      java-versions: '["17", "21"]'
      maven-command: "verify"
      run-coverage: true
      working-directory: "."
      codecov-token: `${{ secrets.CODECOV_TOKEN }}
"@
    } elseif ($pythonRepos -contains $repo) {
        $content = @"
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  call-python-ci:
    uses: ./.github/workflows/reusable-python-ci.yml
    with:
      python-versions: '["3.11", "3.12"]'
      working-directory: "."
      requirements-file: "requirements.txt"
      test-command: "pytest -v --cov --cov-report=xml"
      lint-command: "ruff check ."
      coverage-file: "coverage.xml"
      codecov-token: `${{ secrets.CODECOV_TOKEN }}
"@
    }
    
    if ($content) {
        Set-Content -Path $workflowPath -Value $content -Encoding UTF8
        Write-Host "✅ Creado ci.yml en $repo" -ForegroundColor Green
    }
}

Write-Host "`nAhora ejecuta en cada repositorio:" -ForegroundColor Cyan
Write-Host "  git add .github/workflows/ci.yml" -ForegroundColor Yellow
Write-Host "  git commit -m 'ci: agregar workflow reutilizable Java/Python'" -ForegroundColor Yellow
Write-Host "  git push origin main" -ForegroundColor Yellow
```

### Opción B: Copia manual

Para cada repositorio, crea el archivo `.github/workflows/ci.yml` con el contenido correspondiente (Java o Python) y haz commit + push.

---

## 5. Variables y Secrets Requeridos

### En cada repositorio (Settings → Secrets and variables → Actions):

| Nombre | Descripción | Requerido |
|--------|-------------|-----------|
| `CODECOV_TOKEN` | Token para subir cobertura a Codecov | Opcional (pero recomendado) |

### Cómo obtener `CODECOV_TOKEN`:
1. Ve a [codecov.io](https://codecov.io/)
2. Sign in con tu cuenta de GitHub
3. Agrega el repositorio
4. Copia el token y agrégalo como secret en GitHub Actions

---

## 6. Ejemplos de Uso de Composite Actions

### Ejemplo 1: Java con Maven Wrapper

```yaml
name: Custom Java Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build with Maven
        uses: ./.github/actions/java-ci
        with:
          java-version: "21"
          maven-command: "clean package"
          working-directory: "."
          run-coverage: true
```

### Ejemplo 2: Python con tox

```yaml
name: Custom Python Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.11", "3.12"]
    steps:
      - uses: actions/checkout@v4
      - name: Run Python CI
        uses: ./.github/actions/python-ci
        with:
          python-version: ${{ matrix.python-version }}
          working-directory: "."
          test-command: "tox -e py"
          lint-command: "ruff check src/"
          coverage-file: ".coverage"
```

### Ejemplo 3: Java con profile específico

```yaml
name: Build with Profile

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build with prod profile
        uses: ./.github/actions/java-ci
        with:
          java-version: "17"
          maven-command: "clean verify -Pprod"
          run-coverage: false
```

---

## 7. Políticas de Ramas (Branch Policies)

### Configuración recomendada para `main`:

| Política | Valor | Justificación |
|----------|-------|---------------|
| **Require pull request** | ✅ | Evita pushes directos a main |
| **Require approvals** | 1 | Al menos una revisión humana |
| **Require status checks** | ✅ | El CI debe pasar antes de merge |
| **Require branches up to date** | ✅ | El branch debe estar actualizado con main |
| **Allow force pushes** | ❌ | Previene reescritura de historial |
| **Allow deletions** | ❌ | Protege contra eliminación accidental |

### Configuración recomendada para `develop` (si aplica):

| Política | Valor |
|----------|-------|
| **Require pull request** | ✅ |
| **Require approvals** | 1 |
| **Require status checks** | ✅ |
| **Allow force pushes** | ❌ |
| **Allow deletions** | ❌ |

---

## 8. Checklist de Verificación

Después de aplicar la configuración, verifica:

- [ ] Los workflows se ejecutan correctamente en cada repositorio
- [ ] La matriz de versiones (Java 17/21, Python 3.11/3.12) se ejecuta en cada PR
- [ ] Los badges de estado aparecen en la página principal de cada repo
- [ ] Los PRs no se pueden mergear si el CI falla
- [ ] Los pushes directos a `main` están bloqueados
- [ ] Los reportes de cobertura se suben a Codecov (si está configurado)
- [ ] Los diagramas Mermaid se renderizan en los READMEs

---

## 9. Comandos Útiles

### Verificar workflows en un repositorio:
```bash
gh run list --repo raulrodriguezmesia-blip/springboot
```

### Ver logs de un workflow:
```bash
gh run view <run-id> --repo raulrodriguezmesia-blip/springboot
```

### Re-ejecutar un workflow fallido:
```bash
gh run rerun <run-id> --repo raulrodriguezmesia-blip/springboot
```

### Ver branch protection rules:
```bash
gh api repos/raulrodriguezmesia-blip/springboot/branches/main/protection --jq '.required_status_checks'
```

---

## 10. Próximos Pasos

1. **Aplicar workflows a todos los repositorios** (ejecutar script de aplicación masiva)
2. **Configurar branch protection** en cada repositorio (manual o via API)
3. **Obtener token de Codecov** y agregarlo como secret en cada repo
4. **Verificar que los CI pasan** en los PRs existentes
5. **Documentar** esta configuración en el README principal del portfolio

---

## 📌 Notas Importantes

- Los **reusable workflows** están definidos en el repositorio principal y referenciados con `uses: ./.github/workflows/reusable-xxx-ci.yml`
- Las **composite actions** también están en el repositorio principal y referenciadas con `uses: ./.github/actions/xxx-ci`
- Si prefieres centralizar todas las acciones en un repositorio separado (ej: `github-actions`), cambia las referencias a: `uses: raulrodriguezmesia-blip/github-actions/.github/actions/java-ci@main`
- Los workflows se activan en pushes y PRs a `main`, pero puedes ajustar los triggers según tus ramas (`develop`, `release/*`, etc.)

---

*Documento generado por Kilo, Senior DevOps Engineer*  
*Fecha: 2026-07-12*
