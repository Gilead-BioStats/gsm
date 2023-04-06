function overallClick() {

  const widgets = [
    ...document.querySelectorAll(".scatterJS, .barScoreJS, .barMetricJS, .timeSeriesContinuousJS")
  ].map(el => ({
    chart: el.getElementsByTagName("canvas")[0].chart,
    type: el.className
  }))


  for (const widget of widgets) {
    if (widget.type === "timeSeriesContinuousJS") {
      widget.chart.helpers.updateSelectedGroupIDs(event.target.value);
    } else {
      widget.chart.data.config.selectedGroupIDs = event.target.value; // site
      widget.chart.helpers.updateConfig(widget.chart, widget.chart.data.config, widget.chart.data._thresholds_);
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

}

function overallSiteDropdown() {
    // add container for drop-down
    const overallSiteSelectContainer = document.getElementById('overall-site-select');

    // add dropdown label
    const overallSiteSelectLabel = document.createElement("span");
    overallSiteSelectLabel.innerHTML = "Select Site ";
    overallSiteSelectContainer.appendChild(overallSiteSelectLabel);

    // add dropdown
    const overallSiteSelect = document.createElement("select");
    overallSiteSelect.onchange = overallClick
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
  overallSiteDropdown()
})
