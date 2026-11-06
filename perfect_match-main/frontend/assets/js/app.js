/**
 * PERFECT MATCH — Core Application JS
 * Handles: navigation, auth state, mock data, helpers, UI interactions
 */

'use strict';

/* ============================================================
   MOCK DATA — Replace with actual backend responses
   ============================================================ */
const PM_MOCK = {
  // Auth state
  isLoggedIn: false,
  currentUser: null,

  // Sample user
  sampleUser: {
    id: 1,
    fullName: 'Andrei Santos',
    email: 'andrei.santos@email.com',
    createdAt: '2026-01-15',
    totalAnalyses: 7
  },

  // Sample analysis result
  sampleResult: {
    id: 'ana_001',
    date: 'September 8, 2026',
    imageUrl: null, // replaced by uploaded image
    skinTone: 'Light Morena',
    skinType: 'Combination',
    undertone: 'Warm',
    confidence: 87,
    palette: {
      foundation: [
        { name: 'Warm Ivory',    hex: '#F5DEB3', note: 'Perfect base for light morena with warm undertones.' },
        { name: 'Golden Beige',  hex: '#D4A76A', note: 'Provides a seamless, natural finish.' },
        { name: 'Soft Sand',     hex: '#C8A882', note: 'Great for a light, everyday look.' }
      ],
      blush: [
        { name: 'Warm Peach',   hex: '#FFAB76', note: 'Adds a natural, sun-kissed glow.' },
        { name: 'Coral Flush',  hex: '#E8835A', note: 'Brightens warm undertones beautifully.' },
        { name: 'Rose Nude',    hex: '#D4967A', note: 'A soft, everyday blush for warm skin.' }
      ],
      lip: [
        { name: 'Warm Rose',    hex: '#B76E79', note: 'Complements warm undertones perfectly.' },
        { name: 'Terracotta',   hex: '#C0614B', note: 'A bold, earthy statement color.' },
        { name: 'Nude Mauve',   hex: '#A07468', note: 'A wearable, natural everyday shade.' },
        { name: 'Berry Bronze', hex: '#8B4049', note: 'Great for evening looks.' }
      ],
      eyeshadow: [
        { name: 'Bronze Glow',    hex: '#8B6252', note: 'Enhances warm, deep eye looks.' },
        { name: 'Champagne',      hex: '#D4B896', note: 'A soft highlight for the lid.' },
        { name: 'Warm Taupe',     hex: '#9C7D6A', note: 'Excellent for crease definition.' },
        { name: 'Copper Shimmer', hex: '#B87333', note: 'Adds dimension and warmth.' }
      ]
    }
  },

  // Sample history
  sampleHistory: [
    {
      id: 'ana_001',
      date: 'September 8, 2026',
      skinTone: 'Light Morena',
      skinType: 'Combination',
      undertone: 'Warm',
      palettePreview: ['#B76E79', '#FFAB76', '#D4A76A', '#8B6252']
    },
    {
      id: 'ana_002',
      date: 'August 22, 2026',
      skinTone: 'Morena',
      skinType: 'Oily',
      undertone: 'Neutral',
      palettePreview: ['#C0614B', '#E8835A', '#C8956C', '#5C3D2E']
    },
    {
      id: 'ana_003',
      date: 'July 30, 2026',
      skinTone: 'Light',
      skinType: 'Dry',
      undertone: 'Cool',
      palettePreview: ['#D4778A', '#F4A7B9', '#E8C5C5', '#7B5EA7']
    }
  ]
};

/* ============================================================
   AUTH HELPERS
   ============================================================ */
const Auth = {
  login(user) {
    PM_MOCK.isLoggedIn = true;
    PM_MOCK.currentUser = user || PM_MOCK.sampleUser;
    sessionStorage.setItem('pm_logged_in', 'true');
    sessionStorage.setItem('pm_user', JSON.stringify(PM_MOCK.currentUser));
    Nav.update();
  },
  logout() {
    PM_MOCK.isLoggedIn = false;
    PM_MOCK.currentUser = null;
    sessionStorage.removeItem('pm_logged_in');
    sessionStorage.removeItem('pm_user');
    Nav.update();
    window.location.href = 'index.html';
  },
  check() {
    const loggedIn = sessionStorage.getItem('pm_logged_in') === 'true';
    const userStr  = sessionStorage.getItem('pm_user');
    PM_MOCK.isLoggedIn = loggedIn;
    if (loggedIn && userStr) {
      try { PM_MOCK.currentUser = JSON.parse(userStr); } catch(e) {}
    }
    return PM_MOCK.isLoggedIn;
  },
  requireAuth(redirectUrl = 'login.html') {
    if (!this.check()) window.location.href = redirectUrl;
  },
  getUser() {
    this.check();
    return PM_MOCK.currentUser;
  }
};

/* ============================================================
   NAVIGATION
   ============================================================ */
