HTMLWidgets.widget({
    name: 'Widget_ScatterPlot',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(x) {

                // scatter plot configuration
                const lLabels = x.lLabels;
                lLabels.selectedGroupIDs = number_to_array(x.selectedGroupIDs);

                if (x.addSiteSelect)
                    lLabels.clickCallback = function(d) { // clickCallback.bind(null, instance, siteSelect);
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.groupid)
                            ? 'None'
                            : d.groupid;
                        siteSelect.value = instance.data.config.selectedGroupIDs;
                        instance.helpers.updateConfig(instance, instance.data.config);


                        if (!!Shiny) {
                          console.log(
                            `Selected site ID: ${instance.data.config.selectedGroupIDs}`
                          );

                          const namespace = 'gsmApp';

                          Shiny.setInputValue(
                            'site',
                            instance.data.config.selectedGroupIDs
                          )
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
                    x.dfBounds
                );


                // add dropdown that highlights sites
                let siteSelect;
                if (x.addSiteSelect)
                    siteSelect = addSiteSelect(el, x.dfSummary, instance, x.siteSelectLabelValue);
            },
            resize: function(width, height) {
            }
        };
    }
});
