// === Load Contributors and Apply Translations ===
(function loadContributors() {
  fetch("json/dev.json")
    .then(res => {
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      return res.json();
    })
    .then(data => {
      const container = document.getElementById("contrib-list");
      if (!container || !Array.isArray(data.contributors)) return;

      container.innerHTML = ""; // Clear any existing entries

      // Render each contributor
      data.contributors.forEach(user => {
        const username = user.username || user.name || "unknown";
        const avatar = `https://github.com/${encodeURIComponent(username)}.png`;
        const profileURL = user.url || "#";
        const rawRole = user.role || "Unknown Role";
        const roleKey = `role_${rawRole}`; // Use this for translation lookup

        const card = document.createElement("button");
        card.className = "contrib-card";
        card.setAttribute("type", "button");
        card.addEventListener("click", () => openUrlViaIntent(profileURL));

        card.innerHTML = `
          <img src="${avatar}" alt="${user.name}" onerror="this.src='/common/icon/default-avatar.png'" />
          <div class="contrib-name">${user.name}</div>
          <div class="contrib-role" data-i18n="${roleKey}">${rawRole}</div>
        `;

        container.appendChild(card);
      });

      // Re-apply language translation after cards are rendered
      const currentLang = localStorage.getItem("selectedLanguage") || "en";
      setTimeout(() => applyLanguage(currentLang), 50); // delay to ensure DOM is updated
    })
    .catch(err => {
      console.error("Failed to load contributors:", err);
    });
})();
