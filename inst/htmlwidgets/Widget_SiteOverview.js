HTMLWidgets.widget({
    name: 'Widget_SiteOverview',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(x) {
                console.log(x);
                // generate site overview table
                const instance = rbmViz.default.siteOverview(
                    el,
                    x.dfSummary,
                    { group: 'site' },
                    x.dfSite,
                    x.dfMetrics
                );
            },
            resize: function(width, height) {
            }
        };
    }
});
