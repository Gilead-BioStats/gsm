/**
 * Adds a dropdown to highlight the selected country in the chart
 *
 * @param {Node} el - an element in the DOM
 * @param {Array} dfGroups - group metadata (dfSummary)
 * @param {Object} instance - Chart.js chart object
 *
 * @returns {Node} HTML select element
 */


// Add event listener to highlight countries.
const addCountrySelect = function(el, dfGroups, instance, groupSelect) {

    el.style.position = 'relative';

    // Selecting the group filters div to add the country select
    const filterDivs = document.getElementById('group-filters');

    // add container in which to place dropdown
    const countrySelectContainer = document.createElement('div');
    filterDivs.appendChild(countrySelectContainer);

    countrySelectContainer.style.marginTop = '5px';
    countrySelectContainer.style.marginLeft = '5px';
    countrySelectContainer.style.display = 'inline-block';
    countrySelectContainer.style.alignItems = 'center';

    // add dropdown label
    const countrySelectLabel = document.createElement('span');
    countrySelectLabel.classList.add("gsm-country-select-label");
    countrySelectLabel.style.display = 'inline-block';
    countrySelectLabel.style.marginRight = '2px';
    countrySelectLabel.innerHTML = "Country:";
    countrySelectContainer.appendChild(countrySelectLabel)

    // add dropdown
    const countrySelect = document.createElement('select');
    countrySelect.style.marginLeft = 'auto';
    countrySelectContainer.appendChild(countrySelect);

    // add default option
    const noneOption = document.createElement('option');
    noneOption.innerHTML = 'None';
    countrySelect.appendChild(noneOption);

    // get sorted array of country
    const countries = [...new Set(
        dfGroups
        .filter(
            d => d.Param === 'Country'
        )
        .map(
            d => d.Value
        )
    )].sort((a,b) => a < b ? -1 : b < a ? 1 : 0);

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
        console.log(countrySubset);

        instance.data.config.selectedGroupIDs = countrySubset;//countryFilter.map(d => d.GroupID);

        if (Object.keys(instance.helpers).includes('updateConfig')) {
            console.log(instance.data.config.selectedGroupIDs);
            instance.helpers.updateConfig(instance, instance.data.config);
        } else if (Object.keys(instance.helpers).includes('updateSelectedGroupIDs')) {
            instance.helpers.updateSelectedGroupIDs(instance.data.config.selectedGroupIDs);
        }

    });

    // add event listener to dropdown that updates chart
    groupSelect.addEventListener('change', event => {
        countrySelect.value = "None";
    });


    return countrySelect;
};