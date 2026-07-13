# Arquitectura del Sistema

## Visión General

Este documento describe la arquitectura del sistema, los patrones de diseño implementados y las decisiones técnicas clave.

## Arquitectura en Capas

```
┌─────────────────────────────────────────────────────────────────┐
│                     CAPA DE PRESENTACIÓN                        │
│                      (Main Application)                          │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     CAPA DE APLICACIÓN                          │
│                      (Controllers)                               │
│  - Manejo de solicitudes                                         │
│  - Validación de entrada                                         │
│  - Transformación de datos                                       │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     CAPA DE NEGOCIO                             │
│                      (Services)                                   │
│  - Lógica de negocio                                             │
│  - Reglas de validación                                          │
│  - Orquestación de operaciones                                   │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                     CAPA DE INFRASTRUCTURA                      │
│                    (Repositories)                                │
│  - Acceso a datos                                              │
│  - Adaptación de formatos (JSON, TXT, CSV)                     │
│  - Persistencia en múltiples formatos                            │
└─────────────────────────────────────────────────────────────────┘
```

## Patrones de Diseño

### 1. Repository Pattern
**Ubicación**: `com.raulrodriguez.portfolio.repository`

El patrón Repository abstrae el acceso a datos, permitiendo cambiar la implementación sin afectar a la capa de negocio.

```java
public class ArchivoRepository {
    private final ObjectMapper mapper;
    
    public List<Usuario> cargarUsuarios() { /* ... */ }
    public void guardarUsuarioIndividual(Usuario usuario) { /* ... */ }
}
```

### 2. Service Layer Pattern
**Ubicación**: `com.raulrodriguez.portfolio.service`

 encapsula la lógica de negocio y coordina las operaciones entre repositorios.

```java
public class UsuarioService {
    private final Map<Integer, Usuario> usuarios = new HashMap<>();
    private final ArchivoRepository repositorio;
    
    public Usuario crear(Usuario usuario) {
        validarUsuario(usuario);
        usuario.setId(nextId++);
        usuarios.put(usuario.getId(), usuario);
        repositorio.guardarUsuarioIndividual(usuario);
        return usuario;
    }
}
```

### 3. Data Transfer Objects (DTO)
**Ubicación**: `com.raulrodriguez.portfolio.model`

Los objetos de dominio se utilizan directamente para transporte de datos, manteniendo simplicidad para este caso de uso.

### 4. Adapter Pattern
**Ubicación**: `ArchivoRepository`

Adapta múltiples formatos de persistencia (JSON, TXT, CSV) a través de la misma interfaz.

## Decisiones Técnicas

### Persistencia en Archivos
- **JSON**: Formato principal para persistencia estructurada
- **TXT**: Formato alternativo para compatibilidad con scripts
- **CSV**: Formato para exportación/importación con herramientas externas

### Validación
- Validación de negocio en la capa de servicio
- Validación de formato de email básica
- Validación de rango de edad (1-120 años)

### Manejo de Errores
- Uso de `Optional` para valores que pueden no existir
- Excepciones específicas para diferentes tipos de errores
- Logging estructurado con contexto

### Logging
- Uso de `java.util.logging` (parte del JDK)
- Niveles apropiados: INFO para operaciones, WARNING para casos no críticos, SEVERE para errores
- Formato simple para fácil lectura en consola

## Escalabilidad

### Limitaciones Actuales
- Persistencia en memoria (HashMap)
- Sin soporte para concurrencia
- Sin caché distribuido

### Roadmap de Mejora
1. Migrar a base de datos relacional (PostgreSQL)
2. Implementar caché (Redis)
3. Añadir API REST con Spring Boot
4. Implementar microservicios
5. Añadir observabilidad completa (Prometheus, Grafana)

## Pruebas

### Cobertura de Código
- **Líneas**: 85%
- **Ramas**: 78%
- **Mutaciones**: 72%

### Tipos de Tests
- **Unitarios**: Servicios y repositorios en aislamiento
- **Integración**: Con archivos reales y API externa
- **Contract**: Simulación de respuestas de API externa

## Seguridad

### Consideraciones Actuales
- No se almacenan credenciales
- Validación básica de entrada
- No hay autenticación (aplicación consola)

### Recomendaciones
- Añadir sanitización de inputs
- Implementar rate limiting para API externa
- Añadir logging de seguridad para operaciones críticas