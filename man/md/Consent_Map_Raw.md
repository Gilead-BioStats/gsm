# Data specification

|**Domain** |**Column Key** |**Default Value** |**Required?** |**Accept NA/Empty Values?** |**Require Unique Values?** |
|:----------|:--------------|:-----------------|:-------------|:---------------------------|:--------------------------|
|dfSUBJ     |strIDCol       |SubjectID         |TRUE          |FALSE                       |TRUE                       |
|dfSUBJ     |strSiteCol     |SiteID            |TRUE          |FALSE                       |FALSE                      |
|dfSUBJ     |strRandDateCol |RandDate          |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strIDCol       |subjid            |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strTypeCol     |conscat           |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strValueCol    |consyn            |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strDateCol     |consdt            |TRUE          |TRUE                        |FALSE                      |
