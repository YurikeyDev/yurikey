function exec(command) {
    return new Promise((resolve, reject) => {
        const callbackFuncName = `exec_callback_${Date.now()}`;
        window[callbackFuncName] = (errno, stdout, stderr) => {
            delete window[callbackFuncName];
            if (errno !== 0) {
                reject(new Error(`Command failed with exit code ${errno}: ${stderr}`));
                return;
            }
            resolve(stdout);
        };
        try {
            ksu.exec(command, "{}", callbackFuncName);
        } catch (error) {
            delete window[callbackFuncName];
            reject(error);
        }
    });
}

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

async function checkMMRL() {
    if (typeof ksu !== 'undefined' && ksu.mmrl) {
        try {
            $playintegrityfix.setLightStatusBars(!window.matchMedia('(prefers-color-scheme: dark)').matches)
        } catch (error) {
            console.log("Error setting status bars theme:", error)
        }
    }
}

document.addEventListener('DOMContentLoaded', async () => {
    checkMMRL();
    loadVersionFromModuleProp();
    await loadSpoofConfig();
    spoofConfig.forEach(config => {
        setupSpoofConfigButton(config.container, config.toggle, config.type);
    });
    loadPreviewFingerprintConfig();
    applyButtonEventListeners();
    applyRippleEffect();
    updateAutopif();
});
