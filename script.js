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

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && navMenu?.classList.contains('is-open')) {
      navMenu.classList.remove('is-open');
      navToggle?.setAttribute('aria-expanded', 'false');
      navToggle?.setAttribute('aria-label', 'Abrir menú');
      navToggle?.focus();
    }
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
      const isActive = link.getAttribute('href') === `#${id}`;
      link.classList.toggle('is-active', isActive);
      if (isActive) {
        link.setAttribute('aria-current', 'page');
      } else {
        link.removeAttribute('aria-current');
      }
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
    button.setAttribute('aria-pressed', button.classList.contains('is-active') ? 'true' : 'false');

    button.addEventListener('click', () => {
      const filter = button.dataset.filter;

      filterButtons.forEach((item) => {
        const isActive = item === button;
        item.classList.toggle('is-active', isActive);
        item.setAttribute('aria-pressed', String(isActive));
      });

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

  const bgCanvas = document.getElementById('bg-canvas');
  const isTouchDevice = 'ontouchstart' in window || navigator.maxTouchPoints > 0;
  const particleCount = isTouchDevice ? 32 : 70;
  const connectionDistance = isTouchDevice ? 82 : 118;
  const mouseDistance = 140;
  const reducedPixelRatio = Math.min(window.devicePixelRatio || 1, 1.5);

  if (bgCanvas && !prefersReducedMotion) {
    const ctx = bgCanvas.getContext('2d');
    const mouse = { x: 0, y: 0, active: !isTouchDevice };
    let particles = [];
    let width = 0;
    let height = 0;
    let animationId = 0;

    function random(min, max) {
      return Math.random() * (max - min) + min;
    }

    function resizeCanvas() {
      width = window.innerWidth;
      height = window.innerHeight;
      bgCanvas.width = Math.floor(width * reducedPixelRatio);
      bgCanvas.height = Math.floor(height * reducedPixelRatio);
      bgCanvas.style.width = `${width}px`;
      bgCanvas.style.height = `${height}px`;
      ctx.setTransform(reducedPixelRatio, 0, 0, reducedPixelRatio, 0, 0);
      createParticles();
    }

    function createParticles() {
      particles = Array.from({ length: particleCount }, () => ({
        x: random(0, width),
        y: random(0, height),
        vx: random(-0.18, 0.18),
        vy: random(-0.18, 0.18),
        size: random(1, 2.1),
        color: Math.random() > 0.5 ? '56, 189, 248' : '6, 182, 212',
        alpha: random(0.15, 0.22)
      }));
    }

    function updateParticles() {
      particles.forEach((particle) => {
        particle.x += particle.vx;
        particle.y += particle.vy;

        if (particle.x < -10 || particle.x > width + 10) particle.vx *= -1;
        if (particle.y < -10 || particle.y > height + 10) particle.vy *= -1;

        if (!isTouchDevice && mouse.active) {
          const dx = mouse.x - particle.x;
          const dy = mouse.y - particle.y;
          const distance = Math.sqrt(dx * dx + dy * dy);

          if (distance < mouseDistance && distance > 0.1) {
            const force = (mouseDistance - distance) / mouseDistance;
            particle.x -= (dx / distance) * force * 0.45;
            particle.y -= (dy / distance) * force * 0.45;
          }
        }
      });
    }

    function drawConnections() {
      ctx.lineWidth = 0.5;
      for (let i = 0; i < particles.length; i++) {
        for (let j = i + 1; j < particles.length; j++) {
          const dx = particles[i].x - particles[j].x;
          const dy = particles[i].y - particles[j].y;
          const distance = Math.sqrt(dx * dx + dy * dy);

          if (distance < connectionDistance) {
            const opacity = (1 - distance / connectionDistance) * 0.18;
            ctx.beginPath();
            ctx.moveTo(particles[i].x, particles[i].y);
            ctx.lineTo(particles[j].x, particles[j].y);
            ctx.strokeStyle = `rgba(56, 189, 248, ${opacity})`;
            ctx.stroke();
          }
        }
      }
    }

    function drawParticles() {
      particles.forEach((particle) => {
        ctx.beginPath();
        ctx.arc(particle.x, particle.y, particle.size, 0, Math.PI * 2);
        ctx.fillStyle = `rgba(${particle.color}, ${particle.alpha})`;
        ctx.fill();
      });
    }

    function animate() {
      ctx.clearRect(0, 0, width, height);
      updateParticles();
      drawConnections();
      drawParticles();
      animationId = requestAnimationFrame(animate);
    }

    function start() {
      cancelAnimationFrame(animationId);
      resizeCanvas();
      animate();
    }

    window.addEventListener('resize', start, { passive: true });

    if (!isTouchDevice) {
      window.addEventListener('mousemove', (event) => {
        mouse.x = event.clientX;
        mouse.y = event.clientY;
        mouse.active = true;
      }, { passive: true });

      window.addEventListener('mouseleave', () => {
        mouse.active = false;
      }, { passive: true });
    }

    document.addEventListener('visibilitychange', () => {
      if (document.hidden) {
        cancelAnimationFrame(animationId);
      } else {
        start();
      }
    });

    start();
  }

  form?.addEventListener('submit', (event) => {
    event.preventDefault();
    setStatus('', '');
    hints.forEach((h) => (h.textContent = ''));

    const formData = new FormData(form);
    const name = String(formData.get('nombre') || '').trim();
    const email = String(formData.get('email') || '').trim();
    const message = String(formData.get('mensaje') || '').trim();

    clearFormErrors();
    setStatus('');

    if (!name) {
      setFieldError('nombre', 'Ingresa tu nombre.');
      setStatus('Revisa los campos marcados.', 'error');
      return;
    }

    if (!email) {
      setFieldError('email', 'Ingresa tu email.');
      setStatus('Revisa los campos marcados.', 'error');
      return;
    }

    if (!isValidEmail(email)) {
      setFieldError('email', 'Ingresa un email válido.');
      setStatus('Revisa los campos marcados.', 'error');
      return;
    }

    if (!message) {
      setFieldError('mensaje', 'Escribe un mensaje.');
      setStatus('Revisa los campos marcados.', 'error');
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
      headers: {
        Accept: 'application/json'
      }
      headers: { Accept: 'application/json' }
    })
      .then((response) => {
        setLoading(false);
        if (response.ok) {
          setStatus('¡Mensaje enviado! Gracias por contactarme.', 'success');
          form.reset();
          clearFormErrors();
        } else {
          setStatus('Oops! Hubo un problema al enviar. Intenta más tarde.', 'error');
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

  function setStatus(message, type) {
    if (!status) return;
    status.textContent = message;
    status.classList.remove('success', 'error');
    if (type) status.classList.add(type);
  }

  function setFieldError(fieldId, message) {
    const field = document.getElementById(fieldId);
    const hint = document.getElementById(`${fieldId}-hint`);
    if (!field || !hint) return;

    field.setAttribute('aria-invalid', 'true');
    hint.textContent = message;
  }

  function clearFormErrors() {
    ['nombre', 'email', 'mensaje'].forEach((fieldId) => {
      const field = document.getElementById(fieldId);
      const hint = document.getElementById(`${fieldId}-hint`);
      if (!field || !hint) return;

      field.setAttribute('aria-invalid', 'false');
      hint.textContent = '';
    });
  }

  function isValidEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  }

  function setLoading(isLoading) {
    const submitBtn = form?.querySelector('button[type="submit"]');
    if (!submitBtn) return;
    submitBtn.disabled = isLoading;
    submitBtn.textContent = isLoading ? 'Enviando...' : 'Enviar mensaje';
  }
  form?.querySelectorAll('input, textarea').forEach((el) => {
    el.addEventListener('input', () => setFieldHint(el, ''));
  });
})();
