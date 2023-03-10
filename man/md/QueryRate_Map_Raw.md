# Data specification

|**Domain** |**Column Key** |**Default Value** |**Required?** |**Accept NA/Empty Values?** |**Require Unique Values?** |
|:----------|:--------------|:-----------------|:-------------|:---------------------------|:--------------------------|
|dfSUBJ     |strSiteCol     |siteid            |TRUE          |FALSE                       |FALSE                      |
|dfSUBJ     |strEDCIDCol    |subject_nsv       |TRUE          |FALSE                       |TRUE                       |
|dfQUERY    |strIDCol       |                  |TRUE          |FALSE                       |FALSE                      |
|dfQUERY    |strVisitCol    |                  |TRUE          |TRUE                        |FALSE                      |
|dfQUERY    |strFormCol     |                  |TRUE          |FALSE                       |FALSE                      |
|dfDATACHG  |strIDCol       |                  |TRUE          |FALSE                       |FALSE                      |
|dfDATACHG  |strVisitCol    |                  |TRUE          |TRUE                        |FALSE                      |
|dfDATACHG  |strFormCol     |                  |TRUE          |FALSE                       |FALSE                      |
