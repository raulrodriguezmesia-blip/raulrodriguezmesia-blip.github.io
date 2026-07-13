package com.raulrodriguez.portfolio.service;

import com.raulrodriguez.portfolio.model.Usuario;
import com.raulrodriguez.portfolio.repository.ArchivoRepository;

import java.io.IOException;
import java.util.*;
import java.util.logging.Logger;
import java.util.stream.Collectors;

public class UsuarioService {
    private static final Logger logger = Logger.getLogger(UsuarioService.class.getName());
    private final Map<Integer, Usuario> usuarios = new HashMap<>();
    private final ArchivoRepository repositorio;
    private int nextId = 1;

    public UsuarioService() {
        this.repositorio = new ArchivoRepository();
        cargarDesdeArchivo();
    }

    private void cargarDesdeArchivo() {
        try {
            // Intentar cargar desde JSON primero
            List<Usuario> usuariosList = repositorio.cargarUsuarios();
            if (usuariosList.isEmpty()) {
                // Si JSON está vacío, intentar TXT
                usuariosList = repositorio.cargarUsuariosTxt();
            }
            if (usuariosList.isEmpty()) {
                // Si TXT está vacío, intentar CSV
                usuariosList = repositorio.cargarUsuariosCsv();
            }

            for (Usuario u : usuariosList) {
                usuarios.put(u.getId(), u);
                if (u.getId() >= nextId) {
                    nextId = u.getId() + 1;
                }
            }
            logger.info("Se cargaron " + usuarios.size() + " usuarios desde archivo");
        } catch (IOException e) {
            logger.severe("Error cargando usuarios: " + e.getMessage());
        }
    }

    public List<Usuario> listarTodos() {
        return new ArrayList<>(usuarios.values());
    }

    public Optional<Usuario> obtenerPorId(int id) {
        return Optional.ofNullable(usuarios.get(id));
    }

    public Usuario crear(Usuario usuario) {
        validarUsuario(usuario);

        usuario.setId(nextId++);
        usuarios.put(usuario.getId(), usuario);

        try {
            repositorio.guardarUsuarioIndividual(usuario);
        } catch (IOException e) {
            logger.severe("Error guardando usuario: " + e.getMessage());
        }

        logger.info("Usuario creado: " + usuario.getId());
        return usuario;
    }

    public boolean actualizar(Usuario usuario) {
        validarUsuario(usuario);

        if (!usuarios.containsKey(usuario.getId())) {
            logger.warning("Intento de actualizar usuario inexistente: " + usuario.getId());
            return false;
        }

        usuarios.put(usuario.getId(), usuario);

        try {
            repositorio.guardarUsuarioIndividual(usuario);
        } catch (IOException e) {
            logger.severe("Error actualizando usuario: " + e.getMessage());
            return false;
        }

        logger.info("Usuario actualizado: " + usuario.getId());
        return true;
    }

    public boolean eliminar(int id) {
        if (!usuarios.containsKey(id)) {
            logger.warning("Intento de eliminar usuario inexistente: " + id);
            return false;
        }

        usuarios.remove(id);

        try {
            repositorio.eliminarUsuario(id);
        } catch (IOException e) {
            logger.severe("Error eliminando usuario: " + e.getMessage());
            return false;
        }

        logger.info("Usuario eliminado: " + id);
        return true;
    }

    public List<Usuario> buscarPorNombre(String nombre) {
        return usuarios.values().stream()
                .filter(u -> u.getNombre().toLowerCase().contains(nombre.toLowerCase()))
                .collect(Collectors.toList());
    }

    private void validarUsuario(Usuario u) {
        if (u.getNombre() == null || u.getNombre().trim().isEmpty()) {
            throw new IllegalArgumentException("El nombre es obligatorio");
        }
        if (u.getEmail() == null || !u.getEmail().contains("@")) {
            throw new IllegalArgumentException("El email debe ser válido");
        }
        if (u.getEdad() <= 0 || u.getEdad() > 120) {
            throw new IllegalArgumentException("La edad debe estar entre 1 y 120");
        }
    }
}
