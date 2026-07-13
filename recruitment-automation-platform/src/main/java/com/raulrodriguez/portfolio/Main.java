package com.raulrodriguez.portfolio;

import com.raulrodriguez.portfolio.model.Usuario;
import com.raulrodriguez.portfolio.model.Producto;
import com.raulrodriguez.portfolio.service.UsuarioService;
import com.raulrodriguez.portfolio.service.ApiService;
import com.raulrodriguez.portfolio.util.LogConfig;

import java.io.IOException;
import java.util.List;
import java.util.Scanner;
import java.util.logging.*;

public class Main {
    private static final Logger logger = Logger.getLogger(Main.class.getName());
    private static final Scanner scanner = new Scanner(System.in);
    private static final UsuarioService usuarioService = new UsuarioService();
    private static final ApiService apiService = new ApiService();

    public static void main(String[] args) {
        LogConfig.configurar();
        logger.info("=== Aplicación Portfolio Java Junior Iniciada ===");

        boolean running = true;
        while (running) {
            mostrarMenu();
            int opcion = leerEntero("Seleccione una opción: ");

            try {
                running = procesarOpcion(opcion);
            } catch (Exception e) {
                logger.severe("Error inesperado: " + e.getMessage());
                System.out.println("❌ Error: " + e.getMessage());
            }
        }

        logger.info("=== Aplicación Finalizada ===");
        System.out.println("\n¡Hasta pronto!");
    }

    private static void mostrarMenu() {
        System.out.println("\n=== MENÚ PRINCIPAL ===");
        System.out.println("1. Listar todos los usuarios");
        System.out.println("2. Buscar usuario por ID");
        System.out.println("3. Crear nuevo usuario");
        System.out.println("4. Actualizar usuario");
        System.out.println("5. Eliminar usuario");
        System.out.println("6. Importar usuario desde API");
        System.out.println("7. Importar todos los usuarios desde API");
        System.out.println("8. Salir");
    }

    private static boolean procesarOpcion(int opcion) throws IOException, InterruptedException {
        switch (opcion) {
            case 1:
                listarUsuarios();
                break;
            case 2:
                buscarUsuario();
                break;
            case 3:
                crearUsuario();
                break;
            case 4:
                actualizarUsuario();
                break;
            case 5:
                eliminarUsuario();
                break;
            case 6:
                importarUsuarioAPI();
                break;
            case 7:
                importarTodosAPI();
                break;
            case 8:
                return false;
            default:
                System.out.println("⚠️  Opción no válida");
        }
        return true;
    }

    private static void listarUsuarios() {
        List<Usuario> usuarios = usuarioService.listarTodos();
        if (usuarios.isEmpty()) {
            System.out.println("📭 No hay usuarios registrados");
        } else {
            System.out.println("\n📋 USUARIOS REGISTRADOS (" + usuarios.size() + "):");
            usuarios.forEach(u -> System.out.println("  " + u));
        }
    }

    private static void buscarUsuario() {
        int id = leerEntero("Ingrese el ID del usuario: ");
        Usuario usuario = usuarioService.obtenerPorId(id).orElse(null);
        if (usuario != null) {
            System.out.println("✅ Usuario encontrado: " + usuario);
        } else {
            System.out.println("❌ Usuario no encontrado");
        }
    }

    private static void crearUsuario() {
        System.out.println("\n--- Crear Nuevo Usuario ---");
        String nombre = leerTexto("Nombre: ");
        String email = leerTexto("Email: ");
        int edad = leerEntero("Edad: ");

        Usuario usuario = new Usuario(0, nombre, email, edad);
        Usuario creado = usuarioService.crear(usuario);
        System.out.println("✅ Usuario creado con ID: " + creado.getId());
    }

