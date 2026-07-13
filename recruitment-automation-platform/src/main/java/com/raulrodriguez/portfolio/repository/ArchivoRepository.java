package com.raulrodriguez.portfolio.repository;

import com.raulrodriguez.portfolio.model.Usuario;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class ArchivoRepository {
    private static final Logger logger = Logger.getLogger(ArchivoRepository.class.getName());
    private static final String USUARIOS_JSON = "data/usuarios.json";
    private static final String USUARIOS_TXT = "data/usuarios.txt";
    private static final String USUARIOS_CSV = "data/usuarios.csv";
    private final ObjectMapper mapper;

    public ArchivoRepository() {
        this.mapper = new ObjectMapper();
        crearDirectorioData();
    }

    private void crearDirectorioData() {
        File dir = new File("data");
        if (!dir.exists()) {
            boolean creado = dir.mkdir();
            if (creado) {
                logger.info("Directorio 'data' creado correctamente");
            }
        }
    }

    public void guardarUsuarios(List<Usuario> usuarios) throws IOException {
        mapper.writerWithDefaultPrettyPrinter().writeValue(new File(USUARIOS_JSON), usuarios);
        logger.info("Usuarios guardados en JSON: " + USUARIOS_JSON);
    }

    public List<Usuario> cargarUsuarios() throws IOException {
        File file = new File(USUARIOS_JSON);
        if (!file.exists()) {
            logger.warning("Archivo JSON no encontrado, se creará uno nuevo al guardar");
            return new ArrayList<>();
        }
        return mapper.readValue(file, new TypeReference<List<Usuario>>() {});
    }

    public void guardarUsuarioIndividual(Usuario usuario) throws IOException {
        List<Usuario> usuarios = cargarUsuarios();
        usuarios.removeIf(u -> u.getId() == usuario.getId());
        usuarios.add(usuario);
        guardarUsuarios(usuarios);
        guardarUsuariosTxt(usuarios);
        guardarUsuariosCsv(usuarios);
        logger.info("Usuario guardado/actualizado: " + usuario.getId());
    }

    public void eliminarUsuario(int id) throws IOException {
        List<Usuario> usuarios = cargarUsuarios();
        boolean eliminado = usuarios.removeIf(u -> u.getId() == id);
        if (eliminado) {
            guardarUsuarios(usuarios);
            guardarUsuariosTxt(usuarios);
            guardarUsuariosCsv(usuarios);
            logger.info("Usuario eliminado: " + id);
        } else {
            logger.warning("Usuario no encontrado para eliminar: " + id);
        }
    }

    // ==================== PERSISTENCIA EN TEXTO PLANO (TXT) ====================
    public void guardarUsuariosTxt(List<Usuario> usuarios) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(USUARIOS_TXT))) {
            // Encabezado
            writer.write("# Formato: id|nombre|email|edad");
            writer.newLine();
            // Datos
            for (Usuario u : usuarios) {
                String linea = String.format("%d|%s|%s|%d",
                        u.getId(),
                        u.getNombre(),
                        u.getEmail(),
                        u.getEdad());
                writer.write(linea);
                writer.newLine();
            }
        }
        logger.info("Usuarios guardados en TXT: " + USUARIOS_TXT);
    }

    public List<Usuario> cargarUsuariosTxt() throws IOException {
        List<Usuario> lista = new ArrayList<>();
        File file = new File(USUARIOS_TXT);
        if (!file.exists()) {
            logger.warning("Archivo TXT no encontrado: " + USUARIOS_TXT);
            return lista;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String linea;
            boolean primera = true;
            while ((linea = reader.readLine()) != null) {
                // Saltar comentarios y líneas vacías
                linea = linea.trim();
                if (linea.isEmpty() || linea.startsWith("#")) {
                    continue;
                }
                String[] partes = linea.split("\\|");
                if (partes.length == 4) {
                    try {
                        Usuario u = new Usuario(
                                Integer.parseInt(partes[0]),
                                partes[1],
                                partes[2],
                                Integer.parseInt(partes[3])
                        );
                        lista.add(u);
                    } catch (NumberFormatException e) {
                        logger.warning("Línea malformada en TXT: " + linea);
                    }
                }
            }
        }
        logger.info("Usuarios cargados desde TXT: " + lista.size() + " registros");
        return lista;
    }

    // ==================== PERSISTENCIA EN CSV ====================
    public void guardarUsuariosCsv(List<Usuario> usuarios) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(USUARIOS_CSV))) {
            // Encabezado CSV
            writer.write("id,nombre,email,edad");
            writer.newLine();
            // Datos
            for (Usuario u : usuarios) {
                // Escapar comas en nombre/email si es necesario
                String nombre = u.getNombre().contains(",") ? "\"" + u.getNombre() + "\"" : u.getNombre();
                String email = u.getEmail().contains(",") ? "\"" + u.getEmail() + "\"" : u.getEmail();
                String linea = String.format("%d,%s,%s,%d",
                        u.getId(),
                        nombre,
                        email,
                        u.getEdad());
                writer.write(linea);
                writer.newLine();
            }
        }
        logger.info("Usuarios guardados en CSV: " + USUARIOS_CSV);
    }

    public List<Usuario> cargarUsuariosCsv() throws IOException {
        List<Usuario> lista = new ArrayList<>();
        File file = new File(USUARIOS_CSV);
        if (!file.exists()) {
            logger.warning("Archivo CSV no encontrado: " + USUARIOS_CSV);
            return lista;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String linea;
            boolean primera = true;
            while ((linea = reader.readLine()) != null) {
                linea = linea.trim();
                if (linea.isEmpty() || linea.startsWith("#")) {
                    continue;
                }
                // Saltar encabezado
                if (primera && (linea.startsWith("id,") || linea.startsWith("id|"))) {
                    primera = false;
                    continue;
                }
                primera = false;

                // Detectar separador (coma o pipe)
                String separador = linea.contains(",") ? "," : "\\|";
                String[] partes = linea.split(separador);

                if (partes.length >= 4) {
                    try {
                        Usuario u = new Usuario(
                                Integer.parseInt(partes[0].trim()),
                                partes[1].trim().replace("\"", ""),
                                partes[2].trim().replace("\"", ""),
                                Integer.parseInt(partes[3].trim())
                        );
                        lista.add(u);
                    } catch (NumberFormatException e) {
                        logger.warning("Línea malformada en CSV: " + linea);
                    }
                }
            }
        }
        logger.info("Usuarios cargados desde CSV: " + lista.size() + " registros");
        return lista;
    }
}
