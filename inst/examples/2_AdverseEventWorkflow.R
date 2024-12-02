#### Example 2.1 - Configurable Adverse Event Workflow

# Define YAML workflow
AE_workflow <- read_yaml(text=
'meta:
  Type: Analysis
  ID: kri0001
  GroupLevel: Site
  Abbreviation: AE
  Metric: Adverse Event Rate
  Numerator: Adverse Events
  Denominator: Days on Study
  Model: Normal Approximation
  Score: Adjusted Z-Score
  AnalysisType: rate
  Threshold: -2,-1,2,3
  nMinDenominator: 30
spec:
  Mapped_AE:
    subjid:
      type: character
  Mapped_SUBJ:
    subjid:
      type: character
    invid:
      type: character
    timeonstudy:
      type: integer
steps:
  - output: vThreshold
    name: ParseThreshold
    params:
      strThreshold: Threshold
  - output: Analysis_Input
    name: Input_Rate
    params:
      dfSubjects: Mapped_SUBJ
      dfNumerator: Mapped_AE
      dfDenominator: Mapped_SUBJ
      strSubjectCol: subjid
      strGroupCol: invid
      strGroupLevel: GroupLevel
      strNumeratorMethod: Count
      strDenominatorMethod: Sum
      strDenominatorCol: timeonstudy
  - output: Analysis_Transformed
    name: Transform_Rate
    params:
      dfInput: Analysis_Input
  - output: Analysis_Analyzed
    name: Analyze_NormalApprox
    params:
      dfTransformed: Analysis_Transformed
      strType: AnalysisType
  - output: Analysis_Flagged
    name: Flag_NormalApprox
    params:
      dfAnalyzed: Analysis_Analyzed
      vThreshold: vThreshold
  - output: Analysis_Summary
    name: Summarize
    params:
      dfFlagged: Analysis_Flagged
      nMinDenominator: nMinDenominator
  - output: lAnalysis
    name: list
    params:
      ID: ID
      Analysis_Input: Analysis_Input
      Analysis_Transformed: Analysis_Transformed
      Analysis_Analyzed: Analysis_Analyzed
      Analysis_Flagged: Analysis_Flagged
      Analysis_Summary: Analysis_Summary
')

# Run the workflow
AE_data <-list(
  Mapped_SUBJ= clindata::rawplus_dm,
  Mapped_AE= clindata::rawplus_ae
)
AE_KRI <- RunWorkflow(lWorkflow = AE_workflow, lData = AE_data)

# Create Barchart from workflow
Widget_BarChart(dfResults = AE_KRI$Analysis_Summary)

#### Example 2.2 - Run Country-Level Metric
AE_country_workflow <- AE_workflow
AE_country_workflow$meta$GroupLevel <- "Country"
AE_country_workflow$steps[[2]]$params$strGroupCol <- "country"

AE_country_KRI <- RunWorkflow(lWorkflow = AE_country_workflow, lData = AE_data)
Widget_BarChart(dfResults = AE_country_KRI$Analysis_Summary, lMetric = AE_country_workflow$meta)

#### Example 2.3 - Create SAE workflow

# Tweak AE workflow metadata
SAE_workflow <- AE_workflow
SAE_workflow$meta$File <- "SAE_KRI"
SAE_workflow$meta$Metric <- "Serious Adverse Event Rate"
SAE_workflow$meta$Numerator <- "Serious Adverse Events"

# Add a step to filter out non-serious AEs `RunQuery`
filterStep <- list(list(
  name = "RunQuery",
  output = "Mapped_AE",
  params= list(
    df= "Mapped_AE",
    strQuery = "SELECT * FROM df WHERE aeser = 'Y'"
  ))
)
SAE_workflow$steps <- SAE_workflow$steps %>% append(filterStep, after=0)

# Run the updated workflow
SAE_KRI <- RunWorkflow(lWorkflow = SAE_workflow, lData = AE_data )
Widget_BarChart(dfResults = SAE_KRI$Analysis_Summary, lMetric = SAE_workflow$meta)



