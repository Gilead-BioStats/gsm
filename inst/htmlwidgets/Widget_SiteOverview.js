HTMLWidgets.widget({
    name: 'Widget_SiteOverview',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(x) {
                // generate site overview table
                const instance = rbmViz.default.siteOverview(
                    el,
                    x.dfSummary,
                    x.lConfig,
                    x.dfSite,
                    x.dfWorkflow
                );
            },
            resize: function(width, height) {
            }
        };
    }
});