const Nav = {
  update() {
    const loggedIn = Auth.check();

    // Guest nav elements
    document.querySelectorAll('[data-show="guest"]').forEach(el => {
      el.style.display = loggedIn ? 'none' : '';
    });
    // Logged-in nav elements
    document.querySelectorAll('[data-show="auth"]').forEach(el => {
      el.style.display = loggedIn ? '' : 'none';
    });

    // User name
    const user = PM_MOCK.currentUser;
    if (user) {
      document.querySelectorAll('[data-user-name]').forEach(el => {
        el.textContent = user.fullName;
      });
      document.querySelectorAll('[data-user-initials]').forEach(el => {
        el.textContent = user.fullName.split(' ').map(n => n[0]).join('').slice(0,2).toUpperCase();
      });
    }
  },

  setActive() {
    const current = window.location.pathname.split('/').pop() || 'index.html';
    document.querySelectorAll('.pm-navbar .nav-link').forEach(link => {
      const href = link.getAttribute('href') || '';
      if (href === current || (current === '' && href === 'index.html')) {
        link.classList.add('active');
      }
    });
  },

  initScrollBehavior() {
    const navbar = document.querySelector('.pm-navbar');
    if (!navbar) return;
    const onScroll = () => {
      navbar.classList.toggle('scrolled', window.scrollY > 20);
    };
    window.addEventListener('scroll', onScroll, { passive: true });
  }
};

/* ============================================================
   FORM UTILITIES
   ============================================================ */
const FormUtils = {
  validate(form) {
    let valid = true;
    form.querySelectorAll('[data-validate]').forEach(input => {
      const rules = input.dataset.validate.split('|');
      let fieldValid = true;
      let errorMsg   = '';

      rules.forEach(rule => {
        if (!fieldValid) return;
        if (rule === 'required' && !input.value.trim()) {
          fieldValid = false; errorMsg = 'This field is required.';
        }
        if (rule === 'email' && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(input.value)) {
          fieldValid = false; errorMsg = 'Please enter a valid email address.';
        }
        if (rule.startsWith('min:')) {
          const min = parseInt(rule.split(':')[1]);
          if (input.value.length < min) { fieldValid = false; errorMsg = `Minimum ${min} characters required.`; }
        }
        if (rule === 'match') {
          const target = document.getElementById(input.dataset.matchTarget);
          if (target && input.value !== target.value) { fieldValid = false; errorMsg = 'Passwords do not match.'; }
        }
      });

      const errEl = form.querySelector(`[data-error-for="${input.id}"]`);
      input.classList.toggle('is-invalid', !fieldValid);
      if (errEl) { errEl.textContent = errorMsg; errEl.classList.toggle('visible', !fieldValid); }
      if (!fieldValid) valid = false;
    });
    return valid;
  },

  showFieldError(inputId, message) {
    const input = document.getElementById(inputId);
    const errEl = document.querySelector(`[data-error-for="${inputId}"]`);
    if (input) input.classList.add('is-invalid');
    if (errEl) { errEl.textContent = message; errEl.classList.add('visible'); }
  },

  clearErrors(form) {
    form.querySelectorAll('.pm-input').forEach(i => i.classList.remove('is-invalid'));
    form.querySelectorAll('.pm-field-error').forEach(e => e.classList.remove('visible'));
  }
};

/* ============================================================
   PASSWORD TOGGLE
   ============================================================ */
function initPasswordToggles() {
  document.querySelectorAll('.pm-password-toggle').forEach(btn => {
    btn.addEventListener('click', () => {
      const input = btn.closest('.pm-input-icon-wrap').querySelector('input');
      if (!input) return;
      const isText = input.type === 'text';
      input.type = isText ? 'password' : 'text';
      btn.innerHTML = isText
        ? '<i class="bi bi-eye"></i>'
        : '<i class="bi bi-eye-slash"></i>';
    });
  });
}

/* ============================================================
   UPLOAD / DRAG-DROP
   ============================================================ */
function initDropZone(dropEl, fileInput, onFile) {
  if (!dropEl || !fileInput) return;

  dropEl.addEventListener('click', () => fileInput.click());

  dropEl.addEventListener('dragover', e => {
    e.preventDefault();
    dropEl.classList.add('drag-over');
  });

  dropEl.addEventListener('dragleave', () => dropEl.classList.remove('drag-over'));

  dropEl.addEventListener('drop', e => {
    e.preventDefault();
    dropEl.classList.remove('drag-over');
    const file = e.dataTransfer.files[0];
    if (file) handleFileValidation(file, onFile);
  });

  fileInput.addEventListener('change', () => {
    const file = fileInput.files[0];
    if (file) handleFileValidation(file, onFile);
  });
}

