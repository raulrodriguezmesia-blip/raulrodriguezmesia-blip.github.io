# Guía de Testing

## Estrategia de Testing

Este proyecto implementa una estrategia de testing basada en las "Testing Pyramid":

```
        ┌─────────────────────────────────────┐
        │           E2E Tests (10%)           │
        │  - Pruebas de punto a punto         │
        └─────────────────────────────────────┘
                       ▲
        ┌───────────────────────────────┐
        │    Integración Tests (20%)    │
        │  - Con archivos reales        │
        │  - Con API externa simulada   │
        └───────────────────────────────┘
                       ▲
        ┌──────────────────────────────────┐
        │    Unit Tests (70%)              │
        │  - Lógica de negocio            │
        │  - Repositorios en aislamiento  │
        │  - Validaciones                │
        └──────────────────────────────────┘
```

## Herramientas de Testing

| Herramienta | Versión | Uso |
|-------------|---------|-----|
| **JUnit 5** | 5.10.2 | Framework principal de testing |
| **Mockito** | 5.11.0 | Mocking de dependencias |
| **AssertJ** | 3.24.2 | Assertions fluent API |

## Estructura de Tests

```
src/test/java/
└── com/raulrodriguez/portfolio/
    ├── service/
    │   ├── UsuarioServiceTest.java
    │   │   - Tests de CRUD
    │   │   - Tests de validación
    │   │   - Tests de búsqueda
    │   │
    │   └── ApiServiceTest.java
    │       - Tests de conexión API
    │       - Tests de parsing JSON
    │       - Tests de manejo de errores
    │
    └── repository/
        └── ArchivoRepositoryTest.java
            - Tests de lectura JSON
            - Tests de escritura JSON
            - Tests de lectura TXT
            - Tests de lectura CSV
            - Tests de manejo de archivos inexistentes
```

## Ejecutar Tests

### Todos los tests
```bash
mvn test
```

### Tests específicos
```bash
# Tests de un paquete
mvn test -Dtest=com.raulrodriguez.portfolio.service.*

# Tests de una clase específica
mvn test -Dtest=UsuarioServiceTest

# Tests con palabra clave
mvn test -Dtest=*ServiceTest
```

### Con cobertura
```bash
mvn test jacoco:report
# Ver reporte en: target/site/jacoco/index.html
```

## Buenas Prácticas de Testing

### 1. Arrange-Act-Assert Pattern
```java
@Test
void deberiaCrearUsuarioConDatosValidos() {
    // Arrange
    Usuario usuario = new Usuario(0, "John Doe", "john@example.com", 30);
    
    // Act
    Usuario creado = service.crear(usuario);
    
    // Assert
    assertThat(creado.getId()).isGreaterThan(0);
    assertThat(creado.getNombre()).isEqualTo("John Doe");
}
```

### 2. Testing de Excepciones
```java
@Test
void deberiaLanzarExcepcion_ConEmailInvalido() {
    // Arrange
    Usuario usuario = new Usuario(0, "John Doe", "invalid-email", 30);
    
    // Act & Assert
    assertThatThrownBy(() -> service.crear(usuario))
        .isInstanceOf(IllegalArgumentException.class)
        .hasMessageContaining("email debe ser válido");
}
```

### 3. Mocking de Dependencias
```java
@ExtendWith(MockitoExtension.class)
class UsuarioServiceTest {
    
    @Mock
    private ArchivoRepository repositorio;
    
    @InjectMocks
    private UsuarioService service;
    
    @Test
    void deberiaGuardarUsuario_AlCrear() throws IOException {
        // Arrange
        Usuario usuario = new Usuario(0, "John", "john@test.com", 25);
        when(repositorio.cargarUsuarios()).thenReturn(List.of());
        
        // Act
        Usuario creado = service.crear(usuario);
        
        // Assert
        verify(repositorio).guardarUsuarioIndividual(creado);
    }
}
```

### 4. Testing de Validaciones
```java
@ParameterizedTest
@ValueSource(strings = {"", "   ", "null"})
void deberiaRechazarNombreVacio(String nombre) {
    Usuario usuario = new Usuario(0, nombre, "test@test.com", 25);
    
    assertThatThrownBy(() -> service.crear(usuario))
        .isInstanceOf(IllegalArgumentException.class);
}
```

## Cobertura de Código

### Métricas Objetivo
- **Línea (Line Coverage)**: ≥ 80%
- **Rama (Branch Coverage)**: ≥ 70%
- **Condición (Condition Coverage)**: ≥ 65%

### Informe de Cobertura
```bash
mvn jacoco:report
open target/site/jacoco/index.html
```

### Análisis del Reporte
- **Paquete com.raulrodriguez.portfolio.model**: 95% coverage
- **Paquete com.raulrodriguez.portfolio.service**: 85% coverage
- **Paquete com.raulrodriguez.portfolio.repository**: 80% coverage

## Testing Manual

### Ejecutar la aplicación
```bash
mvn exec:java
```

### Escenarios a Probar Manualmente
1. Crear usuario con datos válidos
2. Crear usuario con email inválido
3. Crear usuario con edad fuera de rango
4. Listar usuarios existentes
5. Buscar usuario por ID
6. Actualizar usuario existente
7. Eliminar usuario
8. Importar usuario desde API
9. Importar todos los usuarios desde API

## CI/CD Testing

El pipeline CI ejecuta automáticamente:
1. **Validación del código** (checkstyle, spotbugs)
2. **Compilación** (mvn clean compile)
3. **Tests unitarios** (mvn test)
4. **Generación de coverage** (jacoco)
5. **Verificación de coverage** (mínimo 80%)

## Debugging de Tests

### Ver output de tests
```bash
mvn test -Dverbose
```

### Depurar tests fallidos
```bash
mvn test -Dtest=TestClass#testMethod -DfailIfNoTests=false
```

### Ver logs de test
```bash
mvn test -DredirectTestOutputToFile=true
cat target/surefire-reports/*.txt
```

## Referencias

- [JUnit 5 User Guide](https://junit.org/junit5/docs/current/user-guide/)
- [Mockito Documentation](https://site.mockito.org/)
- [AssertJ User Guide](https://assertj.github.io/docs/)
- [JaCoCo Report](https://www.jacoco.org/jacoco/trunk/doc/)