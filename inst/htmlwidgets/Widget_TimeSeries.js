HTMLWidgets.widget({
  name: 'Widget_TimeSeries',
  type: 'output',
  factory: function(el, width, height) {
    return {
      renderValue: function(x) {
        // analysis results
        const results = HTMLWidgets.dataframeToD3(x.results)

        // chart configuration
        const workflow = HTMLWidgets.dataframeToD3(x.workflow)[0]
        workflow.selectedGroupIDs = x.selectedGroupIDs
        workflow.clickCallback = function(d) {
            // Update site dropdown.
            const siteDropdown = document
                .getElementById(`site-select--time-series_${workflow.workflowid}`)
            siteDropdown.value = d.groupid;

            // Update chart (closure allows access to `instance` prior to initialization).
            instance.helpers.updateSelectedGroupIDs(d.groupid);
        };

        // analysis parameters
        const parameters = HTMLWidgets.dataframeToD3(x.parameters)

        // chart
        const instance = rbmViz.default.timeSeries(
            el,
            results,
            workflow,
            parameters
        );

        // Add event listener to site dropdown that updates chart on change.
        el.previousElementSibling.addEventListener('change', (event) => {
          instance.helpers.updateSelectedGroupIDs(event.target.value);
        });
      },
      resize: function(width, height) {
      }
    };
  }
});
