function overallSiteDropdown() {
    // add container for drop-down
    const overallSiteSelectContainer = document.getElementById('overall-site-select');

    // add dropdown label
    const overallSiteSelectLabel = document.createElement("span");
    overallSiteSelectLabel.innerHTML = "Select Site ";
    overallSiteSelectContainer.appendChild(overallSiteSelectLabel);

    // add dropdown
    const overallSiteSelect = document.createElement("select");
    overallSiteSelectContainer.appendChild(overallSiteSelect);

    const ids = [...document.querySelector(".site-select").options].map(
        (el) => el.text
    );

    for (const id of ids) {
        const siteOptionAll = document.createElement("option");
        siteOptionAll.innerHTML = id;
        overallSiteSelect.appendChild(siteOptionAll);
    }
}

document.addEventListener("DOMContentLoaded", function () {
    overallSiteDropdown();

    document
        .querySelector(".overall-site-select")
        .addEventListener("change", function () {
            const canvases = [
                ...document.querySelectorAll(".scatterJS, .barMetricJS, .barScoreJS, .timeSeriesContinuousJS")
            ].map((el) => el.getElementsByTagName("canvas")[0]);

            const widgets = [];

            canvases.forEach((el) => {
                widgets.push(el.chart);
            });

            for (const widget of widgets) {
                widget.data.config.selectedGroupIDs = event.target.value; // site
                widget.helpers.updateConfig(widget, widget.data.config);
                if (event.target.value !== 'None') {
                    document.querySelectorAll(".site-select").forEach((el) => {
                        el.options[el.selectedIndex].innerHTML = event.target.value;
                        el.disabled = true;
                    });
                } else {
                    document.querySelectorAll(".site-select").forEach((el) => {
                        el.options[el.selectedIndex].innerHTML = "None";
                        el.disabled = false;
                    });
                }
            }
        });
});