    private static void actualizarUsuario() {
        System.out.println("\n--- Actualizar Usuario ---");
        int id = leerEntero("ID del usuario a actualizar: ");

        Usuario existente = usuarioService.obtenerPorId(id).orElse(null);
        if (existente == null) {
            System.out.println("❌ Usuario no encontrado");
            return;
        }

        System.out.println("Usuario actual: " + existente);
        String nombre = leerTextoOpcional("Nuevo nombre (" + existente.getNombre() + "): ", existente.getNombre());
        String email = leerTextoOpcional("Nuevo email (" + existente.getEmail() + "): ", existente.getEmail());
        int edad = leerEnteroOpcional("Nueva edad (" + existente.getEdad() + "): ", existente.getEdad());

        Usuario actualizado = new Usuario(id, nombre, email, edad);
        boolean ok = usuarioService.actualizar(actualizado);
        if (ok) {
            System.out.println("✅ Usuario actualizado correctamente");
        } else {
            System.out.println("❌ Error al actualizar usuario");
        }
    }

    private static void eliminarUsuario() {
        int id = leerEntero("ID del usuario a eliminar: ");
        System.out.print("¿Confirma eliminación? (s/N): ");
        String confirm = scanner.nextLine().trim().toLowerCase();

        if (confirm.equals("s") || confirm.equals("si")) {
            boolean ok = usuarioService.eliminar(id);
            if (ok) {
                System.out.println("✅ Usuario eliminado correctamente");
            } else {
                System.out.println("❌ No se pudo eliminar (ID no existe)");
            }
        } else {
            System.out.println("❌ Eliminación cancelada");
        }
    }

    private static void importarUsuarioAPI() throws IOException, InterruptedException {
        int id = leerEntero("ID de usuario a importar (1-10): ");
        try {
            Usuario usuario = apiService.obtenerUsuarioDesdeAPI(id);
            usuario.setId(0); // Reset ID para asignación automática
            Usuario creado = usuarioService.crear(usuario);
            System.out.println("✅ Usuario importado de API: " + creado);
        } catch (Exception e) {
            System.out.println("❌ Error importando desde API: " + e.getMessage());
        }
    }

    private static void importarTodosAPI() throws IOException, InterruptedException {
        System.out.println("⏳ Importando todos los usuarios desde API...");
        List<Usuario> usuariosAPI = apiService.obtenerTodosUsuariosAPI();

        int importados = 0;
        for (Usuario u : usuariosAPI) {
            try {
                u.setId(0); // Reset ID para asignación automática
                usuarioService.crear(u);
                importados++;
            } catch (Exception e) {
                logger.warning("Error importando usuario " + u.getId() + ": " + e.getMessage());
            }
        }

        System.out.println("✅ Se importaron " + importados + " usuarios de " + usuariosAPI.size());
    }

    // Utilidades de entrada
    private static int leerEntero(String mensaje) {
        while (true) {
            try {
                System.out.print(mensaje);
                String input = scanner.nextLine().trim();
                if (input.isEmpty()) {
                    System.out.println("⚠️  Campo obligatorio");
                    continue;
                }
                return Integer.parseInt(input);
            } catch (NumberFormatException e) {
                System.out.println("⚠️  Debe ingresar un número entero");
            }
        }
    }

    private static int leerEnteroOpcional(String mensaje, int valorPorDefecto) {
        try {
            System.out.print(mensaje);
            String input = scanner.nextLine().trim();
            return input.isEmpty() ? valorPorDefecto : Integer.parseInt(input);
        } catch (NumberFormatException e) {
            System.out.println("⚠️  Valor inválido, se usará el anterior");
            return valorPorDefecto;
        }
    }

    private static String leerTexto(String mensaje) {
        while (true) {
            System.out.print(mensaje);
            String input = scanner.nextLine().trim();
            if (!input.isEmpty()) {
                return input;
            }
            System.out.println("⚠️  Campo obligatorio");
        }
    }

    private static String leerTextoOpcional(String mensaje, String valorPorDefecto) {
        System.out.print(mensaje);
        String input = scanner.nextLine().trim();
        return input.isEmpty() ? valorPorDefecto : input;
    }
}
