HTMLWidgets.widget({
    name: 'Widget_BarChart',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                if (input.bDebug)
                    console.log(input);

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

                // Add dropdown that highlights group IDs.
                let groupSelect, countrySelect;
                if (input.bAddGroupSelect) {
                    groupSelect = addGroupSelect(
                        el,
                        input.dfResults,
                        instance,
                        `Highlighted ${input.lMetric.Group || 'group'}: `
                    );

                    countrySelect = addCountrySelect(
                        el,
                        input.dfGroups,
                        instance,
                        groupSelect
                    );
                }
            },
            resize: function(width, height) {
            }
        };
    }
});
