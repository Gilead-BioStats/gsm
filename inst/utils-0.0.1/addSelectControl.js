const addSelectControl = function(widgetControls, label, values) {
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
    const noneOption = document.createElement('option');
    noneOption.innerHTML = 'None';
    select.appendChild(noneOption);

    // add data-driven values
    for (const value of values) {
        const option = document.createElement('option');
        option.innerHTML = value;
        select.appendChild(option);
    }

    return select;
}
