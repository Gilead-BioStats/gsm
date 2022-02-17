library(tidyverse)

dfDisp <- gsm::Disp_Map(dfDisp = safetyData::adam_adsl, strCol = "DCREASCD", strReason = "adverse event")

lAssess <- list()
lAssess$dfDisp <- dfDisp
lAssess$dfTransformed <- gsm::Transform_EventCount( lAssess$dfDisp, cCountCol = "Count")

names(lAssess$dfTransformed)

# doesn't work because Analyze_Wilcoxon() requires columns: "SiteID", "N", "TotalExposure", "TotalCount", "Rate"
lAssess$dfAnalyzed <- gsm::Analyze_Wilcoxon( lAssess$dfTransformed)




clindata::rawplus_rdsl %>% janitor::tabyl(RandFlag)
