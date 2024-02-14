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

          // initialize groupids
          instance.helpers.updateSelectedGroupIDs(d.groupid);

                  if (typeof Shiny !== 'undefined') {

                    const namespace = 'gsmApp';

                    console.log(instance.data.config.selectedGroupIDs)


                    if (instance.data.config.selectedGroupIDs.length > 0) {
                      console.log(
                        `Selected site ID: ${instance.data.config.selectedGroupIDs}`
                      )

                            Shiny.setInputValue(
                              'site',
                              instance.data.config.selectedGroupIDs
                            )

                            instance.helpers.updateSelectedGroupIDs(
                              instance.data.config.selectedGroupIDs
                            )

                    }

                  } else {
                    // Update site dropdown.
                    const siteDropdown = document.getElementById(`site-select--time-series_${lLabels.workflowid}`)
                    siteDropdown.value = d.groupid;

                    // Update chart (closure allows access to `instance` prior to initialization).
                    instance.helpers.updateSelectedGroupIDs(d.groupid);
                  }

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
