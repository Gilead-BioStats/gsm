/**
 * Adds a dropdown to highlight the selected group ID or set of group IDs in the chart.
 *
 * @param {Node} el - widget container, an element in the DOM
 * @param {Array} dfResults - analysis results for a single metric
 * @param {Object} lMetric - metric metadata
 * @param {Array} dfGroups - group metadata
 * @param {boolean} bAddGroupSelect - whether to add a group select dropdown
 *
 * @returns {Node} HTML select element
 */
const addWidgetControls = function(el, dfResults, lMetric, dfGroups, bAddGroupSelect) {
    if (!bAddGroupSelect)
        return {
            widgetControls: null,
            groupSelect: null,
            countrySelect: null
        };

    const instance = el.getElementsByTagName('canvas')[0].chart;

    // add container in which to place dropdown
    const widgetControls = document.createElement('div');
    widgetControls.classList.add('gsm-widget-controls');
    el.prepend(widgetControls);

    // add group select
    const groups = getGroups(dfResults);
    const groupSelect = addSelectControl(
        widgetControls,
        `Highlighted ${lMetric?.GroupLevel || 'Group'}`,
        groups
    );
    groupSelect.classList.add('gsm-widget-control--group');

    // add country select
    let countrySelect;
    if (dfGroups) {
        const countries = getCountries(dfGroups, groups);
        countrySelect = addSelectControl(
            widgetControls,
            'Country',
            countries
        );
        countrySelect.classList.add('gsm-widget-control--country');
    }

    // add event listener to group select
    groupSelect.addEventListener('change', event => {
        if (countrySelect)
            countrySelect.value = "None";
        instance.data.config.selectedGroupIDs = event.target.value;

        // scatterPlot and barChart
        if (Object.keys(instance.helpers).includes('updateConfig')) {
            instance.helpers.updateConfig(instance, instance.data.config, instance.data._thresholds_);
        }
        // timeSeries
        else if (Object.keys(instance.helpers).includes('updateSelectedGroupIDs')) {
            instance.helpers.updateSelectedGroupIDs(instance.data.config.selectedGroupIDs);
        }

        // Dispatch [ riskSignalSelected ] event.
        instance.canvas.dispatchEvent(instance.canvas.riskSignalSelected);
    });

    // add event listener to country select
    if (countrySelect)
        countrySelect.addEventListener('change', event => {
            groupSelect.value = "None";

            const countrySubset = dfGroups
                .filter(
                    d => d.Param === 'Country'
                )
                .filter(
                    d => d.Value === event.target.value
                )
                .map(
                    d => d.GroupID
                );

            instance.data.config.selectedGroupIDs = countrySubset;

            // scatterPlot and barChart
            if (Object.keys(instance.helpers).includes('updateConfig')) {
                instance.helpers.updateConfig(instance, instance.data.config);
            }
            // timeSeries
            else if (Object.keys(instance.helpers).includes('updateSelectedGroupIDs')) {
                instance.helpers.updateSelectedGroupIDs(instance.data.config.selectedGroupIDs);
            }
        });

    return {
        widgetControls,
        groupSelect,
        countrySelect
    };
}
