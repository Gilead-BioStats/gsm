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

                // add click event listener to chart
                if (input.bAddGroupSelect)
                    input.lMetric.clickCallback = function(d) {
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.GroupID)
                            ? 'None'
                            : d.GroupID;
                        groupSelect.value = instance.data.config.selectedGroupIDs;
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
                            Shiny.setInputValue(
                              'country',
                              instance.data.config.selectedCountryIDs
                            )
                          }
                        }
                  };

                // generate bar chart
                const instance = rbmViz.default.barChart(
                    el,
                    input.dfResults,
                    input.lMetric,
                    input.vThreshold,
                    input.dfGroups
                );

                // add dropdown that highlights groups
                let groupSelect;
                let countrySelect;
                if (input.bAddGroupSelect) {
                    groupSelect = addGroupSelect(
                        el,
                        input.dfResults,
                        instance,
                        `Highlighted ${input.lMetric.Group || 'group'}: `
                    );
                    countrySelect = addCountrySelect(el, input.dfGroups, instance, groupSelect);
                }
            },
            resize: function(width, height) {
            }
        };
    }
});
