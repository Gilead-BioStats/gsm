HTMLWidgets.widget({
    name: 'Widget_ScatterPlot',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(x) {

                // scatter plot configuration
                const lLabels = x.lLabels;
                lLabels.selectedGroupIDs = number_to_array(x.selectedGroupIDs);

                // add click event listener to chart
                if (x.addSiteSelect)
                    lLabels.clickCallback = function(d) { // clickCallback.bind(null, instance, siteSelect);
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.groupid)
                            ? 'None'
                            : d.groupid;
                        siteSelect.value = instance.data.config.selectedGroupIDs;
                        instance.helpers.updateConfig(instance, instance.data.config);

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

                // generate scatter plot
                console.log(x)
                const instance = rbmViz.default.scatterPlot(
                    el,
                    x.dfSummary,
                    lLabels,
                    x.dfBounds,
                    x.dfSite
                );

                // add dropdown that highlights sites
                let siteSelect;
                if (x.addSiteSelect)
                    siteSelect = addSiteSelect(el, x.dfSummary, instance, x.siteSelectLabelValue);

                // hide dropdown if in a Shiny environment
                if (x.bHideDropdown) {
                  siteSelect.style.display = "none";
                }
            },
            resize: function(width, height) {
            }
        };
    }
});
