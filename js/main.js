// Optional: publication filter (showPubs) - template may call showPubs(1)
function showPubs(n) { return true; }

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
  var activeTrigger = null;

  if (!lightboxImage || !lightboxCaption || !closeButton) {
    return;
  }

  function closeLightbox() {
    if (!dialog.hidden) {
      dialog.hidden = true;
      dialog.classList.remove("is-open");
      document.body.classList.remove("publication-lightbox-open");
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
      lightboxImage.src = thumbnail.currentSrc || thumbnail.src;
      lightboxImage.alt = thumbnail.alt;
      lightboxCaption.textContent = trigger.getAttribute("data-lightbox-caption") || thumbnail.alt;
      document.body.classList.add("publication-lightbox-open");
      dialog.hidden = false;
      dialog.classList.add("is-open");
      closeButton.focus();
    });

    trigger.addEventListener("keydown", function (event) {
      if (event.key === "Enter" || event.key === " ") {
        event.preventDefault();
        trigger.click();
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
    var toggle = event.target.closest(".navbar-custom .dropdown-toggle");
    var openMenus = document.querySelectorAll(".navbar-custom .dropdown-menu.show");

    openMenus.forEach(function (menu) {
      if (!toggle || menu !== toggle.nextElementSibling) {
        menu.classList.remove("show");
        var owner = menu.previousElementSibling;
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

    var menu = toggle.nextElementSibling;
    if (!menu || !menu.classList.contains("dropdown-menu")) {
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

  navbarToggle.querySelectorAll(".nav-link").forEach(function (link) {
    link.addEventListener("click", function () {
      if (link.classList.contains("dropdown-toggle")) {
        return;
      }

      if (navbarToggle.classList.contains("show")) {
        navbarToggle.classList.remove("show");
        navbarButton.setAttribute("aria-expanded", "false");
      }
    });
  });
});
