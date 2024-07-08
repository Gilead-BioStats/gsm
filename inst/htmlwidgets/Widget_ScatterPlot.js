HTMLWidgets.widget({
    name: 'Widget_ScatterPlot',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                if (input.bDebug)
                    console.log(input);

                // add click event listener to chart
                if (input.bAddGroupSelect)
                    input.lMetric.clickCallback = function(d) {
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.GroupID)
                            ? 'None'
                            : d.GroupID;
                        groupSelect.value = instance.data.config.selectedGroupIDs;
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

                // generate scatter plot
                const instance = rbmViz.default.scatterPlot(
                    el,
                    input.dfSummary,
                    input.lMetric,
                    input.dfBounds,
                    input.dfGroups
                );

                // add dropdown that highlights groups
                let groupSelect;
                if (input.bAddGroupSelect) {
                    console
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
