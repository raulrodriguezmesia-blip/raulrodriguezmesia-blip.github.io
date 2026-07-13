package com.raulrodriguez.portfolio.service;

import com.raulrodriguez.portfolio.model.Usuario;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class ApiService {
    private static final Logger logger = Logger.getLogger(ApiService.class.getName());
    private static final String BASE_URL = "https://jsonplaceholder.typicode.com";
    private final HttpClient client;
    private final ObjectMapper mapper;

    public ApiService() {
        this.client = HttpClient.newHttpClient();
        this.mapper = new ObjectMapper();
    }

    public Usuario obtenerUsuarioDesdeAPI(int id) throws IOException, InterruptedException {
        String url = BASE_URL + "/users/" + id;

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new IOException("Error HTTP: " + response.statusCode());
        }

        // Mapeo campos API a nuestra clase Usuario
        JsonUsuario jsonUsuario = mapper.readValue(response.body(), JsonUsuario.class);

        Usuario usuario = new Usuario();
        usuario.setId(jsonUsuario.getId());
        usuario.setNombre(jsonUsuario.getName());
        usuario.setEmail(jsonUsuario.getEmail());
        usuario.setEdad(25); // La API no proporciona edad, asignamos valor de ejemplo

        return usuario;
    }

    public List<Usuario> obtenerTodosUsuariosAPI() throws IOException, InterruptedException {
        String url = BASE_URL + "/users";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new IOException("Error HTTP: " + response.statusCode());
        }

        JsonUsuario[] usuariosJson = mapper.readValue(response.body(), JsonUsuario[].class);
        List<Usuario> usuarios = new ArrayList<>();

        for (JsonUsuario json : usuariosJson) {
            Usuario u = new Usuario();
            u.setId(json.getId());
            u.setNombre(json.getName());
            u.setEmail(json.getEmail());
            u.setEdad(25); // Valor por defecto
            usuarios.add(u);
        }

        return usuarios;
    }

    // Clase auxiliar para deserializar JSON de la API
    @JsonIgnoreProperties(ignoreUnknown = true)
    private static class JsonUsuario {
        private int id;
        private String name;
        private String email;
        // Campos ignorados: address, phone, username, website, company, etc.

        // Getters
        public int getId() { return id; }
        public String getName() { return name; }
        public String getEmail() { return email; }

        // Setters (Jackson los necesita)
        public void setId(int id) { this.id = id; }
        public void setName(String name) { this.name = name; }
        public void setEmail(String email) { this.email = email; }
    }
}
