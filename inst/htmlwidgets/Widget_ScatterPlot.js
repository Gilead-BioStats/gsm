HTMLWidgets.widget({
    name: 'Widget_ScatterPlot',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(x) {

                // scatter plot configuration
                const lLabels = x.lLabels;
                lLabels.selectedGroupIDs = number_to_array(x.selectedGroupIDs);

                // site select's event listener
                if (x.addSiteSelect)
                    lLabels.clickCallback = function(d) { // clickCallback.bind(null, instance, siteSelect);
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.GroupID)
                            ? 'None'
                            : d.GroupID;

                        siteSelect.value = instance.data.config.selectedGroupIDs;
                        instance.helpers.updateConfig(instance, instance.data.config);

                        countrySelect.value = "None";

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

                        instance.helpers.updateConfig(
                          instance,
                          instance.data.config
                        )
                  };


                // generate scatter plot
                const instance = rbmViz.default.scatterPlot(
                    el,
                    x.dfSummary,
                    lLabels,
                    x.dfBounds,
                    x.dfSite
                );

                // add dropdown that highlights sites
                let siteSelect;
                let countrySelect;
                if (x.addSiteSelect) {

                    siteSelect = addSiteSelect(el, x.dfSummary, instance, x.siteSelectLabelValue, countrySelect);
                    countrySelect = addCountrySelect(el, x.dfSite, instance, siteSelect);

                    // add event listener to dropdown that updates chart
                    countrySelect.addEventListener('change', event => {
                        siteSelect.value = "None";
                        countryFilter =
                        instance.data.config.selectedGroupIDs = x.dfSummary.filter(d => d.site.country === event.target.value).map(d => d.GroupID); // country
                        instance.helpers.updateConfig(instance, instance.data.config, instance.data._thresholds_);
                    });

                    // add event listener to dropdown that updates chart
                    siteSelect.addEventListener('change', event => {
                        countrySelect.value = "None";
                        instance.data.config.selectedGroupIDs = event.target.value; // site
                        instance.helpers.updateConfig(instance, instance.data.config, instance.data._thresholds_);
                    });

                };

                // hide dropdown if in a Shiny environment
                if (x.bHideDropdown) {
                  siteSelect.style.display = "none";
                  countrySelect.style.display = "none";
                }
            },
            resize: function(width, height) {
            }
        };
    }
});
