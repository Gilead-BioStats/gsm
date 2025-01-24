HTMLWidgets.widget({
    name: 'Widget_ScatterPlot',
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
                addWidgetControls(
                    el,
                    input.dfResults,
                    input.lMetric,
                    input.dfGroups,
                    input.bAddGroupSelect,
                    false
                );

                // Add a footnote below the scatter plot.
                const footnote = document.createElement('div'); // Create a div for the footnote.
                footnote.style.fontSize = '10px'; // Set a smaller font size for the footnote.
                footnote.style.color = '#555'; // Use a lighter color for the footnote text.

                // Set the content of the footnote from the input.
                footnote.innerHTML = input.strFootnote; // Use the footnote passed from R.

                // Append the footnote div to the element containing the scatter plot.
                el.appendChild(footnote);
            },
            resize: function(width, height) {
            }
        };
    }
});
