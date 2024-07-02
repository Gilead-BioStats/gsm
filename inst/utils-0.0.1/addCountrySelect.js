/**
 * Adds a dropdown to highlight the selected country in the chart
 *
 * @param {Node} el - an element in the DOM
 * @param {Array} siteDetails - Site details (dfSite)
 * @param {Object} instance - Chart.js chart object
 *
 * @returns {Node} HTML select element
 */


// Add event listener to highlight countries.
const addCountrySelect = function(el, siteDetails, instance, siteSelect) {

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
        ...new Set(siteDetails.map(d => d.country))
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


    return countrySelect;
};
