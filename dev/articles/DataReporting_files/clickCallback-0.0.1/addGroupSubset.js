const addGroupSubset = function (el, instance, results, initialSubset) {
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
            results,
            event.target.value
        );
        const updatedResults = results.filter((d) =>
            groupSubset.includes(d.GroupID)
        );

        instance.updateTable(updatedResults);
    });
};

const getGroupSubset = function (results, subset) {
    let groups;
    switch (subset) {
        case 'red':
            groups = [
                ...new Set(
                    results
                        .filter((d) => Math.abs(parseInt(d.Flag)) === 2)
                        .map((d) => d.GroupID)
                ),
            ];
            break;
        case 'amber':
            groups = [
                ...new Set(
                    results
                        .filter((d) => Math.abs(parseInt(d.Flag)) === 1)
                        .map((d) => d.GroupID)
                ),
            ];
            break;
        case 'red/amber':
            groups = [
                ...new Set(
                    results
                        .filter((d) => Math.abs(parseInt(d.Flag)) >= 1)
                        .map((d) => d.GroupID)
                ),
            ];
            break;
        default:
            groups = [...new Set(results.map((d) => d.GroupID))];
    }

    return groups;
};

