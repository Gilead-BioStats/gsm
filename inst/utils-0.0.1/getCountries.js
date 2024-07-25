const getCountries = function(dfGroups) {
    const countries = [...new Set(
        dfGroups
            .filter(
                d => d.Param === 'Country'
            )
            .map(
                d => d.Value
            )
    )].sort((a,b) => a < b ? -1 : b < a ? 1 : 0);

    return countries;
};
