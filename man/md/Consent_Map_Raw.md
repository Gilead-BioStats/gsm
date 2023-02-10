# Data specification

|**Domain** |**Column Key**      |**Default Value** |**Required?** |**Accept NA/Empty Values?** |**Require Unique Values?** |
|:----------|:-------------------|:-----------------|:-------------|:---------------------------|:--------------------------|
|dfSUBJ     |strSiteCol          |siteid            |TRUE          |FALSE                       |FALSE                      |
|dfSUBJ     |strIDCol            |subjid            |TRUE          |FALSE                       |TRUE                       |
|dfCONSENT  |strIDCol            |subjid            |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strDateCol          |consdt            |TRUE          |TRUE                        |FALSE                      |
|dfCONSENT  |strConsentStatusCol |consyn            |TRUE          |FALSE                       |FALSE                      |
|dfCONSENT  |strConsentTypeCol   |conscat           |TRUE          |FALSE                       |FALSE                      |
|dfSUBJ     |strRandDateCol      |                  |TRUE          |FALSE                       |FALSE                      |
