# Data specification

|**Domain** |**Column Key** |**Default Value** |**Required?** |**Accept NA/Empty Values?** |**Require Unique Values?** |
|:----------|:--------------|:-----------------|:-------------|:---------------------------|:--------------------------|
|dfSUBJ     |strSiteCol     |siteid            |TRUE          |FALSE                       |FALSE                      |
|dfSUBJ     |strEDCIDCol    |subject_nsv       |TRUE          |FALSE                       |TRUE                       |
|dfQUERY    |strIDCol       |subjectname       |TRUE          |FALSE                       |FALSE                      |
|dfQUERY    |strVisitCol    |visit             |TRUE          |TRUE                        |FALSE                      |
|dfQUERY    |strFormCol     |formoid           |TRUE          |FALSE                       |FALSE                      |
|dfDATACHG  |strIDCol       |subjectname       |TRUE          |FALSE                       |FALSE                      |
|dfDATACHG  |strVisitCol    |visit             |TRUE          |TRUE                        |FALSE                      |
|dfDATACHG  |strFormCol     |formoid           |TRUE          |FALSE                       |FALSE                      |
