# Data specification

|**Domain** |**Column Key** |**Default Value** |**Required?** |**Accept NA/Empty Values?** |**Require Unique Values?** |
|:----------|:--------------|:-----------------|:-------------|:---------------------------|:--------------------------|
|dfSUBJ     |strSiteCol     |siteid            |TRUE          |FALSE                       |FALSE                      |
|dfSUBJ     |strIDCol       |subjid            |TRUE          |FALSE                       |TRUE                       |
|dfSUBJ     |strRandDateCol |rfpen_dt          |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strIDCol       |subjid            |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strTypeCol     |conscat           |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strValueCol    |consyn            |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strDateCol     |consdt            |TRUE          |TRUE                        |FALSE                      |
