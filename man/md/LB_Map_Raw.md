# Data specification

|**Domain** |**Column Key**    |**Default Value** |**Required?** |**Accept NA/Empty Values?** |**Require Unique Values?** |
|:----------|:-----------------|:-----------------|:-------------|:---------------------------|:--------------------------|
|dfSUBJ     |strIDCol          |SubjectID         |TRUE          |FALSE                       |TRUE                       |
|dfSUBJ     |strSiteCol        |SiteID            |TRUE          |FALSE                       |FALSE                      |
|dfLB       |strIDCol          |SubjectID         |TRUE          |TRUE                        |FALSE                      |
|dfLB       |strGradeCol       |LB_GRADE          |TRUE          |TRUE                        |FALSE                      |
|dfSUBJ     |strAlternateIDCol |                  |FALSE         |TRUE                        |FALSE                      |
