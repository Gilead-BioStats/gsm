const detailButton = document.querySelector('.btn-show-details');

if (detailButton !== null) {
    let hidden = false;

    detailButton.addEventListener('click', function() {
        const shownTable = document.querySelector('#study_table');
        const hiddenTable = document.querySelector('#study_table_hide');
        const hiddenPlot = document.querySelector("#timeline");
        const toggleLabel = document.querySelector('.toggle-label');

        if (!hidden) {
            shownTable.style.display = 'none';
            hiddenTable.style.display = 'block';
            hiddenPlot.style.display = "block";
            toggleLabel.innerHTML = 'Hide Details';
            hidden = true;
        } else {
            shownTable.style.display = 'block';
            hiddenTable.style.display = 'none';
            hiddenPlot.style.display = "none";
            toggleLabel.innerHTML = 'Show Details';
            hidden = false;
        }
    })
}