function handleFileValidation(file, onFile) {
  const allowed = ['image/jpeg', 'image/png', 'image/jpg'];
  if (!allowed.includes(file.type)) {
    showToast('Invalid image. Please upload a JPG or PNG file.', 'error');
    return;
  }
  if (file.size > 10 * 1024 * 1024) {
    showToast('Image too large. Maximum file size is 10MB.', 'error');
    return;
  }
  // Read the file into a data URL (a blob: URL stops working after the page changes,
  // so the photo would disappear on the next page). Shrink big photos so they fit in
  // sessionStorage and upload quickly to the backend.
  const reader = new FileReader();
  reader.onload = () => {
    const img = new Image();
    img.onload = () => {
      const scale = Math.min(1, 1000 / Math.max(img.naturalWidth, img.naturalHeight));
      const c = document.createElement('canvas');
      c.width  = Math.round(img.naturalWidth  * scale);
      c.height = Math.round(img.naturalHeight * scale);
      c.getContext('2d').drawImage(img, 0, 0, c.width, c.height);
      if (onFile) onFile(file, c.toDataURL('image/jpeg', 0.9));
    };
    img.onerror = () => showToast('Could not read that image. Please try another one.', 'error');
    img.src = reader.result;
  };
  reader.onerror = () => showToast('Could not read that image. Please try another one.', 'error');
  reader.readAsDataURL(file);
}

/* ============================================================
   TOAST NOTIFICATIONS
   ============================================================ */
function showToast(message, type = 'info', duration = 3500) {
  let container = document.getElementById('pm-toast-container');
  if (!container) {
    container = document.createElement('div');
    container.id = 'pm-toast-container';
    container.style.cssText = `
      position:fixed; bottom:24px; right:24px; z-index:9999;
      display:flex; flex-direction:column; gap:8px; max-width:320px;
    `;
    document.body.appendChild(container);
  }

  const icons = { success: '✓', error: '✕', warning: '⚠', info: 'ℹ' };
  const colors = {
    success: '#4CAF50', error: '#E07272', warning: '#B8935A', info: '#8B6252'
  };

  const toast = document.createElement('div');
  toast.style.cssText = `
    background:#fff; border:1px solid #EDE0D0; border-left:3px solid ${colors[type]};
    border-radius:10px; padding:12px 16px; box-shadow:0 4px 16px rgba(61,35,20,0.12);
    display:flex; align-items:flex-start; gap:10px; font-size:0.875rem;
    color:#3D2314; animation:fadeInUp 0.3s ease;
    font-family:'Inter','Segoe UI',system-ui,sans-serif;
  `;
  toast.innerHTML = `
    <span style="color:${colors[type]};font-weight:700;font-size:1rem;flex-shrink:0;">${icons[type]}</span>
    <span style="flex:1;line-height:1.45;">${message}</span>
    <button onclick="this.closest('div').remove()" style="
      background:none;border:none;cursor:pointer;color:#A07860;
      font-size:1rem;line-height:1;padding:0;flex-shrink:0;
    ">×</button>
  `;
  container.appendChild(toast);
  setTimeout(() => toast.remove(), duration);
}

/* ============================================================
   SMOOTH SCROLL FOR ANCHOR LINKS
   ============================================================ */
function initSmoothScroll() {
  document.querySelectorAll('a[href^="#"]').forEach(a => {
    a.addEventListener('click', e => {
      const target = document.querySelector(a.getAttribute('href'));
      if (target) {
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    });
  });
}

/* ============================================================
   INTERSECTION OBSERVER — animate on scroll
   ============================================================ */
function initScrollAnimations() {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12 });

  document.querySelectorAll('.animate-on-scroll').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(24px)';
    el.style.transition = 'opacity 0.55s ease, transform 0.55s ease';
    observer.observe(el);
  });
}

/* ============================================================
   COLOR SWATCH HELPERS
   ============================================================ */
function hexToRgb(hex) {
  const r = parseInt(hex.slice(1,3), 16);
  const g = parseInt(hex.slice(3,5), 16);
  const b = parseInt(hex.slice(5,7), 16);
  return { r, g, b };
}

function lightOrDark(hex) {
  const { r, g, b } = hexToRgb(hex);
  const luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
  return luminance > 0.55 ? 'dark' : 'light';
}

function buildSwatchCard(color, containerId) {
  const textColor = lightOrDark(color.hex) === 'light' ? '#fff' : '#3D2314';
  return `
    <div class="swatch-card" title="${color.note}">
      <div class="swatch-circle" style="background:${color.hex};width:56px;height:56px;"></div>
      <div class="swatch-name">${color.name}</div>
      <div class="swatch-hex">${color.hex}</div>
      <div class="swatch-note">${color.note}</div>
    </div>
  `;
}

/* ============================================================
   NAV CLOSE ON LINK CLICK (MOBILE)
   ============================================================ */
function initNavClose() {
  const navCollapse = document.getElementById('pmNavbar');
  if (!navCollapse) return;
  navCollapse.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', () => {
      const bsCollapse = window.bootstrap?.Collapse.getInstance(navCollapse);
      if (bsCollapse) bsCollapse.hide();
    });
  });
}

/* ============================================================
   INIT — runs on every page
   ============================================================ */
document.addEventListener('DOMContentLoaded', () => {
  Auth.check();
  Nav.update();
  Nav.setActive();
  Nav.initScrollBehavior();
  initPasswordToggles();
  initSmoothScroll();
  initScrollAnimations();
  initNavClose();

  // Page-specific init
  const page = window.location.pathname.split('/').pop() || 'index.html';
  if (typeof window['initPage_' + page.replace('.html','')] === 'function') {
    window['initPage_' + page.replace('.html','')]();
  }
});