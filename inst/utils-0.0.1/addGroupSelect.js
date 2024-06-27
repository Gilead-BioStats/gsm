/**
 * Adds a dropdown to highlight the selected group in the chart
 *
 * @param {Node} el - an element in the DOM
 * @param {Array} results - KRI results (dfSummary)
 * @param {Object} instance - Chart.js chart object
 *
 * @returns {Node} HTML select element
 */
const addGroupSelect = function(el, results, instance, groupSelectLabelValue) {
    el.style.position = 'relative';

    // add container in which to place dropdown
    const groupSelectContainer = document.createElement('div');
    el.appendChild(groupSelectContainer);

    // position container absolutely in upper left corner of `el`.
    groupSelectContainer.style.position = 'absolute';
    groupSelectContainer.style.top = 0;
    groupSelectContainer.style.left = 0;

    // add dropdown label
    const groupSelectLabel = document.createElement('span');
    groupSelectLabel.classList.add("gsm-group-select-label")
    groupSelectLabel.innerHTML = groupSelectLabelValue;
    groupSelectContainer.appendChild(groupSelectLabel)

    // add dropdown
    const groupSelect = document.createElement('select');
    groupSelectContainer.appendChild(groupSelect);

    // add default option
    const noneOption = document.createElement('option');
    noneOption.innerHTML = 'None';
    groupSelect.appendChild(noneOption);

    // get sorted array of groups
    const groups = [
        ...new Set(results.map(d => d.GroupID))
    ];
    const numericgroups = groups.every(group => /^\d+$/.test(group));
    groups.sort((a,b) => {
        return numericgroups
            ? a - b
            : a < b ? -1
            : b < a ?  1 : 0;
    });

    // add option to dropdown for each group
    for (const group of groups) {
        const groupOption = document.createElement('option');
        groupOption.innerHTML = group;
        groupSelect.appendChild(groupOption);
        groupSelect.classList.add('group-select');
    }

    // add event listener to dropdown that updates chart
    groupSelect.addEventListener('change', event => {
        instance.data.config.selectedGroupIDs = event.target.value; // group
        instance.helpers.updateConfig(instance, instance.data.config, instance.data._thresholds_);
    });

    return groupSelect;
}
