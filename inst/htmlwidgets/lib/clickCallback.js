const clickCallback = function(el, input) {
    return function(d) {
        // Get chart instance, attached to canvas element.
        const canvas = el.querySelector('canvas');
        const instance = canvas.chart;

        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.GroupID)
            ? 'None'
            : d.GroupID;

        // Update group select.
        const groupSelect = el.querySelector('.gsm-widget-control--group');
        if (groupSelect !== null)
            groupSelect.value = instance.data.config.selectedGroupIDs;

        // Set country select to 'None' if a group ID is selected.
        const countrySelect = el.querySelector('.gsm-widget-control--country');
        if (countrySelect !== null)
            countrySelect.value = "None";

        // Update barChart and scatterPlot.
        if (Object.keys(instance.helpers).includes('updateConfig')) {
            instance.helpers.updateConfig(
                instance,
                instance.data.config
            );
        }

        // Update timeSeries.
        else if (Object.keys(instance.helpers).includes('updateSelectedGroupIDs')) {
            if (instance.data.config.selectedGroupIDs === 'None')
                delete instance.data.config.selectedGroupIDs;
            instance.helpers.updateSelectedGroupIDs(
                instance.data.config.selectedGroupIDs
            );
        }

        // Update Shiny input if in Shiny environment.
        if (typeof Shiny !== 'undefined') {
            if (instance.data.config.selectedGroupIDs.length > 0) {
                Shiny.setInputValue(
                    input.strShinyGroupSelectID,
                    instance.data.config.selectedGroupIDs
                )
            }
        }

        // Dispatch [ riskSignalSelected ] event.
        instance.canvas.dispatchEvent(instance.canvas.riskSignalSelected);
    };
};
