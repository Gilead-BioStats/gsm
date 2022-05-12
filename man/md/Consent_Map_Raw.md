# Data specification

|domain    |col_key        |col_value     |vRequired |vNACols |vUniqueCols |
|:---------|:--------------|:-------------|:---------|:-------|:-----------|
|dfSUBJ    |strIDCol       |SubjectID     |TRUE      |        |TRUE        |
|dfSUBJ    |strSiteCol     |SiteID        |TRUE      |        |FALSE       |
|dfSUBJ    |strRandDateCol |RandDate      |TRUE      |        |FALSE       |
|dfCONSENT |strIDCol       |SubjectID     |TRUE      |FALSE   |            |
|dfCONSENT |strTypeCol     |CONSENT_TYPE  |TRUE      |FALSE   |            |
|dfCONSENT |strValueCol    |CONSENT_VALUE |TRUE      |FALSE   |            |
|dfCONSENT |strDateCol     |CONSENT_DATE  |TRUE      |TRUE    |            |
