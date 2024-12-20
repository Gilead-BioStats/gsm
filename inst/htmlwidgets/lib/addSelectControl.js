/**
 * Add a select control to the widget controls
 *
 * @param {HTMLElement} widgetControls - the container for the widget controls
 * @param {String} label - the label for the control
 * @param {Array} values - the values to populate the control with
 *
 * @returns {Node} HTML select element
 */
const addSelectControl = function(widgetControls, label, values, addNone = true, defaultValue = 'None') {
    // add control container
    const selectContainer = document.createElement('div');
    selectContainer.classList.add('gsm-widget-control');
    widgetControls.appendChild(selectContainer);

    // add control label
    const selectLabel = document.createElement('span');
    selectLabel.classList.add("gsm-widget-control--label")
    selectLabel.innerHTML = label;
    selectContainer.appendChild(selectLabel)

    // add control
    const select = document.createElement('select');
    select.classList.add("gsm-widget-control--select")
    selectContainer.appendChild(select);

    // add default option
    if (addNone) {
        const noneOption = document.createElement('option');
        noneOption.innerHTML = defaultValue;
        select.appendChild(noneOption);
    }

    // add data-driven values
    for (const value of values) {
        const option = document.createElement('option');
        option.innerHTML = value;
        select.appendChild(option);
    }

    // set default value
    select.value = defaultValue;

    return select;
}
