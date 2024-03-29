# code is consistently rendered as expected

    Code
      glue::glue_collapse(code, sep = "\n\n")
    Output
      library(gsm)
      library(tidyverse)
      
      # START OF cou0001
      #--- cou0001:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0001:AE_Map_Raw ---
      
      dfInput <- AE_Map_Raw(
        dfs = list(dfAE = lData[["dfAE"]], dfSUBJ = dfSUBJ),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- cou0001:AE_Assess ---
      
      lResults <- AE_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = AE", "lLabels = Adverse Event Rate", "lLabels = Adverse Events", "lLabels = Days on Study", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Country",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF cou0002
      #--- cou0002:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0002:FilterDomain ---
      
      dfAE <- FilterDomain(
        df = dfAE,
        strDomain = "dfAE",
        lMapping = lMapping,
        strColParam = lMapping[["dfAE"]][["strSeriousCol"]],
        strValParam = lMapping[["dfAE"]][["strSeriousVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0002:AE_Map_Raw ---
      
      dfInput <- AE_Map_Raw(
        dfs = list(dfAE = dfAE, dfSUBJ = lData[["dfSUBJ"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- cou0002:AE_Assess ---
      
      lResults <- AE_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = AE", "lLabels = Adverse Event Rate", "lLabels = Adverse Events", "lLabels = Days on Study", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Country",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF cou0003
      #--- cou0003:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0003:FilterDomain ---
      
      dfPD <- FilterDomain(
        df = dfPD,
        strDomain = "dfPD",
        lMapping = lMapping,
        strColParam = lMapping[["dfPD"]][["strImportantCol"]],
        strValParam = lMapping[["dfPD"]][["strNonImportantVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0003:PD_Map_Raw_Rate ---
      
      dfInput <- PD_Map_Raw_Rate(
        dfs = list(dfPD = dfPD, dfSUBJ = lData[["dfSUBJ"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- cou0003:PD_Assess_Rate ---
      
      lResults <- PD_Assess_Rate(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = PD", "lLabels = Protocol Deviation Rate", "lLabels = Protocol Deviations", "lLabels = Days on Study", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Country",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF cou0004
      #--- cou0004:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0004:FilterDomain ---
      
      dfPD <- FilterDomain(
        df = dfPD,
        strDomain = "dfPD",
        lMapping = lMapping,
        strColParam = lMapping[["dfPD"]][["strImportantCol"]],
        strValParam = lMapping[["dfPD"]][["strImportantVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0004:PD_Map_Raw_Rate ---
      
      dfInput <- PD_Map_Raw_Rate(
        dfs = list(dfSUBJ = lData[["dfSUBJ"]], dfPD = dfPD),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- cou0004:PD_Assess_Rate ---
      
      lResults <- PD_Assess_Rate(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = PD", "lLabels = Protocol Deviation Rate", "lLabels = Protocol Deviations", "lLabels = Days on Study", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Country",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF cou0005
      #--- cou0005:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0005:FilterDomain ---
      
      dfLB <- FilterDomain(
        df = dfLB,
        strDomain = "dfLB",
        lMapping = lMapping,
        strColParam = lMapping[["dfLB"]][["strGradeCol"]],
        strValParam = lMapping[["dfLB"]][["strGradeAnyVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0005:LB_Map_Raw ---
      
      dfInput <- LB_Map_Raw(
        dfs = list(dfSUBJ = lData[["dfSUBJ"]], dfLB = dfLB),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- cou0005:LB_Assess ---
      
      lResults <- LB_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = LB", "lLabels = Lab Abnormality Rate", "lLabels = Abnormal Lab Samples", "lLabels = Total Lab Samples", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Country",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF cou0006
      #--- cou0006:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0006:Disp_Map_Raw ---
      
      dfInput <- Disp_Map_Raw(
        dfs = list(dfSUBJ = dfSUBJ, dfSTUDCOMP = lData[["dfSTUDCOMP"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- cou0006:Disp_Assess ---
      
      lResults <- Disp_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = DSC", "lLabels = Discontinuation Rate", "lLabels = Subjects Discontinued", "lLabels = Total Subjects", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Country",
        nMinDenominator = 3,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF cou0007
      #--- cou0007:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0007:FilterDomain ---
      
      dfSDRGCOMP <- FilterDomain(
        df = dfSDRGCOMP,
        strDomain = "dfSDRGCOMP",
        lMapping = lMapping,
        strColParam = lMapping[["dfSDRGCOMP"]][["strTreatmentPhaseCol"]],
        strValParam = lMapping[["dfSDRGCOMP"]][["strTreatmentPhaseVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0007:Disp_Map_Raw ---
      
      dfInput <- Disp_Map_Raw(
        dfs = list(dfSUBJ = lData[["dfSUBJ"]], dfSDRGCOMP = dfSDRGCOMP),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- cou0007:Disp_Assess ---
      
      lResults <- Disp_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = DSC", "lLabels = Discontinuation Rate", "lLabels = Subjects Discontinued", "lLabels = Total Subjects", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Country",
        nMinDenominator = 3,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF cou0008
      #--- cou0008:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0008:FilterDomain ---
      
      dfQUERY <- FilterDomain(
        df = dfQUERY,
        strDomain = "dfQUERY",
        lMapping = lMapping,
        strColParam = lMapping[["dfQUERY"]][["strStatusCol"]],
        strValParam = lMapping[["dfQUERY"]][["strStatusVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0008:QueryRate_Map_Raw ---
      
      dfInput <- QueryRate_Map_Raw(
        dfs = list(dfSUBJ = lData[["dfSUBJ"]], dfQUERY = dfQUERY, dfDATACHG = lData[["dfDATACHG"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- cou0008:QueryRate_Assess ---
      
      lResults <- QueryRate_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = QRY", "lLabels = Query Rate", "lLabels = Total Queries", "lLabels = Total Data Points", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Country",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF cou0009
      #--- cou0009:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0009:FilterDomain ---
      
      dfQUERY <- FilterDomain(
        df = dfQUERY,
        strDomain = "dfQUERY",
        lMapping = lMapping,
        strColParam = lMapping[["dfQUERY"]][["strStatusCol"]],
        strValParam = lMapping[["dfQUERY"]][["strStatusVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0009:QueryAge_Map_Raw ---
      
      dfInput <- QueryAge_Map_Raw(
        dfs = list(dfSUBJ = lData[["dfSUBJ"]], dfQUERY = dfQUERY),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- cou0009:QueryAge_Assess ---
      
      lResults <- QueryAge_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = OQRY", "lLabels = Outstanding Query Rate", "lLabels = Queries Open > 30 Days", "lLabels = Total Queries", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Country",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF cou0010
      #--- cou0010:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0010:DataEntry_Map_Raw ---
      
      dfInput <- DataEntry_Map_Raw(
        dfs = list(dfSUBJ = dfSUBJ, dfDATAENT = lData[["dfDATAENT"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- cou0010:DataEntry_Assess ---
      
      lResults <- DataEntry_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = ODAT", "lLabels = Outstanding Data Entry Rate", "lLabels = Outstanding Data Pages", "lLabels = Total Data Pages", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Country",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF cou0011
      #--- cou0011:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- cou0011:DataChg_Map_Raw ---
      
      dfInput <- DataChg_Map_Raw(
        dfs = list(dfSUBJ = dfSUBJ, dfDATACHG = lData[["dfDATACHG"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- cou0011:DataChg_Assess ---
      
      lResults <- DataChg_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = CDAT", "lLabels = Data Change Rate", "lLabels = Data Points with 1+ Change", "lLabels = Total Data Points", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Country",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF cou0012
      #--- cou0012:Screening_Map_Raw ---
      
      dfInput <- Screening_Map_Raw(
        dfs = lData[["dfENROLL"]],
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- cou0012:Screening_Assess ---
      
      lResults <- Screening_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = SF", "lLabels = Screen Failure Rate", "lLabels = Screen Failures", "lLabels = Screened Subjects", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Country",
        nMinDenominator = 3,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF kri0001
      #--- kri0001:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0001:AE_Map_Raw ---
      
      dfInput <- AE_Map_Raw(
        dfs = list(dfAE = lData[["dfAE"]], dfSUBJ = dfSUBJ),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- kri0001:AE_Assess ---
      
      lResults <- AE_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = AE", "lLabels = Adverse Event Rate", "lLabels = Adverse Events", "lLabels = Days on Study", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Site",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF kri0002
      #--- kri0002:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0002:FilterDomain ---
      
      dfAE <- FilterDomain(
        df = dfAE,
        strDomain = "dfAE",
        lMapping = lMapping,
        strColParam = lMapping[["dfAE"]][["strSeriousCol"]],
        strValParam = lMapping[["dfAE"]][["strSeriousVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0002:AE_Map_Raw ---
      
      dfInput <- AE_Map_Raw(
        dfs = list(dfAE = dfAE, dfSUBJ = lData[["dfSUBJ"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- kri0002:AE_Assess ---
      
      lResults <- AE_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = AE", "lLabels = Adverse Event Rate", "lLabels = Adverse Events", "lLabels = Days on Study", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Site",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF kri0003
      #--- kri0003:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0003:FilterDomain ---
      
      dfPD <- FilterDomain(
        df = dfPD,
        strDomain = "dfPD",
        lMapping = lMapping,
        strColParam = lMapping[["dfPD"]][["strImportantCol"]],
        strValParam = lMapping[["dfPD"]][["strNonImportantVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0003:PD_Map_Raw_Rate ---
      
      dfInput <- PD_Map_Raw_Rate(
        dfs = list(dfPD = dfPD, dfSUBJ = lData[["dfSUBJ"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- kri0003:PD_Assess_Rate ---
      
      lResults <- PD_Assess_Rate(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = PD", "lLabels = Protocol Deviation Rate", "lLabels = Protocol Deviations", "lLabels = Days on Study", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Site",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF kri0004
      #--- kri0004:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0004:FilterDomain ---
      
      dfPD <- FilterDomain(
        df = dfPD,
        strDomain = "dfPD",
        lMapping = lMapping,
        strColParam = lMapping[["dfPD"]][["strImportantCol"]],
        strValParam = lMapping[["dfPD"]][["strImportantVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0004:PD_Map_Raw_Rate ---
      
      dfInput <- PD_Map_Raw_Rate(
        dfs = list(dfSUBJ = lData[["dfSUBJ"]], dfPD = dfPD),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- kri0004:PD_Assess_Rate ---
      
      lResults <- PD_Assess_Rate(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = PD", "lLabels = Protocol Deviation Rate", "lLabels = Protocol Deviations", "lLabels = Days on Study", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Site",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF kri0005
      #--- kri0005:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0005:FilterDomain ---
      
      dfLB <- FilterDomain(
        df = dfLB,
        strDomain = "dfLB",
        lMapping = lMapping,
        strColParam = lMapping[["dfLB"]][["strGradeCol"]],
        strValParam = lMapping[["dfLB"]][["strGradeAnyVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0005:LB_Map_Raw ---
      
      dfInput <- LB_Map_Raw(
        dfs = list(dfSUBJ = lData[["dfSUBJ"]], dfLB = dfLB),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- kri0005:LB_Assess ---
      
      lResults <- LB_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = LB", "lLabels = Lab Abnormality Rate", "lLabels = Abnormal Lab Samples", "lLabels = Total Lab Samples", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Site",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF kri0006
      #--- kri0006:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0006:Disp_Map_Raw ---
      
      dfInput <- Disp_Map_Raw(
        dfs = list(dfSUBJ = dfSUBJ, dfSTUDCOMP = lData[["dfSTUDCOMP"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- kri0006:Disp_Assess ---
      
      lResults <- Disp_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = DSC", "lLabels = Discontinuation Rate", "lLabels = Subjects Discontinued", "lLabels = Total Subjects", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Site",
        nMinDenominator = 3,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF kri0007
      #--- kri0007:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0007:FilterDomain ---
      
      dfSDRGCOMP <- FilterDomain(
        df = dfSDRGCOMP,
        strDomain = "dfSDRGCOMP",
        lMapping = lMapping,
        strColParam = lMapping[["dfSDRGCOMP"]][["strTreatmentPhaseCol"]],
        strValParam = lMapping[["dfSDRGCOMP"]][["strTreatmentPhaseVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0007:Disp_Map_Raw ---
      
      dfInput <- Disp_Map_Raw(
        dfs = list(dfSUBJ = lData[["dfSUBJ"]], dfSDRGCOMP = dfSDRGCOMP),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- kri0007:Disp_Assess ---
      
      lResults <- Disp_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = DSC", "lLabels = Discontinuation Rate", "lLabels = Subjects Discontinued", "lLabels = Total Subjects", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Site",
        nMinDenominator = 3,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF kri0008
      #--- kri0008:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0008:FilterDomain ---
      
      dfQUERY <- FilterDomain(
        df = dfQUERY,
        strDomain = "dfQUERY",
        lMapping = lMapping,
        strColParam = lMapping[["dfQUERY"]][["strStatusCol"]],
        strValParam = lMapping[["dfQUERY"]][["strStatusVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0008:QueryRate_Map_Raw ---
      
      dfInput <- QueryRate_Map_Raw(
        dfs = list(dfSUBJ = lData[["dfSUBJ"]], dfQUERY = dfQUERY, dfDATACHG = lData[["dfDATACHG"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- kri0008:QueryRate_Assess ---
      
      lResults <- QueryRate_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = QRY", "lLabels = Query Rate", "lLabels = Total Queries", "lLabels = Total Data Points", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Site",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF kri0009
      #--- kri0009:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0009:FilterDomain ---
      
      dfQUERY <- FilterDomain(
        df = dfQUERY,
        strDomain = "dfQUERY",
        lMapping = lMapping,
        strColParam = lMapping[["dfQUERY"]][["strStatusCol"]],
        strValParam = lMapping[["dfQUERY"]][["strStatusVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0009:QueryAge_Map_Raw ---
      
      dfInput <- QueryAge_Map_Raw(
        dfs = list(dfSUBJ = lData[["dfSUBJ"]], dfQUERY = dfQUERY),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- kri0009:QueryAge_Assess ---
      
      lResults <- QueryAge_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = OQRY", "lLabels = Outstanding Query Rate", "lLabels = Queries Open > 30 Days", "lLabels = Total Queries", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Site",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF kri0010
      #--- kri0010:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0010:DataEntry_Map_Raw ---
      
      dfInput <- DataEntry_Map_Raw(
        dfs = list(dfSUBJ = dfSUBJ, dfDATAENT = lData[["dfDATAENT"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- kri0010:DataEntry_Assess ---
      
      lResults <- DataEntry_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = ODAT", "lLabels = Outstanding Data Entry Rate", "lLabels = Outstanding Data Pages", "lLabels = Total Data Pages", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Site",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF kri0011
      #--- kri0011:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- kri0011:DataChg_Map_Raw ---
      
      dfInput <- DataChg_Map_Raw(
        dfs = list(dfSUBJ = dfSUBJ, dfDATACHG = lData[["dfDATACHG"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- kri0011:DataChg_Assess ---
      
      lResults <- DataChg_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = CDAT", "lLabels = Data Change Rate", "lLabels = Data Points with 1+ Change", "lLabels = Total Data Points", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Site",
        nMinDenominator = 30,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF kri0012
      #--- kri0012:Screening_Map_Raw ---
      
      dfInput <- Screening_Map_Raw(
        dfs = lData[["dfENROLL"]],
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- kri0012:Screening_Assess ---
      
      lResults <- Screening_Assess(
        dfInput = dfInput,
        strMethod = "NormalApprox",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = SF", "lLabels = Screen Failure Rate", "lLabels = Screen Failures", "lLabels = Screened Subjects", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Site",
        nMinDenominator = 3,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF qtl0004
      #--- qtl0004:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- qtl0004:FilterDomain ---
      
      dfPD <- FilterDomain(
        df = dfPD,
        strDomain = "dfPD",
        lMapping = lMapping,
        strColParam = lMapping[["dfPD"]][["strImportantCol"]],
        strValParam = lMapping[["dfPD"]][["strImportantVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- qtl0004:PD_Map_Raw_Binary ---
      
      dfInput <- PD_Map_Raw_Binary(
        dfs = list(dfPD = dfPD, dfSUBJ = lData[["dfSUBJ"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- qtl0004:PD_Assess_Binary ---
      
      lResults <- PD_Assess_Binary(
        dfInput = dfInput,
        strMethod = "QTL",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = PD", "lLabels = Protocol Deviation Rate", "lLabels = Protocol Deviations", "lLabels = Days on Study", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Study",
        nConfLevel = 0.95,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )
      
      # START OF qtl0006
      #--- qtl0006:FilterDomain ---
      
      dfSUBJ <- FilterDomain(
        df = lData[["dfSUBJ"]],
        strDomain = "dfSUBJ",
        lMapping = lMapping,
        strColParam = lMapping[["dfSUBJ"]][["strEnrollCol"]],
        strValParam = lMapping[["dfSUBJ"]][["strEnrollVal"]],
        bReturnChecks = FALSE,
        bQuiet = TRUE,
        bRemoveVal = FALSE
      )
      
      #--- qtl0006:Disp_Map_Raw ---
      
      dfInput <- Disp_Map_Raw(
        dfs = list(dfSUBJ = dfSUBJ, dfSTUDCOMP = lData[["dfSTUDCOMP"]]),
        lMapping = lMapping,
        bReturnChecks = FALSE,
        bQuiet = TRUE
      )
      
      #--- qtl0006:Disp_Assess ---
      
      lResults <- Disp_Assess(
        dfInput = dfInput,
        strMethod = "QTL",
        c("lLabels = list", "lLabels = ", "lLabels = strGroup", "lLabels = DSC", "lLabels = Discontinuation Rate", "lLabels = Subjects Discontinued", "lLabels = Total Subjects", "lLabels = Normal Approximation", "lLabels = Adjusted Z-Score"),
        strGroup = "Study",
        nConfLevel = 0.95,
        bMakeCharts = FALSE,
        bQuiet = TRUE
      )

