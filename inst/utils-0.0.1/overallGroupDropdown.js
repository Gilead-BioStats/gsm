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
      document.querySelectorAll(".group-select").forEach((el) => {
        el.options[el.selectedIndex].innerHTML = event.target.value;
        el.disabled = true;
      });
    } else {
      document.querySelectorAll(".group-select").forEach((el) => {
        el.options[el.selectedIndex].innerHTML = "None";
        el.disabled = false;
      });
    }
  }
}

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

    const ids = [...document.querySelector(".group-select").options].map(
        (el) => el.text
    );

    for (const id of ids) {
        const groupOptionAll = document.createElement("option");
        groupOptionAll.innerHTML = id;
        overallGroupSelect.appendChild(groupOptionAll);
    }
}

document.addEventListener("DOMContentLoaded", function () {
  overallGroupDropdown()
})
