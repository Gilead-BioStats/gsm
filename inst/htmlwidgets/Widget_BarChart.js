HTMLWidgets.widget({
    name: 'Widget_BarChart',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(x) {
                // bar chart data - points
                const results = HTMLWidgets.dataframeToD3(x.results)

                // bar chart configuration
                const workflow = HTMLWidgets.dataframeToD3(x.workflow)[0]
                workflow.y = x.yaxis;
                workflow.selectedGroupIDs = number_to_array(x.selectedGroupIDs)

                // add click event listener to chart
                if (x.addSiteSelect)
                    workflow.clickCallback = function(d) { // clickCallback.bind(null, instance, siteSelect);
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

                // threshold annotations
                const thresholds = HTMLWidgets.dataframeToD3(x.threshold)

                // generate bar chart
                const instance = rbmViz.default.barChart(
                    el,
                    results,
                    workflow,
                    thresholds
                );

                // add dropdown that highlights sites
                let siteSelect;
                if (x.addSiteSelect)
                    siteSelect = addSiteSelect(el, results, instance, x.siteSelectLabelValue);
            },
            resize: function(width, height) {
            }
        };
    }
});
