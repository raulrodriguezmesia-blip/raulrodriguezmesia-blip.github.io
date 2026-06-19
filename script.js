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

  const bgCanvas = document.getElementById('bg-canvas');
  const isTouchDevice = 'ontouchstart' in window || navigator.maxTouchPoints > 0;
  const particleCount = isTouchDevice ? 45 : 90;
  const connectionDistance = isTouchDevice ? 95 : 130;
  const mouseDistance = 150;

  if (bgCanvas && !prefersReducedMotion) {
    const ctx = bgCanvas.getContext('2d');
    const mouse = { x: 0, y: 0, active: !isTouchDevice };
    let particles = [];
    let width = 0;
    let height = 0;

    function random(min, max) {
      return Math.random() * (max - min) + min;
    }

    function resizeCanvas() {
      width = window.innerWidth;
      height = window.innerHeight;
      bgCanvas.width = width * window.devicePixelRatio;
      bgCanvas.height = height * window.devicePixelRatio;
      bgCanvas.style.width = `${width}px`;
      bgCanvas.style.height = `${height}px`;
      ctx.setTransform(window.devicePixelRatio, 0, 0, window.devicePixelRatio, 0, 0);
      createParticles();
    }

    function createParticles() {
      particles = Array.from({ length: particleCount }, () => ({
        x: random(0, width),
        y: random(0, height),
        vx: random(-0.25, 0.25),
        vy: random(-0.25, 0.25),
        size: random(1.2, 2.4),
        color: Math.random() > 0.5 ? '56, 189, 248' : '6, 182, 212',
        alpha: random(0.15, 0.25)
      }));
    }

    function updateParticles() {
      particles.forEach((particle) => {
        particle.x += particle.vx;
        particle.y += particle.vy;

        if (particle.x < 0 || particle.x > width) particle.vx *= -1;
        if (particle.y < 0 || particle.y > height) particle.vy *= -1;

        if (!isTouchDevice && mouse.active) {
          const dx = mouse.x - particle.x;
          const dy = mouse.y - particle.y;
          const distance = Math.sqrt(dx * dx + dy * dy);

          if (distance < mouseDistance) {
            const force = (mouseDistance - distance) / mouseDistance;
            particle.x -= (dx / distance) * force * 0.65;
            particle.y -= (dy / distance) * force * 0.65;
          }
        }
      });
    }

    function drawConnections() {
      for (let i = 0; i < particles.length; i++) {
        for (let j = i + 1; j < particles.length; j++) {
          const dx = particles[i].x - particles[j].x;
          const dy = particles[i].y - particles[j].y;
          const distance = Math.sqrt(dx * dx + dy * dy);

          if (distance < connectionDistance) {
            const opacity = (1 - distance / connectionDistance) * 0.22;
            ctx.beginPath();
            ctx.moveTo(particles[i].x, particles[i].y);
            ctx.lineTo(particles[j].x, particles[j].y);
            ctx.strokeStyle = `rgba(56, 189, 248, ${opacity})`;
            ctx.lineWidth = 0.5;
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
      requestAnimationFrame(animate);
    }

    window.addEventListener('resize', resizeCanvas, { passive: true });

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

    resizeCanvas();
    animate();
  }

  form?.addEventListener('submit', (event) => {
    event.preventDefault();

    const formData = new FormData(form);
    const name = String(formData.get('nombre') || '').trim();
    const email = String(formData.get('email') || '').trim();
    const message = String(formData.get('mensaje') || '').trim();

    setStatus('');

    if (!name || !email || !message) {
      setStatus('Por favor completa todos los campos.', 'error');
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
    })
      .then((response) => {
        setLoading(false);
        if (response.ok) {
          setStatus('¡Mensaje enviado! Gracias por contactarme.', 'success');
          form.reset();
        } else {
          setStatus('Oops! Hubo un problema al enviar. Intenta más tarde.', 'error');
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

  function setLoading(isLoading) {
    const submitBtn = form.querySelector('button[type="submit"]');
    if (!submitBtn) return;
    submitBtn.disabled = isLoading;
    submitBtn.textContent = isLoading ? 'Enviando...' : 'Enviar mensaje';
  }
})();
