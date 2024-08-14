HTMLWidgets.widget({
    name: 'Widget_ScatterPlot',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                if (input.bDebug)
                    console.log(input);

                // Assign a unique ID to the element.
                el.id = `scatterPlot--${input.lMetric.MetricID}`;

                // Add click event callback to chart.
                input.lMetric.clickCallback = clickCallback(el, input);

                // Generate scatter plot.
                const instance = rbmViz.default.scatterPlot(
                    el,
                    input.dfResults,
                    input.lMetric,
                    input.dfBounds,
                    input.dfGroups
                );

                // Add dropdowns that highlight group IDs.
                const { groupSelect, countrySelect } = addWidgetControls(
                    el,
                    input.dfResults,
                    input.lMetric,
                    input.dfGroups,
                    input.bAddGroupSelect
                );
            },
            resize: function(width, height) {
            }
        };
    }
});
