
HTMLWidgets.widget({
    name: 'Widget_BarChart',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                if (input.bDebug)
                    console.log(input);

                input.lMetric.y = input.strOutcome;

                // add click event listener to chart
                if (input.bAddGroupSelect)
                    input.lMetric.clickCallback = function(d) {
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.groupid)
                            ? 'None'
                            : d.groupid;
                        groupSelect.value = instance.data.config.selectedGroupIDs;
                        instance.helpers.updateConfig(
                            instance,
                            instance.data.config,
                            instance.data._thresholds_
                        );

                        if (typeof Shiny !== 'undefined') {
                          if (instance.data.config.selectedGroupIDs.length > 0) {
                            Shiny.setInputValue(
                              'site',
                              instance.data.config.selectedGroupIDs
                            )
                          }
                        }

                        instance.helpers.updateConfig(
                          instance,
                          instance.data.config
                        )
                  };

                // generate bar chart
                const instance = rbmViz.default.barChart(
                    el,
                    input.dfSummary,
                    input.lMetric,
                    input.vThreshold,
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
