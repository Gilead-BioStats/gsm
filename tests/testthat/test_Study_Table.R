test_that("Study Table Runs as expected",{
    results<- Study_Assess(bQuiet=TRUE)
    dfSummaryAll <-results %>% map(~.x$result$dfSummary) %>% bind_rows
    tbl <- Study_Table(dfSummaryAll)
    expect_true(is.data.frame(tbl))
    expect_equal(names(tbl),
                 c("Title", "X055X", "X086X", "X050X", "X140X", "X180X", "X054X",
                   "X154X", "X009X", "X164X", "X102X", "X090X", "X126X", "X192X",
                   "X013X", "X168X", "X236X", "X068X", "X033X", "X081X", "X129X",
                   "X018X", "X235X", "X037X", "X159X", "X173X", "X204X", "X038X",
                   "X100X", "X094X", "X097X", "X143X", "X166X", "X174X", "X183X",
                   "X185X", "X224X", "X110X", "X117X", "X179X", "X120X", "X132X",
                   "X145X"))
    expect_equal(tbl$Title,
                 c("Number of Subjects", "Score", "Safety", "--AEs", "--SAEs",
                   "Consent", "--Consent", "Inclusion/Exclusion", "--Inclusion/Exclusion",
                   "Protocol Deviations", "--Important PD", "--Any PD"))
})
