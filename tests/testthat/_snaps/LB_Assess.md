# incorrect inputs throw errors

    strMethod is not 'fisher' or 'identity'

---

    strMethod is not 'fisher' or 'identity'

---

    strMethod must be length 1

---

    vThreshold is not numeric

---

    vThreshold must be length of 2

# bQuiet works as intended

    Code
      assessment <- assess_function(dfInput, bQuiet = FALSE)
    Message <cliMessage>
      
      -- Checking Input Data for `LB_Assess()` --
      
      v No issues found for `LB_Assess()`
      
      -- Initializing `LB_Assess()` --
      
      Input data has 150 rows.
      v `Transform_Rate()` returned output with 3 rows.
      v `Analyze_Fisher()` returned output with 3 rows.
      v `Flag()` returned output with 3 rows.
      v `Summarize()` returned output with 3 rows.
      v `Visualize_Scatter()` created 1 chart.
      v `Visualize_Score()` created 2 charts.

