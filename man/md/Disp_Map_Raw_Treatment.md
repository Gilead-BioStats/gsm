# Data specification

|**Domain** |**Column Key**                       |**Default Value** |**Required?** |**Accept NA/Empty Values?** |**Require Unique Values?** |
|:----------|:------------------------------------|:-----------------|:-------------|:---------------------------|:--------------------------|
|dfSUBJ     |strSiteCol                           |siteid            |TRUE          |FALSE                       |FALSE                      |
|dfSUBJ     |strIDCol                             |subjectid         |TRUE          |FALSE                       |TRUE                       |
|dfSDRGCOMP |strIDCol                             |subjectid         |TRUE          |FALSE                       |FALSE                      |
|dfSDRGCOMP |strTreatmentDiscontinuationReasonCol |sdrgreas          |TRUE          |TRUE                        |FALSE                      |
|dfSDRGCOMP |strTreatmentCompletionFlagCol        |sdrgyn            |TRUE          |TRUE                        |FALSE                      |
