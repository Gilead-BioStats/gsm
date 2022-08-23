# Data specification

|**Domain** |**Column Key**                       |**Default Value** |**Required?** |**Accept NA/Empty Values?** |**Require Unique Values?** |
|:----------|:------------------------------------|:-----------------|:-------------|:---------------------------|:--------------------------|
|dfSUBJ     |strSiteCol                           |siteid            |TRUE          |FALSE                       |FALSE                      |
|dfSUBJ     |strIDCol                             |subjectid         |TRUE          |FALSE                       |TRUE                       |
|dfDISP     |strIDCol                             |subjectid         |TRUE          |FALSE                       |FALSE                      |
|dfDISP     |strTreatmentDiscontinuationReasonCol |sdrgreas          |TRUE          |TRUE                        |FALSE                      |
|dfDISP     |strTreatmentCompletionFlagCol        |sdrgyn            |TRUE          |TRUE                        |FALSE                      |
