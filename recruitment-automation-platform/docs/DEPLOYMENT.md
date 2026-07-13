# Guía de Despliegue

## Entornos Soportados

| Entorno | Descripción | Requisitos |
|---------|-------------|------------|
| **Local** | Desarrollo local | Java 17, Maven 3.9+ |
| **Docker** | Contenerizado | Docker 24+, Docker Compose 2+ |
| **CI/CD** | GitHub Actions | Automatizado |

## Despliegue Local

### Requisitos Previos

```bash
# Verificar Java
java -version
# Salida esperada: openjdk version "17.x.x"

# Verificar Maven
mvn -version
# Salida esperada: Apache Maven 3.9.x
```

### Pasos de Despliegue

```bash
# 1. Clonar el repositorio
git clone https://github.com/raulrodriguezmesia-blip/java-junior-portfolio.git
cd java-junior-portfolio

# 2. Compilar el proyecto
mvn clean compile

# 3. Ejecutar tests
mvn test

# 4. Ejecutar la aplicación
mvn exec:java
```

## Despliegue con Docker

### Dockerfile

```dockerfile
FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### docker-compose.yml

```yaml
version: '3.8'

services:
  java-portfolio:
    build: .
    ports:
      - "8080:8080"
    volumes:
      - ./data:/app/data
    environment:
      - JAVA_OPTS=-Xmx512m
    restart: unless-stopped
```

### Pasos de Despliegue Docker

```bash
# 1. Construir la imagen
docker build -t java-portfolio:latest .

# 2. Ejecutar el contenedor
docker run -p 8080:8080 java-portfolio:latest

# O usando docker-compose
docker-compose up -d

# 3. Verificar que está corriendo
docker-compose logs -f

# 4. Detener
docker-compose down
```

## CI/CD Pipeline

### GitHub Actions

El pipeline automatizado incluye:

```
┌─────────────────────────────────────────────────────────────┐
│  GitHub Actions Workflow                                     │
├─────────────────────────────────────────────────────────────┤
│  1. Checkout code                                            │
│  2. Setup Java 17 (Temurin)                                  │
│  3. Cache Maven dependencies                                 │
│  4. Validate pom.xml                                         │
│  5. Check code style (Checkstyle)                            │
│  6. Static analysis (SpotBugs)                               │
│  7. Build with Maven                                         │
│  8. Run tests                                                │
│  9. Generate coverage report                                 │
│ 10. Upload artifacts                                         │
│ 11. Create release (on tag)                                 │
└─────────────────────────────────────────────────────────────┘
```

### Triggers

- **Push a main**: Ejecuta pipeline completo
- **Pull Request**: Ejecuta tests y validación
- **Tag**: Crea release con artifact

### Variables de Entorno

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| `JAVA_OPTS` | Opciones JVM | `-Xmx512m` |
| `CODECOV_TOKEN` | Token para Codecov | (secreto) |
| `GITHUB_TOKEN` | Token de GitHub | automático |

## Monitoreo

### Health Checks

La aplicación puede exponer endpoints de salud:

```bash
# Verificar estado
curl http://localhost:8080/actuator/health

# Métricas
curl http://localhost:8080/actuator/metrics
```

### Logging

Los logs se escriben a consola con formato estructurado:

```
INFO  com.raulrodriguez.portfolio.Main - Aplicación Portfolio Java Junior Iniciada
INFO  com.raulrodriguez.portfolio.service.UsuarioService - Usuario creado: 1
WARNING  com.raulrodriguez.portfolio.service.UsuarioService - Intento de actualizar usuario inexistente: 999
```

## Escalabilidad

### Recursos Recomendados

| Escenario | CPU | Memoria | Disco |
|-----------|-----|---------|-------|
| **Desarrollo** | 1 core | 512MB | 100MB |
| **Staging** | 2 cores | 1GB | 500MB |
| **Producción** | 4 cores | 2GB | 1GB |

### Configuración JVM Recomendada

```bash
JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
```

## Troubleshooting

### Problemas Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `java.lang.UnsupportedClassVersionError` | Java versión incompatible | Instalar Java 17 |
| `OutOfMemoryError` | Memoria insuficiente | Aumentar heap: `-Xmx1024m` |
| `ClassNotFoundException` | Dependencias no compiladas | `mvn clean compile` |
| `Port already in use` | Puerto ocupado | Cambiar puerto o matar proceso |

### Ver Logs Detallados

```bash
# Ver logs de Maven
mvn clean install -X

# Ver logs de Docker
docker logs java-portfolio

# Ver logs de GitHub Actions
# Ir a: https://github.com/raulrodriguezmesia-blip/java-junior-portfolio/actions
```

## Seguridad

### Recomendaciones

1. **No exponer puertos innecesarios**
2. **Usar variables de entorno para secrets**
3. **Actualizar dependencias regularmente**
4. **Escanear vulnerabilidades con OWASP Dependency-Check**

### Scan de Dependencias

```bash
mvn dependency-check:check
```

## Backup y Recuperación

### Datos Generados

Los siguientes archivos generan datos que deben respaldarse:

```
java-junior-portfolio/
├── data/
│   ├── usuarios.json
│   ├── usuarios.txt
│   └── usuarios.csv
└── target/
    └── site/jacoco/
```

### Estrategia de Backup

```bash
# Backup manual
tar -czf backup-$(date +%Y%m%d).tar.gz data/

# Restore
tar -xzf backup-20260713.tar.gz
```

## Actualización

### Actualizar a nueva versión

```bash
# 1. Crear rama de feature
git checkout -b feature/update-version

# 2. Actualizar versión
mvn versions:set -DnewVersion=2.1.0

# 3. Commit y push
git commit -am "chore: update to version 2.1.0"
git push origin feature/update-version

# 4. Crear Release
git tag v2.1.0
git push origin v2.1.0
```

## Referencias

- [Maven Documentation](https://maven.apache.org/guides/)
- [Docker Documentation](https://docs.docker.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)