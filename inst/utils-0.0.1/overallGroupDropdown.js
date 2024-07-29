/**
 * This function highlights a group ID in all widgets.
 *
 * @returns {undefined}
 */
function overallClick() {
  const widgets = [
      ...document.querySelectorAll('.gsm-widget')
  ].map(el => ({
    chart: el.getElementsByTagName("canvas")[0].chart,
    type: el.className
  }))

  for (const widget of widgets) {
    if (/timeSeries/.test(widget.type)) {
        widget.chart.helpers.updateSelectedGroupIDs(event.target.value);
    } else {
        widget.chart.data.config.selectedGroupIDs = event.target.value; // group ID
        widget.chart.helpers.updateConfig(
            widget.chart,
            widget.chart.data.config,
            widget.chart.data._thresholds_
        );
    }

    if (event.target.value !== 'None') {
      document.querySelectorAll(".gsm-widget-control--group").forEach((el) => {
          el.value = [...el.options].map(option => option.text).includes(event.target.value)
              ? event.target.value
              : 'None';
          //el.disabled = true;
      });
    } else {
      document.querySelectorAll(".gsm-widget-control--group").forEach((el) => {
          el.value = 'None';
          //el.disabled = false;
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
