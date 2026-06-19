(() => {
  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  const year = document.getElementById('year');
  if (year) {
    year.textContent = new Date().getFullYear();
  }

  const root = document.documentElement;
  const themeToggle = document.querySelector('.theme-toggle');
  const themeIcon = document.querySelector('.theme-icon');

  const savedTheme = localStorage.getItem('portfolio-theme');
  const initialTheme = savedTheme || (root.dataset.theme || 'dark');
  root.dataset.theme = initialTheme;
  updateThemeIcon(initialTheme);

  themeToggle?.addEventListener('click', () => {
    const nextTheme = root.dataset.theme === 'dark' ? 'light' : 'dark';
    root.dataset.theme = nextTheme;
    localStorage.setItem('portfolio-theme', nextTheme);
    updateThemeIcon(nextTheme);
  });

  function updateThemeIcon(theme) {
    if (!themeIcon) return;
    themeIcon.textContent = theme === 'dark' ? '☾' : '☀';
  }

  const navToggle = document.querySelector('.nav-toggle');
  const navMenu = document.getElementById('nav-menu');

  navToggle?.addEventListener('click', () => {
    const isOpen = navMenu.classList.toggle('is-open');
    navToggle.setAttribute('aria-expanded', String(isOpen));
    navToggle.setAttribute('aria-label', isOpen ? 'Cerrar menú' : 'Abrir menú');
  });

  navMenu?.querySelectorAll('a').forEach((link) => {
    link.addEventListener('click', () => {
      navMenu.classList.remove('is-open');
      navToggle?.setAttribute('aria-expanded', 'false');
      navToggle?.setAttribute('aria-label', 'Abrir menú');
    });
  });

  const navLinks = Array.from(document.querySelectorAll('.nav-menu a'));
  const sections = navLinks
    .map((link) => document.querySelector(link.getAttribute('href')))
    .filter(Boolean);

  const setActiveLink = (id) => {
    navLinks.forEach((link) => {
      link.classList.toggle('is-active', link.getAttribute('href') === `#${id}`);
    });
  };

  if ('IntersectionObserver' in window && sections.length) {
    const sectionObserver = new IntersectionObserver(
      (entries) => {
        const visibleEntry = entries.find((entry) => entry.isIntersecting);
        if (visibleEntry) setActiveLink(visibleEntry.target.id);
      },
      { rootMargin: '-45% 0px -50% 0px', threshold: 0.01 }
    );

    sections.forEach((section) => sectionObserver.observe(section));
  }

  const filterButtons = Array.from(document.querySelectorAll('.filter-btn'));
  const projectCards = Array.from(document.querySelectorAll('.project-card'));

  filterButtons.forEach((button) => {
    button.addEventListener('click', () => {
      const filter = button.dataset.filter;

      filterButtons.forEach((item) => item.classList.toggle('is-active', item === button));

      projectCards.forEach((card) => {
        const categories = card.dataset.category?.split(' ') || [];
        const shouldShow = filter === 'all' || categories.includes(filter);
        card.classList.toggle('is-hidden', !shouldShow);
      });
    });
  });

  const revealItems = Array.from(document.querySelectorAll('[data-reveal]'));

  if ('IntersectionObserver' in window && !prefersReducedMotion) {
    const revealObserver = new IntersectionObserver(
      (entries, observer) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: '0px 0px -8% 0px' }
    );

    revealItems.forEach((item) => revealObserver.observe(item));
  } else {
    revealItems.forEach((item) => item.classList.add('is-visible'));
  }

  const form = document.getElementById('contact-form');
  const status = document.getElementById('form-status');

  form?.addEventListener('submit', (event) => {
    event.preventDefault();

    const formData = new FormData(form);
    const name = String(formData.get('nombre') || '').trim();
    const email = String(formData.get('email') || '').trim();
    const message = String(formData.get('mensaje') || '').trim();
    const targetEmail = form.dataset.email || '';

    setStatus('');

    if (!name || !email || !message) {
      setStatus('Por favor completa todos los campos.', 'error');
      return;
    }

    if (!targetEmail || targetEmail.includes('dominio.com')) {
      setStatus('Configura un correo real en data-email antes de publicar el portafolio.', 'error');
      return;
    }

    const subject = encodeURIComponent(`Portafolio - ${name}`);
    const body = encodeURIComponent(`${message}\n\nNombre: ${name}\nEmail: ${email}`);
    window.location.href = `mailto:${targetEmail}?subject=${subject}&body=${body}`;
    setStatus('Abriendo tu cliente de correo...', 'success');
  });

  function setStatus(message, type) {
    if (!status) return;
    status.textContent = message;
    status.classList.remove('success', 'error');
    if (type) status.classList.add(type);
  }
})();
