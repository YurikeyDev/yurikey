(() => {
  const btn = document.getElementById("btn-import-keybox");
  if (!btn) return;

  const targetPath = "/data/adb/tricky_store/keybox.xml";
  const statusId = "keybox-status";


  // --- XML restrictions (testing) ---
  function isXmlFile(file) {
    if (!file) return false;

    // Extension check
    if (!String(file.name || "").toLowerCase().endsWith(".xml")) return false;

    // MIME type check (best-effort; some Android browsers may leave it empty)
    if (file.type && !["application/xml", "text/xml"].includes(file.type)) return false;

    return true;
  }

  function isValidXmlPath(path) {
    return typeof path === "string" && path.trim().toLowerCase().endsWith(".xml");
  }

  function isValidXmlContent(text) {
    try {
      const parser = new DOMParser();
      const xml = parser.parseFromString(String(text), "application/xml");
      return !xml.querySelector("parsererror");
    } catch (_) {
      return false;
    }
  }

  // Hidden file input (must be in DOM for iOS/Android browsers)
  const input = document.createElement("input");
  input.type = "file";
  input.multiple = false;
  input.style.position = "fixed";
  input.style.left = "-9999px";
  input.style.top = "-9999px";
  document.body.appendChild(input);

  function escapeShellValue(value) {
    // Safe single-quote escaping for sh
    return `'${String(value).replace(/'/g, `'"'"'`)}'`;
  }

  function ksuExec(command) {
    return new Promise((resolve, reject) => {
      if (typeof ksu !== "object" || typeof ksu.exec !== "function") {
        reject(new Error("ksu.exec not available"));
        return;
      }
      const cbId = `cb_${Date.now()}_${Math.random().toString(16).slice(2)}`;
      window[cbId] = (result) => {
        delete window[cbId];
        resolve(result);
      };
      ksu.exec(command, "{}", cbId);
    });
  }

  function getSafeDelimiter(content) {
    let delimiter = `YURIKEY_EOF_${Date.now()}`;
    while (content.includes(delimiter)) {
      delimiter = `YURIKEY_EOF_${Date.now()}_${Math.random().toString(16).slice(2)}`;
    }
    return delimiter;
  }

  async function installKeybox(file) {
    const content = await file.text();

    // Validate XML content (testing safety)
    if (!isValidXmlContent(content)) {
      throw new Error("Invalid XML content");
    }
    const delimiter = getSafeDelimiter(content);
    const dir = targetPath.substring(0, targetPath.lastIndexOf("/"));
    const command =
      `mkdir -p "${dir}"\n` +
      `cat <<'${delimiter}' > "${targetPath}"\n${content}\n${delimiter}\n` +
      `chmod 644 "${targetPath}"`;
    await ksuExec(command);
  }

  async function installKeyboxFromPath(path) {
    // KernelSU WebUI sometimes doesn't propagate shell failures properly,
    // so we must verify source/destination explicitly using markers.
    const safePath = escapeShellValue(path);
    const dir = targetPath.substring(0, targetPath.lastIndexOf("/"));

    const markerOk = "__YURIKEY_OK__";
    const markerErr = "__YURIKEY_ERR__";

    const command =
      `SRC=${safePath}
` +
      `DST="${targetPath}"
` +
      // Check source exists
      `if [ ! -f "$SRC" ]; then echo "${markerErr}:SRC_MISSING"; exit 20; fi
` +
      // Ensure destination dir + copy
      `mkdir -p "${dir}"
` +
      `cp -f "$SRC" "$DST" 2>/dev/null || echo "${markerErr}:CP_FAILED"
` +
      `chmod 644 "$DST" 2>/dev/null || true
` +
      // Verify destination exists + non-empty
      `if [ ! -f "$DST" ]; then echo "${markerErr}:DST_MISSING"; exit 21; fi
` +
      `if [ ! -s "$DST" ]; then echo "${markerErr}:DST_EMPTY"; exit 22; fi
` +
      `echo "${markerOk}"`;

    const result = await ksuExec(command);

    // Try to read stdout from KernelSU callback result (format can vary)
    const text = (typeof result === "string")
      ? result
      : (result && (result.stdout || result.output || result.msg))
        ? (result.stdout || result.output || result.msg)
        : JSON.stringify(result || {});

    if (text.includes(markerErr) || !text.includes(markerOk)) {
      // Provide a helpful message if we can identify the reason
      if (text.includes("SRC_MISSING")) throw new Error("Source XML file not found.");
      if (text.includes("DST_MISSING")) throw new Error("Copy failed: destination not created.");
      if (text.includes("DST_EMPTY")) throw new Error("Copy failed: destination is empty.");
      if (text.includes("CP_FAILED")) throw new Error("Copy failed (cp error).");
      throw new Error("Install failed (unknown shell error).");
    }
  }

  function ensureStatusBox() {
    let box = document.getElementById(statusId);
    if (!box) {
      box = document.createElement("div");
      box.id = statusId;
      box.className = "info-box info-content";
      btn.parentNode.appendChild(box);
    }
    if (!box.dataset.initialized) renderStatusBox(box);
    return box;
  }

  function renderStatusBox(box) {
    box.innerHTML = `
      <h3>Custom Keybox</h3>
      <p>Choose a keybox file to install. If the file picker is blocked, paste a file path below.</p>
      <div class="form-row" style="display:flex;gap:0.5rem;flex-wrap:wrap;align-items:center;">
        <input id="keybox-path-input" type="text" placeholder="/sdcard/Download/keybox.xml" style="flex:1;min-width:220px;" />
        <button id="keybox-path-install" class="menu-btn" type="button">Install from path</button>
      </div>
    `;
    box.dataset.initialized = "true";

    const pathButton = box.querySelector("#keybox-path-install");
    const pathInput = box.querySelector("#keybox-path-input");
    if (pathButton && pathInput) {
      pathButton.addEventListener("click", async () => {
        resetStatus();
        const filePath = pathInput.value.trim();
        if (!filePath) {
          updateStatus("Please enter a file path.", "error");
          return;
        }
        if (!isValidXmlPath(filePath)) {
          updateStatus("❌ Path must point to a .xml file.", "error");
          return;
        }
        updateStatus(`Installing from path: ${filePath}`);
        try {
          await installKeyboxFromPath(filePath);
          updateStatus("Custom keybox installed successfully.", "success");
          pathInput.value = "";
        } catch (error) {
          console.error(error);
          updateStatus(
            "Failed to install keybox from path. Make sure the file exists.",
            "error"
          );
        }
      });
    }
  }

  function resetStatus() {
    const box = ensureStatusBox();
    // Re-render so the status list doesn't grow forever
    box.dataset.initialized = "";
    renderStatusBox(box);
  }

  function updateStatus(message, tone = "") {
    const box = ensureStatusBox();
    const p = document.createElement("p");
    if (tone) p.className = tone;
    p.textContent = message;
    box.appendChild(p);
  }

  function openFilePicker() {
    resetStatus();
    // Some browsers require showPicker(); fallback to click()
    try {
      if (typeof input.showPicker === "function") input.showPicker();
      else input.click();
    } catch (e) {
      // If blocked, at least show the path option
      input.click();
    }
  }

  btn.addEventListener("click", openFilePicker);

  input.addEventListener("change", async () => {
    const file = input.files && input.files[0];
    if (!file) return;

    resetStatus();

    // Restrict to XML files while testing
    if (!isXmlFile(file)) {
      updateStatus("❌ Only .xml files are allowed.", "error");
      input.value = "";
      return;
    }

    updateStatus(`Selected: ${file.name}`);

    try {
      await installKeybox(file);
      updateStatus("Custom keybox installed successfully.", "success");
    } catch (error) {
      console.error(error);
      updateStatus("Failed to install keybox. Make sure KernelSU is available.", "error");
    } finally {
      input.value = "";
    }
  });
})();
