const THEME_CONFIG_PATH = "json/theme-config.json";
const THEME_SCRIPT_PATH = "/data/adb/modules/Yurikey/webroot/common/theme-manager.sh";

let themeConfig = null;
let currentTheme = "dark-blue";

const THEME_DISPLAY_MAP = {
  "dark-blue": "🌙",
  "dark-purple": "🔮",
  "dark-green": "🌿",
  "dark-orange": "🔥",
  "dark-red": "❤️",
  "cyberpunk": "💫",
  "midnight": "🌃",
  "forest": "🌲",
  "monet": "🎨"
};

const FALLBACK_THEMES = {
  "dark-blue": {
    "green": "#66bb6a",
    "primary-red": "#ef5350",
    "accent-pink": "#4fc3f7",
    "deep-pink": "#82d7ff",
    "gothic-black": "#121212",
    "gothic-purple": "#1e1e1e",
    "soft-white": "#ffffff",
    "soft-gray": "#2c2c2c",
    "secondary-bg": "#1e1e1e",
    "secondary-border": "#2c2c2c",
    "nav-inactive": "#888"
  },
  "dark-purple": {
    "green": "#66bb6a",
    "primary-red": "#ef5350",
    "accent-pink": "#ab47bc",
    "deep-pink": "#e1bee7",
    "gothic-black": "#121212",
    "gothic-purple": "#1e1e1e",
    "soft-white": "#ffffff",
    "soft-gray": "#2c2c2c",
    "secondary-bg": "#1e1e1e",
    "secondary-border": "#2c2c2c",
    "nav-inactive": "#888"
  },
  "dark-green": {
    "green": "#66bb6a",
    "primary-red": "#ef5350",
    "accent-pink": "#4caf50",
    "deep-pink": "#81c784",
    "gothic-black": "#121212",
    "gothic-purple": "#1e1e1e",
    "soft-white": "#ffffff",
    "soft-gray": "#2c2c2c",
    "secondary-bg": "#1e1e1e",
    "secondary-border": "#2c2c2c",
    "nav-inactive": "#888"
  },
  "monet": {
    "green": "#66bb6a",
    "primary-red": "#ef5350",
    "accent-pink": "var(--primary, #007bff)",
    "deep-pink": "var(--onPrimary, #fff)",
    "gothic-black": "var(--background, #121212)",
    "gothic-purple": "var(--tonalSurface, #1e1e1e)",
    "soft-white": "var(--onSurface, #fff)",
    "soft-gray": "var(--surfaceBright, #2c2c2c)",
    "secondary-bg": "var(--tonalSurface, #1e1e1e)",
    "secondary-border": "var(--outlineVariant, #2c2c2c)",
    "nav-inactive": "#888"
  }
};

async function loadThemeConfig() {
  try {
    const response = await fetch(`${THEME_CONFIG_PATH}?ts=${Date.now()}`);
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }
    themeConfig = await response.json();

    const savedTheme = themeConfig.selected_theme ||
                       localStorage.getItem("selectedTheme") ||
                       "dark-blue";
    currentTheme = savedTheme;
    return themeConfig;
  } catch (error) {
    console.error("Failed to load theme config:", error);
    currentTheme = localStorage.getItem("selectedTheme") || "dark-blue";
    return null;
  }
}

function applyTheme(themeName) {
  let themeColors = null;
  if (themeConfig && themeConfig.themes && themeConfig.themes[themeName]) {
    themeColors = themeConfig.themes[themeName].colors;
  } else if (FALLBACK_THEMES[themeName]) {
    themeColors = FALLBACK_THEMES[themeName];
  } else {
    themeColors = FALLBACK_THEMES["dark-blue"];
    themeName = "dark-blue";
  }

  if (!themeColors) {
    console.error(`Theme '${themeName}' not found`);
    return;
  }

  const root = document.documentElement;
  document.body.classList.add('theme-transition');

  Object.entries(themeColors).forEach(([key, value]) => {
    root.style.setProperty(`--${key}`, value);
  });

  setTimeout(() => {
    document.body.classList.remove('theme-transition');
  }, 300);

  currentTheme = themeName;
  console.log(`Applied: ${themeName}`);
}

