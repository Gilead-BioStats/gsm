# Contributing to `{gsm}`

This page outlines the development process for `{gsm}`, and how to contribute by filing issues, bug reports, and submitting code via a Pull Request.  

## Prerequisites

Before contributing code via a Pull Request, make sure to file an [issue](https://github.com/Gilead-BioStats/gsm/issues/new/choose), and choose the template that best suits your situation. This is generally one of:

- Bugfix
- Feature Issue
- QC Issue

Someone from the team will decide if this is an issue that is in scope and will triage the issue appropriately, either by giving the go-ahead to submit a Pull Request, assigning the issue to a core developer, or closing the issue if it is out of scope or not otherwise relevant. 

The issue templates provide comments to assist in gathering any relevant information that can be provided. In the case of bug reports or specific feature requests, it is often helpful to provide a minimal [reprex](https://www.tidyverse.org/help/#reprex) to illustrate the issue or request.

Additionally, suggestions or other input that might not necessarily fit into an issue template can be filed under [discussions](https://github.com/Gilead-BioStats/gsm/discussions), which can help to talk through specific use-cases or requests.

## Branches

The core branches that are used in this repository are:

- `main`: Contains the production version of the package.
- `dev`: Contains the development version of the package.
- `fix`: Used to develop new functionality in the package. See the [Development Process](#development-process) section below for more details. 
- `release`: Used to conduct regression testing and finalize QC documentation for a release. See the [Release Process Section](#release-process) for more details.

# Development Process

All code development takes place in `fix` branches. This section describes the process and provides general guidance and a detailed [step-by-step workflow](#fix-branch-workflow) is available below. 

Once an issue is filed, all package development takes place by addressing issues in `fix` branches. Each `fix` branch should be linked to one or more GitHub [issue](https://github.com/Gilead-BioStats/gsm/issues), which should be referenced in the branch name. For example, `fix-111` addresses issue #111. Tasks related to documentation, testing, and/or qualification may also use `fix` branches and associated issues. A detailed workflow for `fix` branches is provided below. 

Please also use the following general guidance when creating a Pull Request:

- As noted above, we recommend creating a Git branch that references one or more issues.
- New code should generally follow the [tidyverse style guide](https://style.tidyverse.org/), but automatic styling is applied before each release [here](#style-guide) for details.
- Documentation should be included, using [roxygen2](https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html).
- New functions, or changes to existing functions, should include updated unit tests. We use [testthat >= v3.0.0](https://testthat.r-lib.org/).
- When submitting a Pull Request, make sure to include any relevant details that will help the reviewer to understand the proposed updates or new functionality. Additionally, link the PR to the relevant issue by using [closing keywords](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword), or manually link to the issue by using the `Development` section on the sidebar.
- In general, all Pull Requests should target the `dev` branch (with the exception of a release PR).
- All checks and tests must be passing before merging a PR to dev. These checks are automatically run via [GitHub Actions](#github-action-workflow), but you can also run them locally by calling `devtools::check()` on your branch before finalizing a PR. 

# Release Process

Code release follows a process using `release` brances. A release is initiated when all feature development, QC, and qualification is done for a set of functionality. The primary objective of the Release Workflow is to conduct regression testing and finalize all QC documentation for a release. More details are provided in the detailed [step-by-step workflow](#release-branch-workflow) below.

# Style Guide

We use the [tidyverse style guide](https://style.tidyverse.org/) with minor modifactions. The code below is run to standardize styling before before each release.

```
double_indent_style <- styler::tidyverse_style()
double_indent_style$indention$unindent_fun_dec <- NULL
double_indent_style$indention$update_indention_ref_fun_dec <- NULL
double_indent_style$line_break$remove_line_breaks_in_fun_dec <- NULL
styler::style_dir('R', transformers = double_indent_style)
styler::style_dir('tests', recursive = TRUE, transformers = double_indent_style)
```

# Appendix 1 - Detailed Workflows 

## `fix` Branch Workflow

1. Create issue(s) defining addition(s):
    - Select the appropriate template to use, one of: `Bugfix`, `Feature Issue`, or `QC Issue`.
    - Assign issue to developer(s).
    - Assign Milestone.
2. Developer codes `fix` branch with updates to code.
3. Developer creates PR into `dev` using the default PR template and does the following:
    - Assign PR to self.
    - Requests review(s).
    - Assign milestone.
    - Link to associated issue(s).
4. Before merge, the PR must have the following: 
    - PR Approved by code reviewers.
    - GitHub checks all passing.
5. Branch is merged to `dev`.

## `release` Branch Workflow

1. Release Owner creates branch from `dev` to create a new `release` branch. 
   - The branch should be named after the version being released (e.g. `release-v1.2.0`) using [semantic versioning](https://semver.org/).
2. Release Owner prepares the release for QC by pushing the following updates to the release branch: 
    - Confirm that the version in the `DESCRIPTION` file is up to date.  
    - Run `styler` using [this script](#style-guide) and commit any updates. 
    - update `NEWS.md` with a summary of the updates in the release.
    - If applicable, review `README.md` and relevant vignettes to make sure updates are accurately described.
    - Ensure all unit tests are passing.
    - Ensure all qualification tests are passing and report has been rerun.
    - Run `devtools::spell_check()` and resolve issues.
    - Build site `pkgdown::build_site()` and check that all affected examples are displayed correctly and that all new functions occur on the "Reference" page.
3. Release Owner creates PR from `release` to `main`:
    - Use the [release PR template](https://github.com/Gilead-BioStats/gsm/blob/dev/.github/PULL_REQUEST_TEMPLATE/release.md) by adding `?template=release.md` to the URL when creating the PR (Or, click the link, click `raw`, and copy/paste the markdown into the PR.)
   - Assign PR to self.
   - Requests QC review(s).
   - Assign milestone.
   - Complete Risk Assessments for each Assessment/Feature added using PR Template.
   - Create comments in the PR with a unique [QC checklist](#appendix-2---qc-checklist) for each selected Assessment/Feature. ([Example for v0.1.0](https://github.com/Gilead-BioStats/gsm/pull/194)).
4. QC Reviewer(s) conducts review:
   - Complete all QC checklists in PR.
   - Ensure all GitHub Actions on the PR to `main` are all passing.
5. QC Reviewer(s) Mark PR approved or requests changes. If changes are needed: 
   - Reviewer should file issues and team should follow standard dev process using `fix` branches. 
   - Once issues are resolved and merged to `dev`, Release Owner can merge `dev` in to the `release` branch and re-request review. 
   - If needed, PR can be closed, and a new release PR can be created with a release candidate added to the branch name (e.g. `release-v1.2.0-RC2`) 
6. Once PR is approved, Release Owner should complete the release by: 
   - Merge the release PR to `main`.
   - Create the GitHub release using the wording from `NEWS.md` in addition to the automatically generated content in GitHub. 
   - Confirm that QC Report is attached to release.
7. Finally, Release Owner or their delegate should complete the following housekeeping tasks:
   - Create PR to merge `main` into `dev` to sync any updates made during Release process.
   - Check that all issues associated with the current release are closed. Update the milestone for any incomplete tasks.
   - Delete branches associated with previous releases.
   - Close the milestone and project associated with the previous release. 

# Appendix 2 - QC Checklist

This QC checklist is used as part of the development and release workflows described above. When applied to an Assessment, confirm that each function meets the requirements described. 

- [ ] Documentation
    - [ ] Function name captured in [Roxygen title](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html#the-description-block)(e.g. "Adverse Event Assessment")
    - [ ] Assessment Purpose captured in [Roxygen description](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html#the-description-block) (e.g. "Evaluates site-level level Adverse Event Rates and flags rates that are abnormally high or low."
    - [ ] Input Data Requirements are described in the the [Roxygen details](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html#the-description-block) under a Data section (`#' @details # Data Requirements`).
    - [ ] Statistical Assumptions - (Assess() and Analyze() only) List the statistical methods used and refer to detailed description in Analyze function in a the [Roxygen details](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html#the-description-block) under a Statistics section (`#' @details # Statistical Assumptions`).
    - [ ] Parameters have detailed documentation using `@param`. Each parameter should include: parameter name, brief description, usage details, the default value (if any), is it required, list of valid options (if applicable)
    - [ ] All external dependencies are captured. Use `@importFrom` when importing 3 or fewer functions, and use `@import` otherwise. 
    - [ ] Output Data Standards are described under `@returns`
    - [ ] At least 1 example is provided under `@examples`
- [ ] Error Checking
    - [ ]  Basic checks for all all parameters should be included using `stopifnot()` or similar logic. (e.g. `stopifnot("dfInput is not a dataframe"=is.data.frame(dfInput))`)
    - [ ] Tests confirm that `stopifnot()` parameter checks are working as expected. 
    - [ ] Tests confirm that the input data has required columns (if any)
    - [ ] Tests confirm that the output data has the expected columns
    - [ ] Tests confirm intended functionality for each parameter
    - [ ] Tests confirm that missing data in required columns is handled appropriately and errors/warnings are produced if needed. 
- [ ] Basic QC
    - [ ] Assessment has User Requirements + Qualification tests captured using {valtools} framework. Report is generating as expected and all checks are passing. 
    - [ ] Code is well commented and easy to read
    - [ ] No file paths or other company-specific data is present
    - [ ] Function calls from non-tidyverse dependencies are called via `::`
    - [ ] devtools::check() passes with no errors/warnings/notes
    - [ ] package docs up to date. devtools::document() doesn't change any files
    - [ ] Uses tidyverse best practices for standard data manipulation (start discussion thread if unclear)
    - [ ] All new dependencies add significant value (start discussion thread)
    - [ ] All GitHub Actions run with no errors


# Appendix 3 - Continusous Integration with GitHub Actions

GitHub Actions are used in `{gsm}` to automate processes and ensure all code and documentation is created consistently and documented thoroughly.

## Merges to `dev` branch

-  R CMD check - Basic R CMD check run using `rcmdcheck::rcmdcheck()`.  Additional check for the ability to build the pkgdown reference index to make sure all functions are documented correctly.  This check will run on `ubuntu-latest` and will be run on R versions 4.0.5 and 4.1.3
- Build Markdown - Builds Assessment specification tables from function documentation.  Outputs are added to man/md and any changes are committed to the compare branch or the triggering Pull Request.
- Test Coverage - Uses `{covr}` to check the package coverage of `{gsm}` 

## Merges to `main` branch

- R CMD check - Basic R CMD check run using `rcmdcheck::rcmdcheck()`.  Additional check for the ability to build the pkgdown reference index to make sure all functions are documented correctly.  This check will run on `ubuntu-latest` and will be run on R versions 4.0.5 and 4.1.3.  Additionally, it will be run on the latest R release version on `windows-latest`, `macOS-latest`, and `ubuntu-latest`.
- pkgdown - Builds the [pkgdown site](https://silver-potato-cfe8c2fb.pages.github.io/) for `{gsm}`.  
- Qualification report - Builds the qualification vignette as an attached artifact to the Pull Request.  This should be reviewed by the Pull Request owner for completeness and correctness to ensure the artifact that is added to the release is correct.
