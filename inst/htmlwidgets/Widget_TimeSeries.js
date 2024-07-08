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

                // add click event listener to chart
                if (input.bAddGroupSelect)
                    input.lMetric.clickCallback = function(d) {
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.GroupID)
                            ? 'None'
                            : d.GroupID;
                        groupSelect.value = instance.data.config.selectedGroupIDs;
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

                // generate time series
                const instance = rbmViz.default.timeSeries(
                    el,
                    input.dfSummary,
                    input.lMetric,
                    input.vThreshold,
                    null, // confidence intervals parameter
                    input.dfGroups
                );

                // add dropdown that highlights groups
                let groupSelect;
                if (input.bAddGroupSelect) {
                    groupSelect = addGroupSelect(
                        el,
                        input.dfSummary,
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
