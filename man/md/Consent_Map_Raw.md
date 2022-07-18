# Data specification

|**Domain** |**Column Key** |**Default Value** |**Required?** |**Accept NA/Empty Values?** |**Require Unique Values?** |
|:----------|:--------------|:-----------------|:-------------|:---------------------------|:--------------------------|
|dfSUBJ     |strIDCol       |SubjectID         |TRUE          |FALSE                       |TRUE                       |
|dfSUBJ     |strSiteCol     |SiteID            |TRUE          |FALSE                       |FALSE                      |
|dfSUBJ     |strRandDateCol |RandDate          |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strIDCol       |SubjectID         |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strTypeCol     |CONSENT_TYPE      |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strValueCol    |CONSENT_VALUE     |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strDateCol     |CONSENT_DATE      |TRUE          |TRUE                        |FALSE                      |
