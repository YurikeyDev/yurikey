(() => {
  const btn = document.getElementById("btn-import-keybox");
  if (!btn) return;

  const targetPath = "/data/adb/tricky_store/keybox.xml";
  const statusId = "keybox-status";

  const input = document.createElement("input");
  input.type = "file";
  input.multiple = false;
  input.style.position = "fixed";
  input.style.left = "-9999px";
  document.body.appendChild(input);

  function ensureStatusBox() {
    let box = document.getElementById(statusId);
    if (!box) {
      box = document.createElement("div");
      box.id = statusId;
      box.className = "info-box info-content";
      box.innerHTML = "<h3>Custom Keybox</h3><p>Choose a keybox file to install.</p>";
      btn.parentNode.appendChild(box);
    }
    return box;
  }

  function updateStatus(message, tone = "") {
    const box = ensureStatusBox();
    const p = document.createElement("p");
    if (tone) p.className = tone;
    p.textContent = message;
    box.appendChild(p);
  }

  function getSafeDelimiter(content) {
    let delimiter = `YURIKEY_EOF_${Date.now()}`;
    while (content.includes(delimiter)) {
      delimiter = `YURIKEY_EOF_${Date.now()}_${Math.random().toString(16).slice(2)}`;
    }
    return delimiter;
  }

  function ksuExec(command) {
    return new Promise((resolve, reject) => {
      if (typeof ksu !== "object" || typeof ksu.exec !== "function") {
        reject(new Error("ksu.exec not available"));
        return;
      }
      const cbId = `cb_${Date.now()}_${Math.random().toString(16).slice(2)}`;
      window[cbId] = result => {
        delete window[cbId];
        resolve(result);
      };
      ksu.exec(command, "{}", cbId);
    });
  }

  async function installKeybox(file) {
    const content = await file.text();
    const delimiter = getSafeDelimiter(content);
    const command = `mkdir -p "${targetPath.substring(0, targetPath.lastIndexOf("/"))}"\n` +
      `cat <<'${delimiter}' > "${targetPath}"\n${content}\n${delimiter}\n` +
      `chmod 644 "${targetPath}"`;

    await ksuExec(command);
  }

  function openFilePicker() {
    ensureStatusBox();
    if (typeof input.showPicker === "function") {
      input.showPicker();
    } else {
      input.click();
    }
  }

  btn.addEventListener("click", openFilePicker);

  input.addEventListener("change", async () => {
    const file = input.files && input.files[0];
    if (!file) return;
    
    const isXml = file.name.toLowerCase().endsWith(".xml");
    if (!isXml) {
      updateStatus("Only .xml files are allowed.", "error");
      alert("Only .xml files are allowed.");
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
      alert("Failed to install keybox. Make sure KernelSU is available.");
    } finally {
      input.value = "";
    }
  });
})();
