HTMLWidgets.widget({
    name: 'Widget_BarChart',
    type: 'output',
    factory: function(el, width, height) {
        return {
            renderValue: function(input) {
                if (input.bDebug)
                    console.log(input);

                // Coerce `input.lMetric` to an object if it is not already.
                if (Object.prototype.toString.call(input.lMetric) !== '[object Object]') {
                    input.lMetric = {};
                };

                // Assign a unique ID to the element.
                el.id = `barChart--${input.lMetric.MetricID}_${input.strOutcome}`;

                // Add click event listener to chart.
                input.lMetric.clickCallback = clickCallback(el, input);

                // Generate bar chart.
                const instance = rbmViz.default.barChart(
                    el,
                    input.dfResults,
                    {...input.lMetric, y: input.strOutcome}, // specify outcome to be plotted on the y-axis
                    input.vThreshold,
                    input.dfGroups
                );

                // Add dropdowns that highlight group IDs.
                const { widgetControls } = addWidgetControls(
                    el,
                    input.dfResults,
                    input.lMetric,
                    input.dfGroups,
                    input.bAddGroupSelect
                );

                // Add a dropdown that changes the outcome variable.
                const outcomeSelect = addOutcomeSelect(
                    widgetControls,
                    input.dfResults,
                    input.lMetric,
                    input.dfGroups,
                    input.strOutcome
                );
            },
            resize: function(width, height) {
            }
        };
    }
});
