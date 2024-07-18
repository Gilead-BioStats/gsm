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
                    //    countrySelect.value = "None"; Will add after refactor done in rbm-viz
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
                            Shiny.setInputValue(
                              'country',
                              instance.data.config.selectedCountryIDs
                            )
                          }
                        }
                  };

                // generate time series
                const instance = rbmViz.default.timeSeries(
                    el,
                    input.dfResults,
                    input.lMetric,
                    input.vThreshold,
                    null, // confidence intervals parameter
                    input.dfGroups
                );

                // add dropdown that highlights groups
                let groupSelect;
               // let countrySelect;
                if (input.bAddGroupSelect) {

                    groupSelect = addGroupSelect(
                        el,
                        input.dfResults,
                        instance,
                        `Highlighted ${input.lMetric.Group || 'group'}: `
                    );
                //    countrySelect = addCountrySelect(el, input.dfGroups, instance, groupSelect);

                }
            },
            resize: function(width, height) {
            }
        };
    }
});
