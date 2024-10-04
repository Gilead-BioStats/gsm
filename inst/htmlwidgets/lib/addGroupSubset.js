/**
 * Add a dropdown to the top of the table that allows the user to filter the table by group subset.
 *
 * @param {HTMLElement} el - element in which to place dropdown
 * @param {Object} instance - rbmViz groupOverview instance
 * @param {Array} dfResults - analysis results for one or more metrics
 * @param {String} initialSubset - initial subset of group IDs to display
 *
 * @returns {undefined}
 */
const addGroupSubset = function (el, instance, dfResults, initialSubset) {
    // add container in which to place dropdown
    const groupSubsetContainer = document.createElement('div');
    el.insertBefore(groupSubsetContainer, el.firstChild);

    // add dropdown label
    const groupSubsetLabel = document.createElement('span');
    groupSubsetLabel.innerHTML = 'Site Subset: ';
    groupSubsetContainer.appendChild(groupSubsetLabel)

    // add dropdown
    const groupSubset = document.createElement('select');
    groupSubsetContainer.appendChild(groupSubset);

    // add options
    const subsets = ['all', 'red/amber', 'red', 'amber'];
    for (const subset of subsets) {
        const option = document.createElement('option');
        let innerHTML
        switch (subset) {
            case 'all':
                innerHTML = 'All';
                break;
            case 'red/amber':
                innerHTML = '1+ flag';
                break;
            case 'red':
                innerHTML = '1+ red flag';
                break;
            case 'amber':
                innerHTML = '1+ amber flag';
                break;
            default:
                innerHTML = 'this should not happen';
        }
        option.innerHTML = innerHTML;
        option.value = subset;
        option.selected = subset === initialSubset;
        groupSubset.appendChild(option);
    }

    // add event listener to dropdown that updates chart
    groupSubset.addEventListener('change', event => {
        const groupSubset = getGroupSubset(
            dfResults,
            event.target.value
        );
        const updatedResults = dfResults.filter((d) =>
            groupSubset.includes(d.GroupID)
        );

        instance.updateTable(updatedResults);
    });
};

/**
 * Get the subset of group IDs to display in the table.
 *
 * @param {Array} dfResults - analysis results for one or more metrics
 * @param {String} subset - subset of group IDs to display
 *
 * @returns {Array} subset of group IDs
 */
const getGroupSubset = function (dfResults, subset) {
    let groups;
    switch (subset) {
        case 'red':
            groups = [
                ...new Set(
                    dfResults
                        .filter((d) => Math.abs(parseInt(d.Flag)) === 2)
                        .map((d) => d.GroupID)
                ),
            ];
            break;
        case 'amber':
            groups = [
                ...new Set(
                    dfResults
                        .filter((d) => Math.abs(parseInt(d.Flag)) === 1)
                        .map((d) => d.GroupID)
                ),
            ];
            break;
        case 'red/amber':
            groups = [
                ...new Set(
                    dfResults
                        .filter((d) => Math.abs(parseInt(d.Flag)) >= 1)
                        .map((d) => d.GroupID)
                ),
            ];
            break;
        default:
            groups = [...new Set(dfResults.map((d) => d.GroupID))];
    }

    return groups;
};

