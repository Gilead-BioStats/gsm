HTMLWidgets.widget({
  name: 'Widget_TimeSeries',
  type: 'output',
  factory: function(el, width, height) {
    return {
      renderValue: function(x) {

        // chart configuration
        const lLabels = HTMLWidgets.dataframeToD3(x.lLabels)[0]
        lLabels.selectedGroupIDs = x.selectedGroupIDs


        lLabels.clickCallback = function(d) {
            // Update site dropdown.
            const siteDropdown = document
                .getElementById(`site-select--time-series_${workflow.workflowid}`)
            siteDropdown.value = d.groupid;

            // Update chart (closure allows access to `instance` prior to initialization).
            instance.helpers.updateSelectedGroupIDs(d.groupid);
        };

        // chart
        const instance = rbmViz.default.timeSeries(
            el,
            x.dfSummary,
            lLabels,
            x.dfParams
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
