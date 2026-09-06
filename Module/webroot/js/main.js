document.addEventListener("DOMContentLoaded", () => {
  console.log("main.js active");

  const BASE_SCRIPT = "/data/adb/modules/Yurikey/Yuri/";
  // Make sure language.js is already loaded so that t and tFormat are available

  let toastTimer;
  const SCRIPT_HISTORY_KEY = "scriptHistoryLogs";

  function getScriptExecutor() {
    if (typeof window.YuriKeyHost?.execScript === "function") {
      return (scriptPath, scriptName, cb) => {
        Promise.resolve(window.YuriKeyHost.execScript(scriptPath, scriptName))
          .then(result => cb(typeof result === "string" ? result : JSON.stringify(result)))
          .catch(() => cb(""));
      };
    }

    if (typeof window.execYurikeyScript === "function") {
      return (scriptPath, scriptName, cb) => {
        Promise.resolve(window.execYurikeyScript(scriptPath, scriptName))
          .then(result => cb(typeof result === "string" ? result : JSON.stringify(result)))
          .catch(() => cb(""));
      };
    }

    if (typeof ksu === "object" && typeof ksu.exec === "function") {
      return (scriptPath, _scriptName, cbName) => ksu.exec(`sh "${scriptPath}"`, "{}", cbName);
    }

    return null;
  }

  function readHistory() {
    try {
      const parsed = JSON.parse(localStorage.getItem(SCRIPT_HISTORY_KEY) || "[]");
      return Array.isArray(parsed) ? parsed : [];
    } catch {
      return [];
    }
  }

  function writeHistory(items) {
    localStorage.setItem(SCRIPT_HISTORY_KEY, JSON.stringify(items.slice(0, 80)));
  }

  function addScriptHistory(scriptName, outputText) {
    const cleanOutput = (outputText || "").trim();
    if (!cleanOutput) return;

    const history = readHistory();
    history.unshift({
      script: scriptName,
      output: cleanOutput,
      time: new Date().toLocaleString(),
    });
    writeHistory(history);
  }

  function renderHistoryDialog() {
    const contentEl = document.getElementById("script-history-content");
    if (!contentEl) return;

    const history = readHistory();
    if (!history.length) {
      contentEl.textContent = t("script_history_empty");
      return;
    }

    contentEl.innerHTML = history.map(item => {
      const script = item.script || "script";
      const time = item.time || "";
      const output = (item.output || "")
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
                .replace(/\n/g, "<br>");
      return `<div><strong>[${time}] ${script}</strong><br>${output}</div><hr>`;
    }).join("");
  }

  function openHistoryDialog() {
    const dialog = document.getElementById("script-history-dialog");
    const overlay = document.getElementById("script-history-overlay");
    if (!dialog || !overlay) return;

    renderHistoryDialog();
    overlay.classList.add("active");
    if (!dialog.open) dialog.showModal();
  }

  function closeHistoryDialog() {
    const dialog = document.getElementById("script-history-dialog");
    const overlay = document.getElementById("script-history-overlay");
    if (!dialog || !overlay) return;

    if (dialog.open) dialog.close();
    overlay.classList.remove("active");
  }

  function showToast(message, type = "info", duration = 3000) {
    const snackbar = document.getElementById("snackbar");
    if (!snackbar) return;

    snackbar.textContent = message;
    snackbar.className = `snackbar show ${type}`;

    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => {
      snackbar.classList.remove("show");
    }, duration);
  }

  function handleScriptResult(rawOutput, scriptName) {
    const raw = typeof rawOutput === "string" ? rawOutput.trim() : "";

    if (!raw) {
      showToast(tFormat("success", { script: scriptName }), "success", 3000);
      return;
    }

    try {
      const json = JSON.parse(raw);
      if (json.success) {
        const commandOutput = typeof json.output === "string" ? json.output.trim() : "";
        addScriptHistory(scriptName, commandOutput || tFormat("success", { script: scriptName }));
        showToast(tFormat("success", { script: scriptName }), "success", 3000);
      } else {
        addScriptHistory(scriptName, raw);
        showToast(t("script_execution_failed_generic"), "error", 4000);
      }
    } catch {
      addScriptHistory(scriptName, raw);
      showToast(tFormat("success", { script: scriptName }), "success", 3500);
    }
  }

  function runScript(scriptName, basePath, button) {
    const scriptPath = `${basePath}${scriptName}`;
    const executeScript = getScriptExecutor();

    const originalClass = button.className;
    button.classList.add("executing");

    const cb = `cb_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
    let timeoutId;

    window[cb] = (output) => {
      clearTimeout(timeoutId);
      delete window[cb];
      button.className = originalClass;
      handleScriptResult(output, scriptName);
    };

    try {
      if (!executeScript) {
        throw new Error("executor-unavailable");
      }

      showToast(tFormat("executing", { script: scriptName }), "info");
      executeScript(scriptPath, scriptName, cb);
    } catch (_e) {
      clearTimeout(timeoutId);
      delete window[cb];
      button.className = originalClass;
      addScriptHistory(scriptName, t("script_execution_failed_generic"));
      showToast(t("script_execution_failed_generic"), "error", 4500);
      return;
    }

    timeoutId = setTimeout(() => {
      delete window[cb];
      button.className = originalClass;
      addScriptHistory(scriptName, tFormat("timeout", { script: scriptName }));
      showToast(t("script_execution_failed_generic"), "error", 4500);
    }, 7000);
  }

  // Register click events for buttons in Actions Page
  document.querySelectorAll("#actions-page .menu-btn[data-script]").forEach(button => {
    const scriptName = button.dataset.script;
    if (scriptName) {
      button.addEventListener("click", () => runScript(scriptName, BASE_SCRIPT, button));
    }
  });

  // Register click events for buttons in Advanced Menu Page
  document.querySelectorAll("#advance-menu .menu-btn[data-script]").forEach(button => {
      const scriptName = button.dataset.script;
      if (scriptName) {
          button.addEventListener("click", () => runScript(scriptName, BASE_SCRIPT, button));
      }
  });

  // Navigation buttons
  document.querySelectorAll(".nav-btn").forEach((btn, idx) => {
    btn.addEventListener("click", () => {
      document.querySelectorAll(".nav-btn").forEach(b => b.classList.remove("active"));
      document.querySelectorAll(".page").forEach(p => p.classList.remove("active"));
      btn.classList.add("active");
      document.querySelectorAll(".page")[idx].classList.add("active");
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  });

  // Clock elements
  const clockDateEl = document.getElementById("clock-date");
  const clockTimeEl = document.getElementById("clock-time");
  const clockFormatBtn = document.getElementById("clock-format-btn");
  const clockFormatOptions = document.getElementById("clock-format-options");
  const CLOCK_FORMAT_KEY = "clockFormat";

  function getClockFormat() {
    return localStorage.getItem(CLOCK_FORMAT_KEY) || "auto";
  }

  function getClockFormatLabel(format) {
    if (format === "24h") return "24-hour (00:00)";
    if (format === "12h") return "12-hour (AM/PM)";
    return "Auto (Device)";
  }

  function setupClockFormatDropdown() {
    if (!clockFormatBtn || !clockFormatOptions) return;

    const currentFormat = getClockFormat();
    clockFormatBtn.innerText = getClockFormatLabel(currentFormat);

    clockFormatBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      clockFormatOptions.classList.toggle("show");
    });

    document.addEventListener("click", (e) => {
      if (!clockFormatOptions.contains(e.target) && e.target !== clockFormatBtn) {
        clockFormatOptions.classList.remove("show");
      }
    });

    clockFormatOptions.querySelectorAll("li[data-format]").forEach(item => {
      item.addEventListener("click", () => {
        const format = item.dataset.format || "auto";
        localStorage.setItem(CLOCK_FORMAT_KEY, format);
        clockFormatBtn.innerText = getClockFormatLabel(format);
        clockFormatOptions.classList.remove("show");
        updateClock();
        showToast(`Clock format: ${getClockFormatLabel(format)}`, "success");
      });
    });
  }

  function updateClock() {
    const now = new Date();
    const format = getClockFormat();

    const formattedDate = new Intl.DateTimeFormat(undefined, {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
    }).format(now);

    let formattedTime;
    if (format === "24h") {
      formattedTime = new Intl.DateTimeFormat(undefined, {
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
        hour12: false,
      }).format(now);
    } else if (format === "12h") {
      formattedTime = new Intl.DateTimeFormat(undefined, {
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
        hour12: true,
      }).format(now);
    } else {
      formattedTime = now.toLocaleTimeString(undefined, {
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
      });
    }

    if (clockDateEl) clockDateEl.textContent = formattedDate;
    if (clockTimeEl) clockTimeEl.textContent = formattedTime;
  }

  setupClockFormatDropdown();
  updateClock();
  setInterval(updateClock, 1000);

  let lastStatus = null;

  async function verifyRealInternet() {
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 2000);

      await fetch("https://clients3.google.com/generate_204", {
        method: "GET",
        cache: "no-store",
        signal: controller.signal,
      });

      clearTimeout(timeoutId);
      return true;
    } catch {
      try {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 2000);

        await fetch("https://clients3.google.com/generate_204", {
          method: "GET",
          cache: "no-store",
          mode: "no-cors",
          signal: controller.signal,
        });

        clearTimeout(timeoutId);
        return true;
      } catch {
        return false;
      }
    }
  }

  async function updateNetworkStatus() {
    const statusRow = document.getElementById("status-row");
    const statusText = document.getElementById("status-bar-text");

    if (!statusRow || !statusText) {
      console.warn("Status elements not found");
      return;
    }

    // Show temporary status while checking
    statusText.textContent = t("home_refreshing");
    statusRow.title = t("home_refreshing");

    const isProbablyOnline = navigator.onLine;
    const isActuallyOnline = isProbablyOnline && await verifyRealInternet();

    if (isActuallyOnline && lastStatus !== "online") {
      statusRow.classList.replace("offline", "online");
      statusText.textContent = t("home_status_online");
      statusRow.title = t("status_online");
      lastStatus = "online";
    } else if (!isActuallyOnline && lastStatus !== "offline") {
      statusRow.classList.replace("online", "offline");
      statusText.textContent = t("home_status_offline");
      statusRow.title = t("status_offline");
      showToast(t("status_offline"), "error");
      lastStatus = "offline";
    } else {
      // Update text only to sync language
      if (lastStatus === "online") {
        statusText.textContent = t("home_status_online");
        statusRow.title = t("status_online");
      } else if (lastStatus === "offline") {
        statusText.textContent = t("home_status_offline");
        statusRow.title = t("status_offline");
      }
    }
  }

  window.updateNetworkStatus = updateNetworkStatus;
  window.showToast = showToast;
  window.showSuccessToast = (message, duration = 3000) => showToast(message, "success", duration);
  window.showErrorToast = (message, duration = 4000) => showToast(message, "error", duration);
  window.showWarningToast = (message, duration = 3500) => showToast(message, "warning", duration);
  window.showInfoToast = (message, duration = 3000) => showToast(message, "info", duration);

  const historyCard = document.getElementById("module-version-card");
  const historyDialog = document.getElementById("script-history-dialog");
  const historyOverlay = document.getElementById("script-history-overlay");
  const historyCloseBtn = document.getElementById("script-history-close");
  const historyClearBtn = document.getElementById("script-history-clear");

  historyCard?.addEventListener("click", openHistoryDialog);
  historyCloseBtn?.addEventListener("click", closeHistoryDialog);
  historyOverlay?.addEventListener("click", closeHistoryDialog);
  historyDialog?.addEventListener("close", () => historyOverlay?.classList.remove("active"));
  historyClearBtn?.addEventListener("click", () => {
    writeHistory([]);
    renderHistoryDialog();
  });

  // Refresh info button event
  const refreshBtn = document.getElementById("refresh-info-btn");
  if (refreshBtn) {
    refreshBtn.addEventListener("click", () => {
      showToast(t("home_refreshing"), "info");
      updateNetworkStatus();
      if (window.loadDeviceInfo) {
        window.loadDeviceInfo();
      }
    });
  }

  // Initialize network status
  setTimeout(() => {
    updateNetworkStatus();
    setInterval(updateNetworkStatus, 3000);
    window.addEventListener("online", updateNetworkStatus);
    window.addEventListener("offline", updateNetworkStatus);
  }, 500);
});
