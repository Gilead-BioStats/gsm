HTMLWidgets.widget({
    name: 'Widget_BarChart',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(x) {

                const lLabels = x.lLabels
                lLabels.y = x.strYAxisType;
                lLabels.selectedGroupIDs = number_to_array(x.selectedGroupIDs)

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
                    };

                // generate bar chart
                const instance = rbmViz.default.barChart(
                    el,
                    x.dfSummary,
                    lLabels,
                    x.dfThreshold
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
