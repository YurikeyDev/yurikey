// === Base Path to Script Directory ===
const BASE_SCRIPT = "/data/adb/modules/Yurikey/webroot/common/";

// === Execute a Shell Script with KernelSU ===
function runScript(scriptName, callback) {
  const fullPath = `${BASE_SCRIPT}${scriptName}`;
  if (typeof ksu === "object" && typeof ksu.exec === "function") {
    const cbId = `cb_${Date.now()}`;
    window[cbId] = () => {
      delete window[cbId];
      if (typeof callback === "function") callback();
    };
    ksu.exec(`sh '${fullPath}'`, "{}", cbId);
  } else {
    console.warn("ksu.exec not available.");
  }
}

// === Bind Action Buttons to Corresponding Scripts ===
document.querySelectorAll(".action-buttons button").forEach(button => {
  const scriptName = button.dataset.script;
  if (scriptName) {
    button.addEventListener("click", () => runScript(scriptName));
  }
});

// === Refresh Button Logic: Triggers Script and Reloads Info ===
const refreshBtn = document.getElementById("refresh-info-btn");
if (refreshBtn) {
  const scriptName = refreshBtn.dataset.script;
  refreshBtn.addEventListener("click", () => {
    refreshBtn.disabled = true;
    refreshBtn.innerText = "Refreshing...";
    runScript(scriptName, () => {
      loadDeviceInfo();
      refreshBtn.disabled = false;
      refreshBtn.innerText = "Refresh Info";
    });
  });
}

// === Load Device Info from JSON and Update the UI ===
function loadDeviceInfo() {
  const infoPath = "/json/device-info.json";

  fetch(infoPath)
    .then(res => {
      if (!res.ok) throw new Error("Failed to fetch device-info.json");
      return res.json();
    })
    .then(data => {
      document.getElementById("android-version").innerText = data.android || "-";
      document.getElementById("kernel-version").innerText = data.kernel || "-";
      document.getElementById("root-type").innerText = data.root || "-";
    })
    .catch(err => {
      console.error("loadDeviceInfo() error:", err);
      document.getElementById("android-version").innerText = "Error";
      document.getElementById("kernel-version").innerText = "Error";
      document.getElementById("root-type").innerText = "Error";
    });
}

// === Trigger Device Info Load When DOM is Ready ===
window.addEventListener("DOMContentLoaded", () => {
  loadDeviceInfo();
});
