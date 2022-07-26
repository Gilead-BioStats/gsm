# Data specification

|**Domain** |**Column Key**                       |**Default Value** |**Required?** |**Accept NA/Empty Values?** |**Require Unique Values?** |
|:----------|:------------------------------------|:-----------------|:-------------|:---------------------------|:--------------------------|
|dfSUBJ     |strIDCol                             |SubjectID         |TRUE          |FALSE                       |TRUE                       |
|dfSUBJ     |strSiteCol                           |SiteID            |TRUE          |FALSE                       |FALSE                      |
|dfDISP     |strIDCol                             |SubjectID         |TRUE          |FALSE                       |FALSE                      |
|dfDISP     |strTreatmentDiscontinuationReasonCol |TrtDCReason       |TRUE          |TRUE                        |FALSE                      |
|dfDISP     |strTreatmentCompletionFlagCol        |TrtCompletion     |TRUE          |TRUE                        |FALSE                      |
