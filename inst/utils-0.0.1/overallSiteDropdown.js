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

            // TODO - put the class from above in the object so we can query
            canvases.forEach((el) => {
                widgets.push({chart: el.chart, type: 'CLASSHERE'});
            });

            for (const widget of widgets) {

                /*
                  TODO - now we can use widget.type to run the correct function
                  give the chart type
                */
                if (widget.type === "timeSeriesContinuousJS") {
                  instance.helpers.updateSelectedGroupIDs(event.target.value);
                } else {
                  widget.chart.data.config.selectedGroupIDs = event.target.value; // site
                  widget.chart.helpers.updateConfig(widget, widget.data.config);
                }

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

