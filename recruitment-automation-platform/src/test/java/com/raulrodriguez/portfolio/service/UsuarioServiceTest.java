package com.raulrodriguez.portfolio.service;

import com.raulrodriguez.portfolio.model.Usuario;
import org.junit.jupiter.api.*;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

class UsuarioServiceTest {
    private UsuarioService service;

    @BeforeEach
    void setUp() throws IOException {
        // Limpiar TODOS los archivos de datos antes de cada test
        new File("data/usuarios.json").delete();
        new File("data/usuarios.txt").delete();
        new File("data/usuarios.csv").delete();
        service = new UsuarioService();
    }

    @Test
    @DisplayName("Listar usuarios vacío al inicio")
    void testListarVacio() {
        List<Usuario> usuarios = service.listarTodos();
        assertTrue(usuarios.isEmpty(), "La lista debería estar vacía al inicio");
    }

    @Test
    @DisplayName("Crear y buscar usuario por ID")
    void testCrearYBuscar() {
        Usuario nuevo = new Usuario(0, "Juan Pérez", "juan@email.com", 30);
        Usuario creado = service.crear(nuevo);

        assertNotNull(creado.getId(), "El ID debería ser asignado automáticamente");
        assertEquals("Juan Pérez", creado.getNombre());
        assertEquals("juan@email.com", creado.getEmail());
        assertEquals(30, creado.getEdad());

        Optional<Usuario> encontrado = service.obtenerPorId(creado.getId());
        assertTrue(encontrado.isPresent());
        assertEquals(creado, encontrado.get());
    }

    @Test
    @DisplayName("Actualizar usuario existente")
    void testActualizar() {
        Usuario u1 = service.crear(new Usuario(0, "María", "maria@email.com", 25));
        Usuario actualizado = new Usuario(u1.getId(), "María García", "maria.garcia@email.com", 26);

        boolean result = service.actualizar(actualizado);
        assertTrue(result, "La actualización debería ser exitosa");

        Usuario recuperado = service.obtenerPorId(u1.getId()).orElseThrow();
        assertEquals("María García", recuperado.getNombre());
        assertEquals(26, recuperado.getEdad());
    }

    @Test
    @DisplayName("Eliminar usuario")
    void testEliminar() {
        Usuario creado = service.crear(new Usuario(0, "Pedro", "pedro@email.com", 40));
        int id = creado.getId();

        boolean result = service.eliminar(id);
        assertTrue(result, "La eliminación debería ser exitosa");

        Optional<Usuario> eliminado = service.obtenerPorId(id);
        assertFalse(eliminado.isPresent(), "El usuario no debería existir después de eliminarlo");
    }

    @Test
    @DisplayName("Buscar por nombre (búsqueda parcial)")
    void testBuscarPorNombre() {
        service.crear(new Usuario(0, "Ana López", "ana@email.com", 22));
        service.crear(new Usuario(0, "Luis Andrés", "luis@email.com", 35));

        List<Usuario> resultados = service.buscarPorNombre("ana");
        assertEquals(1, resultados.size());
        assertEquals("Ana López", resultados.get(0).getNombre());
    }

    @Test
    @DisplayName("Validar email inválido lanza excepción")
    void testValidarEmailInvalido() {
        Usuario invalido = new Usuario(0, "Test", "email-sin-arroba", 30);

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> service.crear(invalido)
        );

        assertTrue(exception.getMessage().contains("email"));
    }

    @Test
    @DisplayName("Validar edad negativa lanza excepción")
    void testValidarEdadNegativa() {
        Usuario invalido = new Usuario(0, "Test", "test@email.com", -5);

        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> service.crear(invalido)
        );

        assertTrue(exception.getMessage().contains("edad"));
    }

    @Test
    @DisplayName("Actualizar usuario no existente retorna false")
    void testActualizarNoExistente() {
        Usuario fantasma = new Usuario(999, "Fantasma", "fantasma@email.com", 99);
        boolean result = service.actualizar(fantasma);
        assertFalse(result, "No debería poder actualizar un usuario que no existe");
    }

    @Test
    @DisplayName("Eliminar usuario no existente retorna false")
    void testEliminarNoExistente() {
        boolean result = service.eliminar(9999);
        assertFalse(result, "No debería poder eliminar un usuario que no existe");
    }
}
