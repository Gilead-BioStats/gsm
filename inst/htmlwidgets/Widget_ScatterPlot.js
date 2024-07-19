HTMLWidgets.widget({
    name: 'Widget_ScatterPlot',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                if (input.bDebug)
                    console.log(input);

                // Add click event listener to chart.
                if (input.bAddGroupSelect)
                    input.lMetric.clickCallback = function(d) {
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.GroupID)
                            ? 'None'
                            : d.GroupID;

                        // Update group select.
                        groupSelect.value = instance.data.config.selectedGroupIDs;

                        // Set country select to 'None' if a group ID is selected.
                        if (countrySelect !== undefined)
                            countrySelect.value = "None";

                        instance.helpers.updateConfig(
                            instance,
                            instance.data.config
                        );

                    // Send selected group ID to Shiny app.
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
                let groupSelect, countrySelect;
                if (input.bAddGroupSelect) {
                    groupSelect = addGroupSelect(
                        el,
                        input.dfResults,
                        instance,
                        `Highlighted ${input.lMetric.Group || 'group'}: `
                    );

                    if (input.lMetric.GroupLevel === 'Site') {
                        countrySelect = addCountrySelect(
                            el,
                            input.dfGroups,
                            instance,
                            groupSelect
                        );
                    }
                }
            },
            resize: function(width, height) {
            }
        };
    }
});
