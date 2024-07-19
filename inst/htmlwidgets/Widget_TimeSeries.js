HTMLWidgets.widget({
    name: 'Widget_TimeSeries',
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

                        groupSelect.value = instance.data.config.selectedGroupIDs;

                        if (instance.data.config.selectedGroupIDs === 'None')
                            delete instance.data.config.selectedGroupIDs;
                        console.log(instance.data.config.selectedGroupIDs);
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

                // Add dropdown that highlights group IDs.
                let groupSelect;
                if (input.bAddGroupSelect) {

                    groupSelect = addGroupSelect(
                        el,
                        input.dfResults,
                        instance,
                        `Highlighted ${input.lMetric.Group || 'group'}: `
                    );
                }
            },
            resize: function(width, height) {
            }
        };
    }
});
