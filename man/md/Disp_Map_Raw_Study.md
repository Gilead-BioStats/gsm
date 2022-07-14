# Data specification

|**Domain** |**Column Key**                   |**Default Value** |**Required?** |**Accept NA/Empty Values?** |**Require Unique Values?** |
|:----------|:--------------------------------|:-----------------|:-------------|:---------------------------|:--------------------------|
|dfSUBJ     |strIDCol                         |SubjectID         |TRUE          |FALSE                       |TRUE                       |
|dfSUBJ     |strSiteCol                       |SiteID            |TRUE          |FALSE                       |FALSE                      |
|dfDISP     |strIDCol                         |                  |TRUE          |FALSE                       |FALSE                      |
|dfDISP     |strStudyDiscontinuationReasonCol |                  |TRUE          |TRUE                        |FALSE                      |
|dfDISP     |strStudyCompletionFlagCol        |                  |TRUE          |TRUE                        |FALSE                      |
