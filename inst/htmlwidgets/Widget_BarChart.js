HTMLWidgets.widget({
    name: 'Widget_BarChart',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(x) {

                // bar chart configuration
                const lLabels = x.lLabels;
                lLabels.y = x.strYAxisType;
                lLabels.selectedGroupIDs = number_to_array(x.selectedGroupIDs);

                // add click event listener to chart
                if (x.addSiteSelect)
                    lLabels.clickCallback = function(d) { // clickCallback.bind(null, instance, siteSelect);
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.groupid)
                            ? 'None'
                            : d.groupid;
                        siteSelect.value = instance.data.config.selectedGroupIDs;
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
                };

                // generate bar chart
                const instance = rbmViz.default.barChart(
                    el,
                    x.dfSummary,
                    lLabels,
                    x.dfThreshold,
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
