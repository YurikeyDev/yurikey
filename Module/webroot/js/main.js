document.addEventListener("DOMContentLoaded", () => {

  // ===============================
  // Navigation Between Pages
  // ===============================
  document.querySelectorAll(".nav-btn").forEach((btn, idx) => {
    btn.addEventListener("click", () => {
      document.querySelectorAll(".nav-btn").forEach(b => b.classList.remove("active"));
      document.querySelectorAll(".page").forEach(p => p.classList.remove("active"));
      btn.classList.add("active");
      document.querySelectorAll(".page")[idx].classList.add("active");
    });
  });

  // ===============================
  // KernelSU Script Execution
  // ===============================
  const BASE_SCRIPT = "/data/adb/modules/Yurikey/Yuri/";

  function runScript(scriptName) {
    const fullPath = `${BASE_SCRIPT}${scriptName}`;
    if (typeof ksu === "object" && typeof ksu.exec === "function") {
      const cbId = `cb_${Date.now()}`;
      window[cbId] = () => delete window[cbId];
      ksu.exec(`sh '${fullPath}'`, "{}", cbId);
    }
  }

  // ===============================
  // Action Buttons Handler
  // ===============================
  document.querySelectorAll(".action-buttons button").forEach(button => {
    const scriptName = button.dataset.script;
    if (scriptName) {
      button.addEventListener("click", () => runScript(scriptName));
    }
  });

  // ===============================
  // Internet Speed & Connectivity Monitor
  // ===============================
  async function updateNetSpeed() {
    const statusEl = document.getElementById("internet-status");
    const speedEl = document.getElementById("net-speed");
    const url = "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg";

    while (true) {
      statusEl.textContent = "Internet: Connecting...";
      speedEl.textContent = "Speed: Checking...";

      let downloadedBytes = 0;
      const startTime = performance.now();

      try {
        const response = await fetch(url, { cache: "no-cache" });
        if (!response.ok || !response.body) throw new Error("Fetch failed");

        statusEl.textContent = "Internet: Online";
        const reader = response.body.getReader();
        const readStart = performance.now();

        while (true) {
          const { done, value } = await reader.read();
          if (done) break;

          downloadedBytes += value.length;
          const now = performance.now();
          const duration = (now - readStart) / 1000;
          const speedKbps = (downloadedBytes * 8) / 1024 / duration;

          speedEl.textContent = `Speed: ${Math.round(speedKbps)} kbps`;
        }

      } catch (err) {
        statusEl.textContent = "Internet: Offline";
        speedEl.textContent = "Speed: -";
      }

      await new Promise(res => setTimeout(res, 5000));
    }
  }

  updateNetSpeed(); // Start the loop

  // ===============================
  // Clock Update
  // ===============================
  setInterval(() => {
    const now = new Date();
    document.getElementById("clock").textContent =
      `${now.toLocaleDateString()} ${now.toLocaleTimeString()}`;
  }, 1000);
});
