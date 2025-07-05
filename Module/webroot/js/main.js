document.addEventListener("DOMContentLoaded", () => {
  // ========================================
  // Navigation: Handle Page Switching
  // ========================================
  const navButtons = document.querySelectorAll(".nav-btn");
  const pages = document.querySelectorAll(".page");

  navButtons.forEach((btn, idx) => {
    btn.addEventListener("click", () => {
      navButtons.forEach(b => b.classList.remove("active"));
      pages.forEach(p => p.classList.remove("active"));
      btn.classList.add("active");
      pages[idx].classList.add("active");
    });
  });

  // ========================================
  // KernelSU Script Execution Handler
  // ========================================
  const BASE_SCRIPT = "/data/adb/modules/Yurikey/Yuri/";

  function runScript(scriptName) {
    const fullPath = `${BASE_SCRIPT}${scriptName}`;

    if (typeof ksu === "object" && typeof ksu.exec === "function") {
      const cbId = `cb_${Date.now()}`;
      window[cbId] = () => delete window[cbId]; // Clean up after execution
      ksu.exec(`sh '${fullPath}'`, "{}", cbId);
    }
  }

  document.querySelectorAll(".action-buttons button").forEach(button => {
    const scriptName = button.dataset.script;
    if (scriptName) {
      button.addEventListener("click", () => runScript(scriptName));
    }
  });

  // ========================================
  // Clock: Live Date + Time
  // ========================================
  const clockEl = document.getElementById("clock");

  function updateClock() {
    const now = new Date();
    clockEl.textContent = `${now.toLocaleDateString()} ${now.toLocaleTimeString()}`;
  }

  updateClock();
  setInterval(updateClock, 1000);

  // ========================================
  // Network Status: Offline/Online Detection
  // ========================================
  const statusBox = document.querySelector(".status-box");

  async function verifyRealInternet() {
    try {
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), 2000); // Timeout: 2s

      await fetch("https://clients3.google.com/generate_204", {
        method: "GET",
        cache: "no-store",
        mode: "no-cors",
        signal: controller.signal,
      });

      clearTimeout(timeout);
      return true;
    } catch (err) {
      return false;
    }
  }

  async function updateNetworkStatus() {
    const isProbablyOnline = navigator.onLine;

    if (!isProbablyOnline) {
      statusBox.classList.remove("online", "offline");
      statusBox.classList.add("offline");
      return;
    }

    const isActuallyOnline = await verifyRealInternet();
    statusBox.classList.remove("online", "offline");
    statusBox.classList.add(isActuallyOnline ? "online" : "offline");
  }

  // Initial network check + repeat every 4s
  updateNetworkStatus();
  setInterval(updateNetworkStatus, 4000);

  // Re-check on browser network events
  window.addEventListener("online", updateNetworkStatus);
  window.addEventListener("offline", updateNetworkStatus);
});
