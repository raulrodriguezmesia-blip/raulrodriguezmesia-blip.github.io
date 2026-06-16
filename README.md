# Raúl Rodriguez Mesia | Portafolio

Portafolio profesional estático para GitHub Pages.

## Estructura actual

```text
.
├── index.html
├── styles.css
├── script.js
├── README.md
└── Raul_Rodriguez_Mesia_CV.pdf
```

## Contenido incluido

- Página principal responsive y accesible.
- Secciones: inicio, sobre mí, skills, proyectos, experiencia y contacto.
- Filtro de proyectos por categoría.
- Cambio de tema claro/oscuro.
- Formulario de contacto con apertura de cliente de correo.
- CV descargable.

## Personalización rápida

Antes de publicar o compartir el portafolio, actualiza estos puntos:

1. En `index.html`, cambia el correo de contacto:

```html
<form id="contact-form" class="contact-form" data-email="tu-email@dominio.com">
```

por tu email real:

```html
<form id="contact-form" class="contact-form" data-email="tu-correo@ejemplo.com">
```

2. Reemplaza `Raul_Rodriguez_Mesia_CV.pdf` por tu CV actualizado si lo necesitas.

3. Añade más proyectos en la sección `#proyectos` usando la misma estructura de tarjetas.

## Ejecutar localmente

Abre `index.html` directamente en el navegador o ejecuta un servidor local:

```powershell
python -m http.server 8000
```

Luego abre:

```text
http://localhost:8000
```

## Despliegue

Este repositorio está preparado para GitHub Pages desde la rama `main` usando la raíz del proyecto.
