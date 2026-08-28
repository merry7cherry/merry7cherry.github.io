function initIdentityTyping() {
  var target = document.querySelector(".intro-identity-dynamic");
  if (!target) {
    return;
  }

  var identities = [
    "a Ph.D. Student",
    "a Generative Modeling Researcher",
    "an Amateur Chef",
    "a Sports Enthusiast",
    "a Guitar Player"
  ];

  if (window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
    target.textContent = identities[0];
    return;
  }

  var identityIndex = 0;
  var charIndex = identities[identityIndex].length;
  var deleting = true;

  function tickIdentity() {
    var currentIdentity = identities[identityIndex];

    if (deleting) {
      charIndex -= 1;
    } else {
      charIndex += 1;
    }

    target.textContent = currentIdentity.slice(0, charIndex);

    var delay = deleting ? 38 : 78;
    if (!deleting && charIndex === currentIdentity.length) {
      delay = 1450;
      deleting = true;
    } else if (deleting && charIndex === 0) {
      deleting = false;
      identityIndex = (identityIndex + 1) % identities.length;
      delay = 280;
    }

    window.setTimeout(tickIdentity, delay);
  }

  window.setTimeout(tickIdentity, 1200);
}

function initPublicationLightbox() {
  var dialog = document.getElementById("publication-lightbox");
  var triggers = document.querySelectorAll(".pub-thumb-trigger");
  if (!dialog || !triggers.length) {
    return;
  }

  var lightboxImage = dialog.querySelector(".publication-lightbox-image");
  var lightboxCaption = dialog.querySelector(".publication-lightbox-caption");
  var closeButton = dialog.querySelector(".publication-lightbox-close");
  var siteShell = document.getElementById("site-shell");
  var activeTrigger = null;

  if (!lightboxImage || !lightboxCaption || !closeButton) {
    return;
  }

  function closeLightbox() {
    if (!dialog.hidden) {
      dialog.hidden = true;
      dialog.classList.remove("is-open");
      document.body.classList.remove("publication-lightbox-open");
      if (siteShell) {
        siteShell.removeAttribute("inert");
      }
      lightboxImage.removeAttribute("src");
      if (activeTrigger) {
        var triggerToRestore = activeTrigger;
        activeTrigger = null;
        triggerToRestore.focus();
      }
    }
  }

  triggers.forEach(function (trigger) {
    trigger.addEventListener("click", function () {
      var thumbnail = trigger.querySelector(".pub-thumb");
      if (!thumbnail) {
        return;
      }

      activeTrigger = trigger;
      lightboxImage.src = thumbnail.getAttribute("data-full-src") || thumbnail.currentSrc || thumbnail.src;
      lightboxImage.alt = thumbnail.alt;
      lightboxCaption.textContent = trigger.getAttribute("data-lightbox-caption") || thumbnail.alt;
      document.body.classList.add("publication-lightbox-open");
      dialog.hidden = false;
      dialog.classList.add("is-open");
      closeButton.focus();
      if (siteShell) {
        siteShell.setAttribute("inert", "");
      }
    });
  });

  closeButton.addEventListener("click", closeLightbox);
  lightboxImage.addEventListener("click", closeLightbox);
  dialog.addEventListener("click", function (event) {
    if (event.target === dialog) {
      closeLightbox();
    }
  });

  dialog.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
      event.preventDefault();
      closeLightbox();
    } else if (event.key === "Tab") {
      event.preventDefault();
      closeButton.focus();
    }
  });
}

document.addEventListener("DOMContentLoaded", function () {
  initIdentityTyping();
  initPublicationLightbox();

  document.querySelectorAll('a[target="_blank"]').forEach(function (link) {
    link.rel = "noopener noreferrer";
  });

  document.addEventListener("click", function (event) {
    var toggle = event.target.closest(".navbar-custom .nav-dropdown-toggle");
    var openMenus = document.querySelectorAll(".navbar-custom .dropdown-menu.show");
    var menu = toggle ? toggle.closest(".dropdown").querySelector(".dropdown-menu") : null;

    openMenus.forEach(function (openMenu) {
      if (!toggle || openMenu !== menu) {
        openMenu.classList.remove("show");
        var owner = openMenu.closest(".dropdown").querySelector(".nav-dropdown-toggle");
        if (owner) {
          owner.setAttribute("aria-expanded", "false");
        }
      }
    });

    if (!toggle) {
      return;
    }

    event.preventDefault();
    event.stopPropagation();

    if (!menu) {
      return;
    }

    var isOpen = menu.classList.toggle("show");
    toggle.setAttribute("aria-expanded", isOpen ? "true" : "false");
  }, true);

  var navbarToggle = document.getElementById("navbarToggle");
  var navbarButton = document.querySelector(".navbar-toggler");
  if (!navbarToggle || !navbarButton) {
    return;
  }

  function closeMobileNavbar() {
    function applyClosedState() {
      navbarToggle.classList.remove("show", "collapsing");
      navbarToggle.classList.add("collapse");
      navbarToggle.style.height = "";
      navbarButton.setAttribute("aria-expanded", "false");
    }

    if (window.jQuery && window.jQuery.fn && window.jQuery.fn.collapse) {
      window.jQuery(navbarToggle).collapse("hide");
    }
    applyClosedState();
    window.setTimeout(applyClosedState, 380);
  }

  navbarToggle.querySelectorAll(".nav-link, .dropdown-item").forEach(function (link) {
    link.addEventListener("click", function () {
      closeMobileNavbar();

      navbarToggle.querySelectorAll(".dropdown-menu.show").forEach(function (menu) {
        menu.classList.remove("show");
        var owner = menu.closest(".dropdown").querySelector(".nav-dropdown-toggle");
        if (owner) {
          owner.setAttribute("aria-expanded", "false");
        }
      });
    });
  });
});
