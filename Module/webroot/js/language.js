const LANG_PATH = "lang/";
const DEFAULT_LANG = "en";

// Load and apply translation
async function applyLanguage(langCode) {
  try {
    const res = await fetch(`${LANG_PATH}${langCode}.json`);
    if (!res.ok) throw new Error("Language file not found");
    const translations = await res.json();

    document.querySelectorAll("[data-i18n]").forEach(el => {
      const key = el.getAttribute("data-i18n");
      if (translations[key]) {
        el.innerHTML = translations[key];
      }
    });

    localStorage.setItem("selectedLanguage", langCode);
  } catch (err) {
    console.error("Translation failed:", err);
  }
}

window.addEventListener("DOMContentLoaded", () => {
  const savedLang = localStorage.getItem("selectedLanguage") || DEFAULT_LANG;
  applyLanguage(savedLang);

  const langBtn = document.getElementById("lang-btn");
  const langOptions = document.getElementById("lang-options");
  const activeItem = document.querySelector(`#lang-options li[data-lang='${savedLang}']`);
  if (langBtn && activeItem) langBtn.innerHTML = activeItem.innerHTML;

  // Toggle dropdown
  if (langBtn && langOptions) {
    langBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      langOptions.classList.toggle("show");
    });

    // Hide dropdown on click outside
    document.addEventListener("click", (e) => {
      if (!langOptions.contains(e.target) && e.target !== langBtn) {
        langOptions.classList.remove("show");
      }
    });
  }

  // Handle language selection
  document.querySelectorAll("#lang-options li").forEach(item => {
    item.addEventListener("click", () => {
      const selectedLang = item.getAttribute("data-lang");
      applyLanguage(selectedLang);

      langOptions.classList.remove("show");
      langBtn.innerHTML = item.innerHTML;
    });
  });
});
