HTMLWidgets.widget({
    name: 'Widget_ScatterPlot',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                if (input.bDebug)
                    console.log(input);

                // Assign a unique ID to the element.
                el.id = `scatterPlot--${input.lMetric.MetricID}`;

                // Add click event listener to chart.
                if (input.bAddGroupSelect)
                    input.lMetric.clickCallback = function(d) {
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.GroupID)
                            ? 'None'
                            : d.GroupID;

                        // Update group select.
                        groupSelect.value = instance.data.config.selectedGroupIDs;

                        // Set country select to 'None' if a group ID is selected.
                        if (countrySelect)
                            countrySelect.value = "None";

                        instance.helpers.updateConfig(
                            instance,
                            instance.data.config
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

                // Generate scatter plot.
                const instance = rbmViz.default.scatterPlot(
                    el,
                    input.dfResults,
                    input.lMetric,
                    input.dfBounds,
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
            },
            resize: function(width, height) {
            }
        };
    }
});
