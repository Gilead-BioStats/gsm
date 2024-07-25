HTMLWidgets.widget({
    name: 'Widget_TimeSeries',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                if (input.bDebug)
                    console.log(input);

                // Assign a unique ID to the element.
                el.id = `timeSeries--${input.lMetric.MetricID}_${input.strOutcome}`;

                // Update y-axis variable.
                input.lMetric.y = input.strOutcome;

                // Add click event listener to chart.
                if (input.bAddGroupSelect)
                    input.lMetric.clickCallback = function(d) {
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.GroupID)
                            ? 'None'
                            : d.GroupID;

                        groupSelect.value = instance.data.config.selectedGroupIDs;

                        if (instance.data.config.selectedGroupIDs === 'None')
                            delete instance.data.config.selectedGroupIDs;
                        instance.helpers.updateSelectedGroupIDs(
                            instance.data.config.selectedGroupIDs
                        );

                        // Update Shiny input if in Shiny environment.
                        if (typeof Shiny !== 'undefined') {
                          if (instance.data.config.selectedGroupIDs.length > 0) {
                            Shiny.setInputValue(
                              'site',
                              instance.data.config.selectedGroupIDs
                            )
                          }
                        }
                  };

                // Generate time series.
                const instance = rbmViz.default.timeSeries(
                    el,
                    input.dfResults,
                    input.lMetric,
                    input.vThreshold,
                    null, // confidence intervals parameter
                    input.dfGroups
                );

                // Add dropdowns that highlight group IDs.
                const { groupSelect, countrySelect } = addWidgetControls(
                    el,
                    input.dfResults,
                    input.lMetric,
                    input.dfGroups,
                    input.bAddGroupSelect
                );
                if (countrySelect)
                    countrySelect.parentElement.style.display = 'none'; // hide country select
            },
            resize: function(width, height) {
            }
        };
    }
});
