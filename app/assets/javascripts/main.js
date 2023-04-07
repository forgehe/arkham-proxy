(function () {
  const doc = document.documentElement;

  doc.classList.remove("no-js");
  doc.classList.add("js");

  // Reveal animations
  if (document.body.classList.contains("has-animations")) {
    /* global ScrollReveal */
    const sr = (window.sr = ScrollReveal());

    sr.reveal(".hero-title, .hero-paragraph, .hero-cta", {
      duration: 1000,
      distance: "40px",
      easing: "cubic-bezier(0.5, -0.01, 0, 1.005)",
      origin: "left",
      interval: 150,
    });

    sr.reveal(".hero-illustration", {
      duration: 1000,
      distance: "40px",
      easing: "cubic-bezier(0.5, -0.01, 0, 1.005)",
      origin: "right",
      interval: 150,
    });

    sr.reveal(".feature", {
      duration: 1000,
      distance: "40px",
      easing: "cubic-bezier(0.5, -0.01, 0, 1.005)",
      interval: 100,
      origin: "bottom",
      scale: 0.9,
      viewFactor: 0.5,
    });
  }
})();
