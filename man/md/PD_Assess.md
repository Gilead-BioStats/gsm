# Data specification

|**Domain** |**Column Key** |**Default Value** |**Required?** |**Require Unique Values?** |**Accept NA/Empty Values?** |
|:----------|:--------------|:-----------------|:-------------|:--------------------------|:---------------------------|
|dfInput    |strIDCol       |SubjectID         |TRUE          |TRUE                       |FALSE                       |
|dfInput    |strCountCol    |Count             |TRUE          |FALSE                      |FALSE                       |
|dfInput    |strExposureCol |Exposure          |FALSE         |FALSE                      |TRUE                        |
|dfInput    |strRateCol     |Rate              |FALSE         |FALSE                      |TRUE                        |
|dfInput    |strGroupCol    |SiteID            |TRUE          |FALSE                      |FALSE                       |
