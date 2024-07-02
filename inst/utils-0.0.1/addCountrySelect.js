/**
 * Adds a dropdown to highlight the selected country in the chart
 *
 * @param {Node} el - an element in the DOM
 * @param {Array} results - KRI results (dfSummary)
 * @param {Object} instance - Chart.js chart object
 *
 * @returns {Node} HTML select element
 */


// Add event listener to highlight countries.
const addCountrySelect = function(el, results, instance, groupSelect) {

    el.style.position = 'relative';

    // add container in which to place dropdown
    const countrySelectContainer = document.createElement('div');
    el.appendChild(countrySelectContainer);

    // position container absolutely in upper left corner of `el`.
    countrySelectContainer.style.position = 'absolute';
    countrySelectContainer.style.top = 0;
    countrySelectContainer.style.left = "175px";

    // add dropdown label
    const countrySelectLabel = document.createElement('span');
    countrySelectLabel.classList.add("gsm-country-select-label")
    countrySelectLabel.innerHTML = "Country: ";
    countrySelectContainer.appendChild(countrySelectLabel)

    // add dropdown
    const countrySelect = document.createElement('select');
    countrySelectContainer.appendChild(countrySelect);

    // add default option
    const noneOption = document.createElement('option');
    noneOption.innerHTML = 'None';
    countrySelect.appendChild(noneOption);

    // get sorted array of country
    const countries = [
        ...new Set(results.map(d => d.site.country))
    ];
    const numericCountry = countries.every(country => /^\d+$/.test(country));
    countries.sort((a,b) => {
        return numericCountry
            ? a - b
            : a < b ? -1
            : b < a ?  1 : 0;
    });

    // add option to dropdown for each country
    for (const country of countries) {
        const countryOption = document.createElement('option');
        countryOption.innerHTML = country;
        countrySelect.appendChild(countryOption);
        countrySelect.classList.add('country-select');
    }


    // add event listener to dropdown that updates chart
    countrySelect.addEventListener('change', event => {
        groupSelect.value = "None";
        countryFilter =
        instance.data.config.selectedGroupIDs = results.filter(d => d.site.country === event.target.value).map(d => d.GroupID); // country
        instance.helpers.updateConfig(instance, instance.data.config, instance.data._thresholds_);
    });

        // add event listener to dropdown that updates chart
    groupSelect.addEventListener('change', event => {
        countrySelect.value = "None";
    });


    return countrySelect;
};
