/**
 * Define unique set of country values.
 *
 * @param {Array} dfGroups - group metadata
 * @param {Array} groups - group IDs present in analysis results
 *
 * @returns {Array} unique countries
 */
const getCountries = function(dfGroups, groups) {
    const countries = [...new Set(
        dfGroups
            .filter(
                d => d.Param === 'Country'
            )
            .filter(
                d => groups.includes(d.GroupID)
            )
            .map(
                d => d.Value
            )
    )].sort((a,b) => a < b ? -1 : b < a ? 1 : 0);

    return countries;
};
