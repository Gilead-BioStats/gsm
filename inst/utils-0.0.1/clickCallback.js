const clickCallback = function(d, siteSelect, instance) {
    // update chart config
    instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.groupid)
        ? 'None'
        : d.groupid;

    // update dropdown
    siteSelect.value = instance.data.config.selectedGroupIDs;

    // update chart
    instance.helpers.updateConfig(instance, instance.data.config);
};
