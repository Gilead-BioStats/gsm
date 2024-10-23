/**
 * Toggles between two tables when a checkbox is clicked.
 *
 * The checkbox element should have the following data attributes:
 * - data-shown-table: The ID of the table to show when hidden.
 * - data-hidden-table: The ID of the table to hide when shown.
 *
 * @param {HTMLInputElement} checkbox - The checkbox element that triggers the toggle action.
 */
function toggleTables(checkbox) {
    const hidden = checkbox.checked;

    const shownTableId = checkbox.dataset.shownTable;
    const hiddenTableId = checkbox.dataset.hiddenTable;

    const shownTable = document.querySelector(`#${shownTableId}`);
    const hiddenTable = document.querySelector(`#${hiddenTableId}`);
    const toggleLabel = checkbox.parentElement.querySelector('.toggle-label');

    if (hidden) {
        shownTable.style.display = 'none';
        hiddenTable.style.display = 'block';
        toggleLabel.innerHTML = 'Hide Details';
    } else {
        shownTable.style.display = 'block';
        hiddenTable.style.display = 'none';
        toggleLabel.innerHTML = 'Show Details';
    }
}
