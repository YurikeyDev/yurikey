// Language setup and global exposure
const LANG_PATH = "lang/";
const DEFAULT_LANG = "en";
let translations = {};
window.translations = translations; // Make translations globally accessible

// Translation helper function
function t(key) {
  return window.translations?.[key] || key;
}

// Load and apply translations to all elements
async function applyLanguage(langCode) {
  try {
    const res = await fetch(`${LANG_PATH}${langCode}.json?ts=${Date.now()}`);
    const json = await res.json();

    translations = json;
    window.translations = json;

    // Apply to elements using [data-i18n] attribute
    document.querySelectorAll("[data-i18n]").forEach(el => {
      const key = el.getAttribute("data-i18n");
      if (translations[key]) el.innerText = translations[key];
    });

    // Update refresh button text if available
    const refreshBtn = document.getElementById("refresh-info-btn");
    if (refreshBtn) {
      const defaultKey = refreshBtn.getAttribute("data-i18n");
      refreshBtn.innerText = t(defaultKey);
    }

    // Save the selected language in localStorage
    document.documentElement.lang = langCode;
    localStorage.setItem("selectedLanguage", langCode);
  } catch (err) {
    console.error("Failed to load language:", err);
  }
}

// Handle dropdown language selection
function setupLanguageDropdown(currentLang) {
  const langBtn = document.getElementById("lang-btn");
  const langOptions = document.getElementById("lang-options");

  const activeItem = document.querySelector(`#lang-options li[data-lang='${currentLang}']`);
  if (langBtn && activeItem) langBtn.innerText = activeItem.innerText;

  // Toggle dropdown visibility
  langBtn?.addEventListener("click", (e) => {
    e.stopPropagation();
    langOptions?.classList.toggle("show");
  });

  // Close dropdown if clicked outside
  document.addEventListener("click", (e) => {
    if (!langOptions.contains(e.target) && e.target !== langBtn) {
      langOptions?.classList.remove("show");
    }
  });

  // Handle language option click
  document.querySelectorAll("#lang-options li").forEach(item => {
    item.addEventListener("click", () => {
      const lang = item.getAttribute("data-lang");
      applyLanguage(lang);
      langOptions?.classList.remove("show");
      langBtn.innerText = item.innerText;
    });
  });
}

// Initialize language and dropdown on page load
document.addEventListener("DOMContentLoaded", async () => {
  const savedLang = localStorage.getItem("selectedLanguage") || DEFAULT_LANG;
  await applyLanguage(savedLang);
  setupLanguageDropdown(savedLang);
});
