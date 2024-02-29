function bringCovariateBarToTop() {
  // get plots //

  // get all rbm-viz scatterplots
  let rbmVizPlots = [...document.querySelectorAll(".Widget_ScatterPlot, .Widget_BarChart")];
  // get all plotly site scatter plots
  let covariateSiteScatterPlots = [...document.querySelectorAll(".covariate-scatter-plot-site-Percent"), ...document.querySelectorAll(".covariate-scatter-plot-site-Total")];
  let covariateStudyScatterPlots = [...document.querySelectorAll(".covariate-scatter-plot-study-Percent"), ...document.querySelectorAll(".covariate-scatter-plot-study-Total")];

  // get data //
  let covariateSiteData = covariateSiteScatterPlots.map((el) => {
    return JSON.parse(JSON.stringify(el.data));
  });

  let covariateStudyData = covariateStudyScatterPlots.map((el) => {
    return JSON.parse(JSON.stringify(el.data));
  });

  // get layouts //
  // original layout
  let covariateSiteLayout = covariateSiteScatterPlots.map((el) => {
    return JSON.parse(JSON.stringify(el.layout));
  });

  let covariateStudyLayout = covariateStudyScatterPlots.map((el) => {
    return JSON.parse(JSON.stringify(el.layout));
  });

  // init previous site
  let previousSite = null;

  rbmVizPlots.map((el, index) => {
    el.addEventListener("click", function (e) {
      setTimeout(function () {
        let currentSite = e.target.clickEvent.data.groupid;

        if (currentSite !== previousSite) {
          let newCovariateSiteLayout = covariateSiteLayout.map((l) => {
            let cLayout = JSON.parse(JSON.stringify(l));
            let siteArray = cLayout.yaxis.categoryarray;
            // Find the index of the currentSite in the array
            let index = siteArray.indexOf(currentSite);
            // Move the element to the first position if found
            if (index !== -1) {
              siteArray.push(siteArray.splice(index, 1)[0]);
            }
            cLayout.yaxis.categoryarray = siteArray.map((item) => [item]).flat();
            return cLayout;
          });

          covariateSiteScatterPlots.map((el, index) => {
            Plotly.relayout(el, newCovariateSiteLayout[index]);
          });
        }
      }, 100);
    });
  });
}

document.addEventListener("DOMContentLoaded", function () {
  bringCovariateBarToTop()
})
