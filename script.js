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
  const submitBtn = form?.querySelector('.submit-btn');
  const btnText = submitBtn?.querySelector('.btn-text');
  const btnLoader = submitBtn?.querySelector('.btn-loader');
  const hints = form ? Array.from(form.querySelectorAll('.field-hint')) : [];
  const successAnim = document.getElementById('success-animation');

  function validateEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }

  function setFieldHint(input, message) {
    const hint = input.closest('.form-group')?.querySelector('.field-hint');
    if (!hint) return;
    hint.textContent = message || '';
    input.setAttribute('aria-invalid', message ? 'true' : 'false');
  }

  function setStatus(message, type) {
    if (!status) return;
    status.textContent = message;
    status.className = 'form-status ' + (type ? 'is-' + type : '');
  }

  function setLoading(isLoading) {
    if (!submitBtn) return;
    submitBtn.disabled = isLoading;
    if (btnText) btnText.hidden = isLoading;
    if (btnLoader) btnLoader.hidden = !isLoading;
  }

  form?.addEventListener('submit', (event) => {
    event.preventDefault();
    setStatus('', '');
    hints.forEach((h) => (h.textContent = ''));

    const nameInput = form.querySelector('#nombre');
    const emailInput = form.querySelector('#email');
    const messageInput = form.querySelector('#mensaje');

    const name = String(nameInput?.value || '').trim();
    const email = String(emailInput?.value || '').trim();
    const message = String(messageInput?.value || '').trim();
    let isValid = true;

    if (!name) {
      setFieldHint(nameInput, 'Por favor ingresa tu nombre.');
      isValid = false;
    }
    if (!email) {
      setFieldHint(emailInput, 'Por favor ingresa tu correo.');
      isValid = false;
    } else if (!validateEmail(email)) {
      setFieldHint(emailInput, 'Ingresa un correo válido.');
      isValid = false;
    }
    if (!message) {
      setFieldHint(messageInput, 'Escribe un mensaje para enviar.');
      isValid = false;
    }

    if (!isValid) {
      const firstInvalid = form.querySelector('[aria-invalid="true"]');
      firstInvalid?.focus();
      setStatus('Corrige los campos marcados.', 'error');
      return;
    }

    setLoading(true);
    setStatus('Enviando...', '');

    fetch(form.action, {
      method: form.method,
      body: new FormData(form),
      headers: { Accept: 'application/json' }
    })
      .then((response) => {
        setLoading(false);
        if (response.ok) {
          setStatus('¡Mensaje enviado! Gracias por contactarme.', 'success');
          form.reset();
          hints.forEach((h) => (h.textContent = ''));
          if (successAnim) {
            successAnim.hidden = false;
            successAnim.classList.add('is-visible');
          }
        } else {
          return response.json().then((data) => {
            const msg = data?.errors?.map((err) => err.message).join(', ');
            setStatus(msg || 'Oops! Hubo un problema al enviar. Intenta más tarde.', 'error');
          }).catch(() => setStatus('Oops! No pudimos procesar la respuesta.', 'error'));
        }
      })
      .catch(() => {
        setLoading(false);
        setStatus('Error de red. Revisa tu conexión e intenta de nuevo.', 'error');
      });
  });

  form?.querySelectorAll('input, textarea').forEach((el) => {
    el.addEventListener('input', () => setFieldHint(el, ''));
  });
})();
