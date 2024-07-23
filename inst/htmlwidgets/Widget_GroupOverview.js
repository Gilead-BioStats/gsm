HTMLWidgets.widget({
    name: 'Widget_GroupOverview',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                if (input.bDebug)
                    console.log(input);

                // Define initial group subset.
                const groupSubset = getGroupSubset(
                    input.dfResults,
                    input.strGroupSubset
                );

                // Generate site overview table.
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

                // Add group subset dropdown.
                addGroupSubset(el, instance, input.dfResults, input.strGroupSubset);
            },
            resize: function(width, height) {
            }
        };
    }
});
