/**
 * Adds a dropdown to highlight the selected site in the chart
 *
 * @param {Node} el - an element in the DOM
 * @param {Array} results - KRI results (dfSummary)
 * @param {Object} instance - Chart.js chart object
 *
 * @returns {Node} HTML select element
 */
const addSiteSelect = function(el, results, instance, siteSelectLabelValue) {
    el.style.position = 'relative';

    // add container in which to place dropdown
    const siteSelectContainer = document.createElement('div');
    el.appendChild(siteSelectContainer);

    // position container absolutely in upper left corner of `el`.
    siteSelectContainer.style.position = 'absolute';
    siteSelectContainer.style.top = 0;
    siteSelectContainer.style.left = 0;

    // add dropdown label
    const siteSelectLabel = document.createElement('span');
    siteSelectLabel.innerHTML = siteSelectLabelValue;
    siteSelectContainer.appendChild(siteSelectLabel)

    // add dropdown
    const siteSelect = document.createElement('select');
    siteSelectContainer.appendChild(siteSelect);

    // add default option
    const noneOption = document.createElement('option');
    noneOption.innerHTML = 'None';
    siteSelect.appendChild(noneOption);

    // get sorted array of sites
    const sites = [
        ...new Set(results.map(d => d.groupid))
    ];
    const numericSites = sites.every(site => /^\d+$/.test(site));
    sites.sort((a,b) => {
        return numericSites
            ? a - b
            : a < b ? -1
            : b < a ?  1 : 0;
    });

    // add option to dropdown for each site
    for (const site of sites) {
        const siteOption = document.createElement('option');
        siteOption.innerHTML = site;
        siteSelect.appendChild(siteOption);
        siteSelect.classList.add('site-select');
    }

    // add event listener to dropdown that updates chart
    siteSelect.addEventListener('change', event => {
        instance.data.config.selectedGroupIDs = event.target.value; // site
        instance.helpers.updateConfig(instance, instance.data.config, instance.data._thresholds_);
    });

    return siteSelect;
}
