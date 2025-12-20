document.addEventListener("DOMContentLoaded", () => {
  console.log("main.js active");

  const BASE_SCRIPT = "/data/adb/modules/Yurikey/Yuri/";
  let nextToastTime = 0;

  // Make sure language.js is already loaded so that t and tFormat are available

  function showToast(message, type = "info", duration = 3000) {
    const container = document.getElementById("toast-container");
    if (!container) return;

    const now = Date.now();
    const delay = Math.max(nextToastTime - now, 0);
    nextToastTime = now + delay + duration;

    setTimeout(() => {
      const toast = document.createElement("div");
      toast.className = `toast ${type}`;
      toast.textContent = message;
      toast.addEventListener("click", () => {
        toast.style.animation = "toast-slideout 0.3s cubic-bezier(0.34, 1.56, 0.64, 1) forwards";
        setTimeout(() => toast.remove(), 300);
      });
      container.appendChild(toast);
      setTimeout(() => {
        if (toast.parentNode) {
          toast.style.animation = "toast-slideout 0.3s cubic-bezier(0.34, 1.56, 0.64, 1) forwards";
          setTimeout(() => toast.remove(), 300);
        }
      }, duration);
    }, delay);
  }

  function runScript(scriptName, basePath, button) {
    const scriptPath = `${basePath}${scriptName}`;

    if (typeof ksu !== "object" || typeof ksu.exec !== "function") {
      showToast(t("ksu_not_available"), "error");
      return;
    }

    const originalClass = button.className;
    button.classList.add("executing");

    const cb = `cb_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
    let timeoutId;

    window[cb] = (output) => {
      clearTimeout(timeoutId);
      delete window[cb];
      button.className = originalClass;

      const raw = typeof output === "string" ? output.trim() : "";

      if (!raw) {
        showToast(tFormat("success", { script: scriptName }), "success");
        return;
      }

      try {
        const json = JSON.parse(raw);
        if (json.success) {
          showToast(tFormat("success", { script: scriptName }), "success");
        } else if (json.error) {
          showToast(tFormat("failed", { script: scriptName }) + ` (${json.error})`, "error", 4000);
        } else {
          showToast(tFormat("failed", { script: scriptName }) + " (Unknown response)", "error", 4000);
        }
      } catch {
        // If output is not JSON, treat as success but inform user
        showToast(tFormat("success", { script: scriptName }) + " (Non-JSON output)", "warning");
      }
    };

    try {
      showToast(tFormat("executing", { script: scriptName }), "info");
      ksu.exec(`sh "${scriptPath}"`, "{}", cb);
    } catch (e) {
      clearTimeout(timeoutId);
      delete window[cb];
      button.className = originalClass;
      showToast(tFormat("failed", { script: scriptName }), "error");
    }

    timeoutId = setTimeout(() => {
      delete window[cb];
      button.className = originalClass;
      showToast(tFormat("timeout", { script: scriptName }), "error");
    }, 7000);
  }

  // Register click events for buttons in Actions Page
  document.querySelectorAll("#actions-page .action-buttons .menu-btn").forEach(button => {
    const scriptName = button.dataset.script;
    if (scriptName) {
      button.addEventListener("click", () => runScript(scriptName, BASE_SCRIPT, button));
    }
  });

  // Register click events for buttons in Advanced Menu Page
  document.querySelectorAll("#advance-menu .action-buttons .menu-btn").forEach(button => {
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

  function updateClock() {
    const now = new Date();
    const day = now.getDate();
    const month = now.getMonth() + 1;
    const year = now.getFullYear();
    const formattedDate = `${day}/${String(month).padStart(2, "0")}/${year}`;

    let hours = now.getHours();
    const minutes = String(now.getMinutes()).padStart(2, "0");
    const seconds = String(now.getSeconds()).padStart(2, "0");
    const ampm = hours >= 12 ? "PM" : "AM";
    hours = hours % 12 || 12;
    const formattedTime = `${String(hours).padStart(2, "0")}:${minutes}:${seconds} ${ampm}`;

    if (clockDateEl) clockDateEl.textContent = formattedDate;
    if (clockTimeEl) clockTimeEl.textContent = formattedTime;
  }

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
