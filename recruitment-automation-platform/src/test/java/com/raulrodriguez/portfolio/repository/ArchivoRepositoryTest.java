package com.raulrodriguez.portfolio.repository;

import com.raulrodriguez.portfolio.model.Usuario;
import org.junit.jupiter.api.*;

import java.io.File;
import java.io.IOException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class ArchivoRepositoryTest {
    private ArchivoRepository repo;
    private static final String TEST_FILE = "data/usuarios.json";

    @BeforeEach
    void setUp() throws IOException {
        repo = new ArchivoRepository();
        // Limpiar TODOS los archivos de persistencia antes de cada test
        new File("data/usuarios.json").delete();
        new File("data/usuarios.txt").delete();
        new File("data/usuarios.csv").delete();
    }

    @Test
    @DisplayName("Guardar y cargar usuarios desde archivo")
    void testGuardarYCargarUsuarios() throws IOException {
        List<Usuario> lista = List.of(
                new Usuario(1, "Juan", "juan@email.com", 30),
                new Usuario(2, "María", "maria@email.com", 25)
        );

        // Guardar
        repo.guardarUsuarios(lista);

        // Cargar
        List<Usuario> cargados = repo.cargarUsuarios();

        assertEquals(2, cargados.size());
        assertEquals("Juan", cargados.get(0).getNombre());
        assertEquals("maria@email.com", cargados.get(1).getEmail());
    }

    @Test
    @DisplayName("Cargar usuarios desde archivo inexistente retorna lista vacía")
    void testArchivoNoExisteRetornaVacio() throws IOException {
        List<Usuario> cargados = repo.cargarUsuarios();
        assertTrue(cargados.isEmpty(), "Debe retornar lista vacía si el archivo no existe");
    }

    @Test
    @DisplayName("Guardar usuario individual")
    void testGuardarUsuarioIndividual() throws IOException {
        Usuario u = new Usuario(1, "Luis", "luis@email.com", 40);
        repo.guardarUsuarioIndividual(u);

        List<Usuario> cargados = repo.cargarUsuarios();
        assertEquals(1, cargados.size());
        assertEquals("Luis", cargados.get(0).getNombre());
    }

    @Test
    @DisplayName("Actualizar usuario existente")
    void testActualizarUsuarioIndividual() throws IOException {
        Usuario original = new Usuario(1, "Ana", "ana@email.com", 22);
        repo.guardarUsuarioIndividual(original);

        Usuario actualizada = new Usuario(1, "Ana García", "ana.garcia@email.com", 23);
        repo.guardarUsuarioIndividual(actualizada);

        List<Usuario> cargados = repo.cargarUsuarios();
        Usuario recuperada = cargados.get(0);

        assertEquals("Ana García", recuperada.getNombre());
        assertEquals(23, recuperada.getEdad());
    }

    @Test
    @DisplayName("Eliminar usuario")
    void testEliminarUsuario() throws IOException {
        Usuario u1 = new Usuario(1, "Pedro", "pedro@email.com", 35);
        Usuario u2 = new Usuario(2, "Sofia", "sofia@email.com", 28);

        repo.guardarUsuarioIndividual(u1);
        repo.guardarUsuarioIndividual(u2);

        assertEquals(2, repo.cargarUsuarios().size());

        repo.eliminarUsuario(1);

        List<Usuario> postEliminacion = repo.cargarUsuarios();
        assertEquals(1, postEliminacion.size());
        assertEquals("Sofia", postEliminacion.get(0).getNombre());
    }

    @Test
    @DisplayName("Eliminar usuario inexistente no lanza excepción")
    void testEliminarUsuarioInexistente() throws IOException {
        Usuario u = new Usuario(1, "Test", "test@email.com", 30);
        repo.guardarUsuarioIndividual(u);

        // Eliminar ID que no existe
        assertDoesNotThrow(() -> repo.eliminarUsuario(999));

        List<Usuario> usuarios = repo.cargarUsuarios();
        assertEquals(1, usuarios.size()); // No debería cambiar
    }
}
