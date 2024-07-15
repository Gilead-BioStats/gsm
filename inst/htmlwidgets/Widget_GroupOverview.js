HTMLWidgets.widget({
    name: 'Widget_GroupOverview',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                if (input.bDebug)
                    console.log(input);

                // generate site overview table
                const groupSubset = getGroupSubset(
                    input.dfResults,
                    input.strGroupSubset
                );

                const instance = rbmViz.default.groupOverview(
                    el,
                    input.dfResults.filter(
                        d => groupSubset.includes(d.GroupID)
                    ),
                    {
                        GroupLevel: input.GroupLevel,
                        groupLabelKey: input.strGroupLabelKey,
                    },
                    input.dfGroups,
                    input.dfMetrics
                );

                addGroupSubset(el, instance, input.dfResults, input.strGroupSubset);
            },
            resize: function(width, height) {
            }
        };
    }
});
