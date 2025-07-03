const helpButton = document.getElementById('help-button');
const helpOverlay = document.getElementById('help-overlay');
const helpContent = document.querySelector('.help-menu');
const closeHelp = document.getElementById('close-help');

// Open help menu
helpButton.addEventListener("click", () => {
    document.body.classList.add("no-scroll");
    helpOverlay.style.display = "flex";
    setTimeout(() => {
        helpOverlay.style.opacity = 1;
        helpContent.classList.add('open');
    }, 10);
});

const hideHelpOverlay = () => {
    helpOverlay.style.opacity = 0;
    helpContent.classList.remove('open');
    document.body.classList.remove("no-scroll");
    setTimeout(() => {
        helpOverlay.style.display = "none";
    }, 200);
};

// Close help menu
closeHelp.addEventListener("click", hideHelpOverlay);
helpOverlay.addEventListener("click", (event) => {
    if (event.target === helpOverlay) {
        hideHelpOverlay();
    }
});