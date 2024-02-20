function covariateHighlightSite() {

  // get all rbm-viz scatterplots
  let scatterPlots = [...document.querySelectorAll('.Widget_ScatterPlot, .Widget_BarChart')];
  let covariateScatterPlots = [...document.querySelectorAll('.covariate-scatter-plot')];
  let originalData = covariateScatterPlots.map(el => {
      return JSON.parse(JSON.stringify(el.data));
  });
  let newLayout = covariateScatterPlots.map(el => {
      return JSON.parse(JSON.stringify(el.layout));
  });

  let previousSite = null; // Store the previous site
  document.addEventListener("keydown", function (e) {
    // Check if the "r" key is pressed
    if (e.key === "r") {
        // Use originalData
        covariateScatterPlots.forEach((plot, i) => {
            Plotly.react(plot, originalData[i], newLayout[i]);
        });

        // Reset the previousSite
        previousSite = null;
    }
});

scatterPlots.map((el, index) => {
    let changesBatch = []; // Array to collect changes

    el.addEventListener("click", function(e) {
        setTimeout(function(){
            let currentSite = e.target.clickEvent.data.groupid;
            console.log(e.target.clickEvent)

            // Check if the currentSite has changed
            if (currentSite !== previousSite) {
                let isThisTheRealSite = (element) => element === currentSite;

                let newData = originalData.map(d => {
                    let siteSubsetData = JSON.parse(JSON.stringify(d));

                    siteSubsetData = siteSubsetData.map(categories => {
                        let siteIndex = categories.key.findIndex(isThisTheRealSite);

                        if (siteIndex !== -1) {
                            categories.x = [categories.x[siteIndex]];
                            categories.key = currentSite;
                            categories.y = categories.y[siteIndex];
                            categories.hoverinfo = 'text';
                            categories.textposition = 'none';
                            categories.text = categories.text[siteIndex];
                        } else {
                            categories.x = null;
                            categories.y = null;
                        }

                        return categories;
                    });

                    // Remove null values from siteSubsetData
                    siteSubsetData = siteSubsetData.filter(category => category.x !== null && category.y !== null);

                    return siteSubsetData;
                });

                // Collect changes in the batch array
                covariateScatterPlots.forEach((plot, i) => {
                    changesBatch.push({
                        plot: plot,
                        data: newData[i],
                        layout: newLayout[i]
                    });
                });

                // Apply a single Plotly.newPlot for the entire batch
                changesBatch.forEach(change => {
                    Plotly.react(change.plot, change.data, change.layout);
                });

                // Update the previousSite
                previousSite = currentSite;
            }
        }, 100);
    });
});
}

document.addEventListener("DOMContentLoaded", function () {
  covariateHighlightSite()
})