function execCommand(command) {
  return new Promise((resolve, reject) => {
    if (typeof ksu !== "object" || typeof ksu.exec !== "function") {
      reject("KernelSU exec not available");
      return;
    }

    const cb = `cb_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
    window[cb] = (code, out, err) => {
      delete window[cb];
      if (code === 0) {
        resolve(out || "");
      } else {
        reject(err || "Command failed");
      }
    };

    try {
      ksu.exec(command, "{}", cb);
    } catch (error) {
      delete window[cb];
      reject(error);
    }
  });
}

async function saveTheme(themeName) {
  localStorage.setItem("selectedTheme", themeName);
  try {
    const command = `sh "${THEME_SCRIPT_PATH}" save "${themeName}"`;
    const result = await execCommand(command);
    console.log(`Theme '${themeName}' saved to file successfully:`, result.trim());
  } catch (error) {
    console.error("Failed to save theme to file:", error);
    console.log(`Theme '${themeName}' will persist in localStorage only`);
  }
}

async function getCurrentTheme() {
  try {
    const command = `sh "${THEME_SCRIPT_PATH}" get`;
    const result = await execCommand(command);
    const fileTheme = result.trim();

    if (fileTheme && fileTheme !== "dark-blue" && fileTheme !== "Error" && !fileTheme.includes("Error")) {
      return fileTheme;
    }
  } catch (error) {
    console.error("Failed to get current theme from file:", error);
  }

  const localTheme = localStorage.getItem("selectedTheme");
  if (localTheme) {
    return localTheme;
  }

  return currentTheme || "dark-blue";
}

function setupThemeDropdown() {
  const themeBtn = document.getElementById("theme-btn");
  const themeOptions = document.getElementById("theme-options");

  if (!themeBtn || !themeOptions) {
    console.error("Theme dropdown elements not found");
    return;
  }

  themeBtn.addEventListener("click", (e) => {
    e.stopPropagation();
    themeOptions.classList.toggle("show");
  });

  themeOptions.addEventListener("click", async (e) => {
    const listItem = e.target.closest("li");
    if (!listItem) return;

    const selectedTheme = listItem.dataset.theme;
    if (!selectedTheme) return;

    applyTheme(selectedTheme);
    updateThemeButton(selectedTheme);
    themeOptions.classList.remove("show");
    await saveTheme(selectedTheme);
    if (typeof showToast === 'function') {
      const translationKey = `theme_${selectedTheme.replace(/-/g, '_')}`;
      const themeName = t(translationKey) || selectedTheme;
      showToast(`Theme changed to ${themeName}`, 'success');
    }
  });

  document.addEventListener("click", (e) => {
    if (!themeBtn.contains(e.target) && !themeOptions.contains(e.target)) {
      themeOptions.classList.remove("show");
    }
  });
}

function updateThemeButton(themeName) {
  const themeBtn = document.getElementById("theme-btn");
  const themeOptions = document.getElementById("theme-options");

  if (!themeBtn || !themeOptions) return;

  const emoji = THEME_DISPLAY_MAP[themeName] || "🎨";
  const translationKey = `theme_${themeName.replace(/-/g, '_')}`;
  const translatedName = t(translationKey) || themeName;

  themeBtn.textContent = `${emoji} ${translatedName}`;

  themeOptions.querySelectorAll("li").forEach(li => {
    li.classList.toggle("selected", li.dataset.theme === themeName);
  });
}

async function initializeTheme() {
  await loadThemeConfig();
  const savedTheme = await getCurrentTheme();
  if (savedTheme &&
      ((themeConfig && themeConfig.themes && themeConfig.themes[savedTheme]) || 
       FALLBACK_THEMES[savedTheme])) {
    currentTheme = savedTheme;
  } else {
    currentTheme = "dark-blue";
    localStorage.setItem("selectedTheme", currentTheme);
  }
  applyTheme(currentTheme);
  setupThemeDropdown();
  updateThemeButton(currentTheme);
  console.log(`Theme initialized with: ${currentTheme}`);
}

document.addEventListener("DOMContentLoaded", async () => {
  setTimeout(initializeTheme, 100);
});

document.addEventListener("languageChanged", () => {
  updateThemeButton(currentTheme);
});

window.themeManager = {
  loadThemeConfig,
  applyTheme,
  saveTheme,
  getCurrentTheme,
  initializeTheme
};