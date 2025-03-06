/**
 * Add a dropdown that allows the user to select the outcome to display on the y-axis of the chart.
 *
 * @param {HTMLElement} el - The chart element.
 * @param {Object} dfResults - Analysis results data.
 * @param {Object} lMetric - Metric-level metadata.
 * @param {Object} dfGroups - Group-level metadata.
 * @param {string} strOutcome - The initial outcome to display on the y-axis.
 */

const addOutcomeSelect = function(widgetControls, dfResults, lMetric, dfGroups, strOutcome) {
    const outcomeSelect = addSelectControl(
        widgetControls,
        'Outcome (y-axis)',
        [
            'Score',
            'Metric',
            'Numerator'
        ],
        false, // disable "None" option
        strOutcome // set initial selectection
    );

    // add event listener to outcome select
    const instance = widgetControls.parentNode.getElementsByTagName('canvas')[0].chart;
    outcomeSelect.addEventListener('change', event => {
        // Update y-axis outcome and label.
        instance.data.config.y = event.target.value;
        instance.data.config.yLabel = lMetric[ event.target.value ];

        // barChart
        if (Object.keys(instance.helpers).includes('updateConfig')) {
            instance.helpers.updateData(
                instance,
                dfResults,
                instance.data.config,
                instance.data._thresholds_,
                dfGroups
            );
        }
        // timeSeries
        else if (Object.keys(instance.helpers).includes('updateSelectedGroupIDs')) {
            instance.helpers.updateData(
                instance,
                dfResults,
                instance.data.config,
                instance.data._thresholds_,
                null,
                dfGroups
            )
        }
    });

    return outcomeSelect;
}

