document.addEventListener("DOMContentLoaded", function () {
  let rbmVizPlots = [...document.querySelectorAll(".Widget_ScatterPlot, .Widget_BarChart")];
  let covariateSiteScatterPlotPercent = [...document.querySelectorAll(".covariate-scatter-plot-site-Percent")];
  let covariateStudyScatterPlotPercent = [...document.querySelectorAll(".covariate-scatter-plot-study-Percent")];
  let covariateSiteDataPercent = covariateSiteScatterPlotPercent.map((el) => {
    return JSON.parse(JSON.stringify(el.data));
  });
  let covariateStudyDataPercent = covariateStudyScatterPlotPercent.map((el) => {
    return JSON.parse(JSON.stringify(el.data));
  });

  let initialStudyDataPercentIndex = covariateStudyDataPercent.length;

  let covariateStudyLayout = covariateStudyScatterPlotPercent.map((el) => {
    return JSON.parse(JSON.stringify(el.layout));
  });

  rbmVizPlots.map((el, index) => {
    el.addEventListener("click", function (e) {
      setTimeout(function () {
        let currentSite = e.target.clickEvent.data.groupid;
        overlaySiteDistribution((currentSite = currentSite));
      }, 100);
    });
  });

  function overlaySiteDistribution(currentSite) {
    // Create a new array to store filtered data

    let filteredData = covariateSiteDataPercent.map((data) => {
      let chartData = data.map((el) => {
        let siteIndex = el.y.indexOf(currentSite);

        let fd = {
          error_x: el.error_x,
          error_y: el.error_y,
          frame: el.frame,
          hoverinfo: [el.hoverinfo[siteIndex]],
          marker: el.marker,
          name: el.name,
          orientation: el.orientation,
          text: [el.text[siteIndex]],
          textfont: el.textfont,
          textposition: [el.textposition[siteIndex]],
          type: "scatter",
          x: [el.x[siteIndex]],
          xaxis: el.xaxis,
          y: [el.name],
          yaxis: el.yaxis,
          // Include other properties as needed
        };

        fd.marker.size = 10;

        return fd;
      });

      return chartData;
    });

    covariateSiteDataPercent.forEach((siteData, i) => {
      const newChart = covariateStudyDataPercent[i].slice(0, initialStudyDataPercentIndex);
      const newChartLayout = covariateStudyLayout[i];

      Plotly.react(covariateStudyScatterPlotPercent[i], newChart.concat(filteredData[i]), newChartLayout);
    });
  }
});
