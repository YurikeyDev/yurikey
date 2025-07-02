// === Function: Open a URL using Android Intent via KernelSU ===
function openUrlViaIntent(url) {
  if (!url || typeof url !== "string") return;

  // Build the intent command to open the URL
  const intentCmd = `nohup am start -a android.intent.action.VIEW -d '${url}' >/dev/null 2>&1 &`;

  // Check if KernelSU is available and execute the intent command
  if (typeof ksu === "object" && typeof ksu.exec === "function") {
    const cbId = `cb_${Date.now()}`;
    window[cbId] = () => delete window[cbId];
    ksu.exec(intentCmd, "{}", cbId);
  } else {
    console.warn("ksu.exec not available or unsupported.");
  }
}

// === Function: Attach click listeners to elements with [data-url] ===
function setupIntentLinks(selector = "[data-url]") {
  document.querySelectorAll(selector).forEach(button => {
    const url = button.dataset.url;
    if (url) {
      button.addEventListener("click", () => openUrlViaIntent(url));
    }
  });
}

// === Initialize: Run setup when the DOM is fully loaded ===
window.addEventListener("DOMContentLoaded", () => {
  setupIntentLinks();
});
