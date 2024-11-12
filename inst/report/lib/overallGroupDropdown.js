/**
 * This function highlights a group ID in all chart-type widgets.
 *
 * @returns {undefined}
 */
function overallClick() {
    // Select all widget containers.
    const widgetContainers = [
      ...document.querySelectorAll('.gsm-widget')
    ];

    // Capture chart object attached to chart-type widgets.
    const chartWidgets = widgetContainers
        .map(el => {
            const canvas = el.getElementsByTagName("canvas");

            // Check if widget container contains a canvas element.
            const chart = canvas.length > 0
                ? canvas[0].chart
                : null;

            const chartType = el.className;

            return {
                chart,
                chartType
            };
        })
        .filter(
            // remove non-chart widgets (tables generally)
            widget => widget.chart !== null
        );

  // Loop over widgets, updating the selected group ID in each.
  for (const widget of chartWidgets) {
    if (/timeSeries/.test(widget.chartType)) {
        widget.chart.helpers.updateSelectedGroupIDs(event.target.value);
    } else {
        widget.chart.data.config.selectedGroupIDs = event.target.value; // group ID
        widget.chart.helpers.updateConfig(
            widget.chart,
            widget.chart.data.config,
            widget.chart.data._thresholds_
        );
    }

    // Set all group selects to the selected group ID, if the group ID appears in the list of options.
    if (event.target.value !== 'None') {
        document.querySelectorAll(".gsm-widget-control--group").forEach((el) => {
            el.value = [...el.options].map(option => option.text).includes(event.target.value)
                ? event.target.value
                : 'None';
        });

        // Reset all country selects to 'None'.
        document.querySelectorAll(".gsm-widget-control--country").forEach((el) => {
            el.value = 'None';
        });
    }
    // Reset all group and country selects to 'None'.
    else {
        document.querySelectorAll(".gsm-widget-control--select").forEach((el) => {
            el.value = 'None';
        });
    }
  }
}

/**
 * This function adds a dropdown to the report of all available group IDs.
 *
 * @returns {undefined}
 */
function overallGroupDropdown() {
    // add container for drop-down
    const overallGroupSelectContainer = document.getElementById('overall-group-select');

    // add dropdown label
    const overallGroupSelectLabel = document.createElement("span");
    overallGroupSelectLabel.innerHTML = "Select Group ";
    overallGroupSelectContainer.appendChild(overallGroupSelectLabel);

    // add dropdown
    const overallGroupSelect = document.createElement("select");
    overallGroupSelect.onchange = overallClick
    overallGroupSelectContainer.appendChild(overallGroupSelect);

    const groupOptions = [
        ...document.querySelectorAll(".gsm-widget-control--group option")
    ];

    // Capture group IDs across all group selects.
    const groupIDs = [...new Set(
        groupOptions.map(
            (el) => el.text
        )
    )];

    for (const groupID of groupIDs) {
        const groupOptionAll = document.createElement("option");
        groupOptionAll.innerHTML = groupID;
        overallGroupSelect.appendChild(groupOptionAll);
    }
}

// add overall group select
document.addEventListener("DOMContentLoaded", function () {
  overallGroupDropdown()
})
