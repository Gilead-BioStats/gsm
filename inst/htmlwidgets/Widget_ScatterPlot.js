HTMLWidgets.widget({
    name: 'Widget_ScatterPlot',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(x) {
                // scatter plot data - points
                const results = HTMLWidgets.dataframeToD3(x.results)

                // scatter plot configuration
                const workflow = x.workflow;
                workflow.selectedGroupIDs = number_to_array(x.selectedGroupIDs);

                if (x.addSiteSelect)
                    workflow.clickCallback = function(d) { // clickCallback.bind(null, instance, siteSelect);
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.groupid)
                            ? 'None'
                            : d.groupid;
                        siteSelect.value = instance.data.config.selectedGroupIDs;
                        instance.helpers.updateConfig(instance, instance.data.config);
                    };

                // scatter plot data - bound annotations
                const bounds = HTMLWidgets.dataframeToD3(x.bounds)

                // generate scatter plot
                const instance = rbmViz.default.scatterPlot(
                    el,
                    results,
                    workflow,
                    bounds
                );

                console.log(workflow)

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
