// ========== EXECUTOR FUNCTION ==========
// Executes a shell command using KernelSU and returns a Promise with the output
function exec(command) {
  return new Promise((resolve, reject) => {
    const cb = `cb_${Date.now()}`;
    window[cb] = (code, out, err) => {
      delete window[cb];
      code ? reject(err || "Unknown error") : resolve(out);
    };
    ksu.exec(command, "{}", cb);
  });
}

// ========== VERSION MODULE DETECTION ==========
// Reads the 'version' from /data/adb/modules/Yurikey/module.prop
async function loadVersionFromModuleProp() {
  const versionElement = document.getElementById('version-text');
  try {
    const version = await exec("grep '^version=' /data/adb/modules/Yurikey/module.prop | cut -d'=' -f2");
    versionElement.textContent = version.trim();
  } catch (error) {
    appendToOutput("[!] Failed to read version from module.prop");
    console.error("Failed to read version from module.prop:", error);
  }
}

// ========== DOM INITIALIZATION ==========
document.addEventListener('DOMContentLoaded', () => {
  loadVersionFromModuleProp();
});
