# Data specification

|domain    |col_key        |col_value     |vRequired |vNACols |vUniqueCols |
|:---------|:--------------|:-------------|:---------|:-------|:-----------|
|dfSUBJ    |strIDCol       |SubjectID     |TRUE      |NA      |TRUE        |
|dfSUBJ    |strSiteCol     |SiteID        |TRUE      |NA      |FALSE       |
|dfSUBJ    |strRandDateCol |RandDate      |TRUE      |NA      |FALSE       |
|dfCONSENT |strIDCol       |SubjectID     |TRUE      |FALSE   |NA          |
|dfCONSENT |strTypeCol     |CONSENT_TYPE  |TRUE      |FALSE   |NA          |
|dfCONSENT |strValueCol    |CONSENT_VALUE |TRUE      |FALSE   |NA          |
|dfCONSENT |strDateCol     |CONSENT_DATE  |TRUE      |TRUE    |NA          |
