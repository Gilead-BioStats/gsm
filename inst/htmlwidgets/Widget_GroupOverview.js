HTMLWidgets.widget({
    name: 'Widget_GroupOverview',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                if (input.bDebug)
                    console.log(input);

                // Generate site overview table.
                const instance = rbmViz.default.groupOverview(
                    el,
                    input.dfResults,
                    {
                        GroupLevel: input.strGroupLevel,
                        groupLabelKey: input.strGroupLabelKey //,
                        // Callbacks for Shiny, may need to move to a different file.
                        /*
                        groupClickCallback: function (datum) {
                            Shiny.setInputValue(
                                'GroupOverviewGroupID',
                                datum.GroupID,
                                {priority: 'event'}
                            );
                        },
                        metricClickCallback: function(datum) {
                            console.log('clicked metric')
                            console.log(datum);
                            Shiny.setInputValue(
                                'GroupOverviewGroupID',
                                datum.GroupID,
                                {priority: 'event'}
                            );
                            Shiny.setInputValue(
                                'GroupOverviewMetricID',
                                datum.MetricID,
                                {priority: "event"}
                            );
                        }
                        */
                    },
                    input.dfGroups,
                    input.dfMetrics
                );

                // Add group subset dropdown.
                addGroupSubset(el, instance, input.dfResults, input.strGroupSubset);

                // Apply initial group subset.
                const groupSubset = getGroupSubset(
                    input.dfResults,
                    input.strGroupSubset
                );

                const updatedResults = input.dfResults.filter((d) =>
                    groupSubset.includes(d.GroupID)
                );

                instance.updateTable(updatedResults);
            },
            resize: function(width, height) {
            }
        };
    }
});
