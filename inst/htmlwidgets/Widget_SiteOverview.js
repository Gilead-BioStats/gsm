HTMLWidgets.widget({
    name: 'Widget_SiteOverview',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                console.log(input);
                if (input.bDebug)
                    console.log(input);

                // generate site overview table
                const instance = rbmViz.default.siteOverview(
                    el,
                    input.dfSummary,
                    { group: 'site' },
                    input.dfGroups,
                    input.dfMetrics
                );
            },
            resize: function(width, height) {
            }
        };
    }
});
