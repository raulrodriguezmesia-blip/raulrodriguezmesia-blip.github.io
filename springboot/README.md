# ⚡ Spring Boot - API REST

![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.0+-green?style=for-the-badge&logo=spring)
![Java](https://img.shields.io/badge/Java-17+-blue?style=for-the-badge&logo=openjdk)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

## 📋 Descripción

Desarrollo de APIs RESTful utilizando Spring Boot. Implementación completa de arquitectura REST con manejo eficiente de peticiones y respuestas HTTP.

## 🎯 Características

- ✅ Endpoints RESTful bien definidos
- ✅ Implementación de operaciones CRUD
- ✅ Manejo de excepciones global
- ✅ Validación de datos
- ✅ Documentación con Swagger/OpenAPI
- ✅ Seguridad básica con Spring Security

## 🛠️ Tecnologías Utilizadas

- **Lenguaje**: Java 17+
- **Framework**: Spring Boot 3.0+
- **Base de Datos**: MySQL/H2
- **API**: REST (Representational State Transfer)
- **Build**: Maven

## 📁 Estructura del Proyecto

```bash
springboot/
├── src/
│   ├── main/
│   │   ├── java/com/example/
│   │   │   ├── controller/
│   │   │   ├── service/
│   │   │   ├── repository/
│   │   │   ├── model/
│   │   │   └── SpringbootApplication.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
├── pom.xml
└── README.md
```

## 🚀 Instalación

```bash
# Clonar el repositorio
git clone https://github.com/raulrodriguezmesia-blip/springboot.git

# Navegar al directorio
cd springboot

# Configurar base de datos en application.properties

# Compilar
mvn clean install

# Ejecutar
mvn spring-boot:run
```

## 📡 Endpoints

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | /api/v1/resource | Obtener todos |
| GET | /api/v1/resource/{id} | Obtener por ID |
| POST | /api/v1/resource | Crear nuevo |
| PUT | /api/v1/resource/{id} | Actualizar |
| DELETE | /api/v1/resource/{id} | Eliminar |

## 📊 Capturas de Pantalla

[Ver capturas en GitHub](https://github.com/raulrodriguezmesia-blip/springboot)

## 🤝 Contribución

Contribuciones son bienvenidas. Reporta issues o sugiere mejoras.

## 👨‍💻 Autor

**Raul Rodriguez Mesia**  
[GitHub](https://github.com/raulrodriguezmesia-blip) | [LinkedIn](https://www.linkedin.com/in/raul-rodriguez-mesia/)

---

*APIs modernas y eficientes con Spring Boot.*