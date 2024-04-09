# Data specification

|**Domain** |**Column Key**                 |**Default Value** |**Required?** |**Accept NA/Empty Values?** |**Require Unique Values?** |
|:----------|:------------------------------|:-----------------|:-------------|:---------------------------|:--------------------------|
|dfSUBJ     |strSiteCol                     |siteid            |TRUE          |FALSE                       |FALSE                      |
|dfSUBJ     |strIDCol                       |subjid            |TRUE          |FALSE                       |TRUE                       |
|dfSTUDCOMP |strIDCol                       |subjid            |TRUE          |FALSE                       |FALSE                      |
|dfSTUDCOMP |strStudyDiscontinuationFlagCol |compyn            |TRUE          |TRUE                        |FALSE                      |
