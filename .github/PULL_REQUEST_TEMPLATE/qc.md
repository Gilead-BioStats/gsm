---
name: "Assessment QC Pull Request Template"
about: "Conduct a full QC of an Assessment"
title: "QC: (fill in)"
---
## QC Checklist
<!--- Fill out the following QC checklist as you complete the QC items -->
- [ ] Documentation
    - [ ] Function name captured in [Roxygen title](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html#the-description-block)(e.g. "Adverse Event Assessment")
    - [ ] Assessment Purpose captured in [Roxygen description](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html#the-description-block) (e.g. "Evaluates site-level level Adverse Event Rates and flags rates that are abnormally high or low."
    - [ ] Input Data Requirements are described in the the [Roxygen details](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html#the-description-block) under a Data section (`#' @details # Data Requirements`).
    - [ ] Parameters have detailed documentation using `@param`. Each parameter should include: parameter name, brief description, usage details, the default value (if any), is it required, list of valid options (if applicable)
    - [ ] All external dependencies are captured. Use `@importFrom` when importing 3 or fewer functions, and use `@import` otherwise. 
    - [ ] Output Data Standards are described under `@returns`
    - [ ] At least 1 example is provided under `@examples`
- [ ] Error Checking
    - [ ]  Basic checks for all all parameters should be included using `stopifnot()` or similar logic. (e.g. `stopifnot("dfInput is not a dataframe"=is.data.frame(dfInput))`)
    - [ ] Basic tests should be included confirming that `stopifnot()` parameter checks are working as expected. 
    - [ ] Basic tests should be included that confirm that the input data has required columns (if any)
    - [ ] Basic tests should be included that confirm that the output data has the expected columns
- [ ] Basic QC
    - [ ] Code is well commented and easy to read
    - [ ] No file paths or other company-specific data is present. 
    - [ ] Function calls from non-tidyverse dependencies are called via `::`
    - [ ] devtools::check() passes with no errors/warnings/notes
    - [ ] package docs up to date. devtools::document() doesn't change any files
    - [ ] Uses tidyverse best practices for standard data manipulation (start discussion thread if unclear)
    - [ ] All new dependencies add significant value (start discussion thread)
    - [ ] All GitHub Actions run with no errors
- [ ] Process
    - [ ] PR with approved code review ready to merge to dev
    - [ ] All relevant issues linked to PR
- [ ] Unit tests
    - Confirm that informative errors are thrown when data standard is not met. 
    - Confirm that output specifications are met using standard test data. 
    - Confirm that tests confirm that missing data is handled appropriately.
- [ ] Qualification tests
    - Confirm that specifications and test cases have been created for new or updated assessments. 
    - Confirm that test code has been created for new or updated assessments. 
    - Confirm that qualification tests are all passing.
