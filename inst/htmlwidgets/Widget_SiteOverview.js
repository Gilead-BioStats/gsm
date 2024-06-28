HTMLWidgets.widget({
    name: 'Widget_SiteOverview',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                if (input.bDebug)
                    console.log(input);

                // generate site overview table
                const groupSubset = getGroupSubset(
                    input.dfSummary,
                    input.strGroupSubset
                );

                const instance = rbmViz.default.siteOverview(
                    el,
                    input.dfSummary.filter(
                        d => groupSubset.includes(d.GroupID)
                    ),
                    { group: 'site' },
                    input.dfGroups,
                    input.dfMetrics
                );

                addGroupSubset(el, instance, input.dfSummary, input.strGroupSubset);
            },
            resize: function(width, height) {
            }
        };
    }
});
