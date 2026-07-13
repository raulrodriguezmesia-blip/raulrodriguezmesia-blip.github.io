package com.raulrodriguez.portfolio.service;

import com.raulrodriguez.portfolio.model.Usuario;
import org.junit.jupiter.api.*;

import java.io.IOException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class ApiServiceTest {
    private ApiService apiService;

    @BeforeEach
    void setUp() {
        apiService = new ApiService();
    }

    @Test
    @DisplayName("Obtener usuario desde API (ID=1)")
    void testObtenerUsuarioAPI() throws IOException, InterruptedException {
        Usuario usuario = apiService.obtenerUsuarioDesdeAPI(1);

        assertNotNull(usuario);
        assertEquals(1, usuario.getId());
        assertNotNull(usuario.getNombre());
        assertTrue(usuario.getEmail().contains("@"));
        assertEquals(25, usuario.getEdad()); // Valor por defecto que asignamos
    }

    @Test
    @DisplayName("Obtener usuario desde API falla con ID inválido")
    void testObtenerUsuarioInvalido() {
        assertThrows(IOException.class, () -> {
            apiService.obtenerUsuarioDesdeAPI(9999);
        });
    }

    @Test
    @DisplayName("Obtener todos los usuarios desde API")
    void testObtenerTodosUsuariosAPI() throws IOException, InterruptedException {
        List<Usuario> usuarios = apiService.obtenerTodosUsuariosAPI();

        assertFalse(usuarios.isEmpty(), "La lista no debería estar vacía");
        assertTrue(usuarios.size() >= 10, "Deberían haber al menos 10 usuarios");

        // Verificar primer usuario
        Usuario primero = usuarios.get(0);
        assertNotNull(primero.getId());
        assertNotNull(primero.getNombre());
    }

    @Test
    @DisplayName("Mapeo correcto de campos API a modelo local")
    void testMapeoCampos() throws IOException, InterruptedException {
        Usuario usuario = apiService.obtenerUsuarioDesdeAPI(2);

        // Verificar que email se mapea correctamente
        assertTrue(usuario.getEmail().contains("@"), "Email debe contener @");
        // Verificar que nombre se mapea correctamente
        assertNotNull(usuario.getNombre());
        assertFalse(usuario.getNombre().isEmpty());
    }
}
