# Data specification

|**Domain** |**Column Key**                   |**Default Value** |**Required?** |**Accept NA/Empty Values?** |**Require Unique Values?** |
|:----------|:--------------------------------|:-----------------|:-------------|:---------------------------|:--------------------------|
|dfSUBJ     |strSiteCol                       |siteid            |TRUE          |FALSE                       |FALSE                      |
|dfSUBJ     |strIDCol                         |subjectid         |TRUE          |FALSE                       |TRUE                       |
|dfDISP     |strIDCol                         |subjectid         |TRUE          |FALSE                       |FALSE                      |
|dfDISP     |strStudyDiscontinuationReasonCol |compreas          |TRUE          |TRUE                        |FALSE                      |
|dfDISP     |strStudyCompletionFlagCol        |compyn            |TRUE          |TRUE                        |FALSE                      |
