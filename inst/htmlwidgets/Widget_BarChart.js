HTMLWidgets.widget({
    name: 'Widget_BarChart',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                if (input.bDebug)
                    console.log(input);

                // Assign a unique ID to the element.
                el.id = `barChart--${input.lMetric.MetricID}_${input.strOutcome}`;

                // Update y-axis variable.
                input.lMetric.y = input.strOutcome;

                // Add click event listener to chart.
                if (input.bAddGroupSelect)
                    input.lMetric.clickCallback = function(d) {
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.GroupID)
                            ? 'None'
                            : d.GroupID;

                        // Update group select.
                        groupSelect.value = instance.data.config.selectedGroupIDs;

                        // Set country select to 'None' if a group ID is selected.
                        countrySelect.value = "None";

                        instance.helpers.updateConfig(
                            instance,
                            instance.data.config,
                            instance.data._thresholds_
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

                // Generate bar chart.
                const instance = rbmViz.default.barChart(
                    el,
                    input.dfResults,
                    input.lMetric,
                    input.vThreshold,
                    input.dfGroups
                );

                // Add dropdowns that highlight group IDs.
                if (input.bAddGroupSelect) {
                    const { groupSelect, countrySelect } = addWidgetControls(
                        el,
                        input.dfResults,
                        input.lMetric,
                        input.dfGroups
                    );
                }
            },
            resize: function(width, height) {
            }
        };
    }
});
