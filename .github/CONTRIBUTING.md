# Contributing to `{gsm}`

This page outlines the development process for `{gsm}`, and how to contribute by filing issues, bug reports, and submitting code via a pull request.  

## Prerequisites

Before contributing code via a pull request, make sure to file an [issue](https://github.com/Gilead-BioStats/gsm/issues/new/choose), and choose the template that best suits your situation. This is generally one of:

- Bugfix
- Feature Issue
- QC Issue

Someone from the team will decide if this is an issue that is in scope and will triage the issue appropriately, either by giving the go-ahead to submit a pull request, assigning the issue to a core developer, or closing the issue if it is out of scope or not otherwise relevant. 

The issue templates provide comments to assist in gathering any relevant information that can be provided. In the case of bug reports or specific feature requests, it is often helpful to provide a minimal [reprex](https://www.tidyverse.org/help/#reprex) to illustrate the issue or request.

Additionally, suggestions or other input that might not necessarily fit into an issue template can be filed under [discussions](https://github.com/Gilead-BioStats/gsm/discussions), which can help to talk through specific use-cases or requests.

## Overview

The core branches that are used in this repository are:

- `main`: Contains the production version of the package.
- `dev`: Contains the development version of the package.
- `fix`: Used to develop new functionality in the package. See the [Development Process](#development-process) section below for more details. 
- `release`: Used to conduct regression testing and finalize QC documentation for a release. See the [Release Process Section](#release-process) for more details.

## Development Process

Once an issue is filed, all package development takes place by addressing issues in `fix` branches. Each `fix` branch should be linked to one or more GitHub [issue](https://github.com/Gilead-BioStats/gsm/issues), which should be referenced in the branch name. 

For example, `fix-111` addresses issue #111. Tasks related to documentation, testing, and/or qualification may also use `fix` branches and associated issues. 

## Pull Request Process

- As noted above, we recommend creating a Git branch that references one or more issues.
- New code should generally follow the [tidyverse style guide](https://style.tidyverse.org/) (where applicable).
- Documentation should be included, using [roxygen2](https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html).
- New functions, or changes to existing functions, should include updated unit tests. We use [testthat >= v3.0.0](https://testthat.r-lib.org/).
- When submitting a pull request, make sure to include any relevant details that will help the reviewer to understand the proposed updates or new functionality. Additionally, link the PR to the relevant issue by using [closing keywords](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword), or manually link to the issue by using the `Development` section on the sidebar.
- In general, all pull requests should target the `dev` branch (with the exception of a release PR).

## `fix` Branch Workflow

1. Create issue(s) defining addition(s):
    - Select the appropriate template to use, one of: `Bugfix`, `Feature Issue`, or `QC Issue`
    - Assign issue to developer(s)
    - Assign Milestone
2. Developer codes `fix` branch with updates to code.
3. Developer creates PR into `dev` using the default PR template and does the following:
    - Assign PR to self
    - Requests review(s)
    - Assign milestone
    - Link to associated issue(s)
4. Before merge, the PR must have the following: 
    - PR Approved by code reviewers
    - GitHub checks all passing
5. Branch is merged to `dev`.

# Release Process

A release is initiated when all feature development, QC, and qualification is done for a set of functionality. The primary objective of the Release Workflow is to conduct regression testing and finalize all QC documentation for a release. More details are provided in the workflow below.

## `release` Branch Workflow

1. Release Owner creates branch from `dev` to create a new `release` branch. 
   - The branch should be named after the version being released (e.g. `release-v1.2.0`) using [semantic versioning](https://semver.org/).
2. Release Owner updates the version in new branch in the `DESCRIPTION` file and pushes commit. The branch should be named after the version being released (e.g. `release-v1.2.0`)
3. Release Owner creates PR from `release` to `main` 
    - Use the [release PR template](https://github.com/Gilead-BioStats/gsm/blob/dev/.github/PULL_REQUEST_TEMPLATE/release.md) by adding `?template=release.md` to the URL when creating the PR (Or, click the link, click `raw`, and copy/paste the markdown into the PR.)
   - Assign PR to self
   - Requests QC review(s)
   - Assign milestone
   - Complete Risk Assessments for each Assessment/Feature added using PR Template
   - Create Comments in the PR with a unique QC checklist for each selected Assessment/Feature. ([Example for v0.1.0](https://github.com/Gilead-BioStats/gsm/pull/194))
4. QC Reviewer(s) conducts review
   - Complete all QC checklists in PR
   - Complete all items in Release Checklist
5. QC Reviewer(s) Mark PR approved or requests changes. If changes are needed, 
   - Reviewer should file issues and team should follow standard dev process using `fix` branches. 
   - Once issues are resolved and merged to `dev`, Release Owner can merge `dev` in to the `release` branch and re-request review. 
   - If needed, PR can be closed, and a new release PR can be created with a release candidate added to the branch name (e.g. `release-v1.2.0-RC2`) 
6. Once PR is approved, Release Owner merges the PR and creates the GitHub release. 

# GitHub Action Workflow

GitHub actions are used in `{gsm}` to automate processes and ensure all code and documentation is created consistently and documented thoroughly.

## Merges to `dev` branch
1. R CMD check - Basic R CMD check run using `rcmdcheck::rcmdcheck()`.  Additional check for the ability to build the pkgdown reference index to make sure all functions are documented correctly.  This check will run on `ubuntu-latest` and will be run on R versions 4.0.5 and 4.1.3
2. Build Markdown - Builds Assessment specification tables from function documentation.  Outputs are added to man/md and any changes are committed to the compare branch or the triggering Pull Request.
3. Test Coverage - Uses `{covr}` to check the package coverage of `{gsm}` 

## Merges to `main` branch
1. R CMD check - Basic R CMD check run using `rcmdcheck::rcmdcheck()`.  Additional check for the ability to build the pkgdown reference index to make sure all functions are documented correctly.  This check will run on `ubuntu-latest` and will be run on R versions 4.0.5 and 4.1.3.  Additionally, it will be run on the latest R release version on `windows-latest`, `macOS-latest`, and `ubuntu-latest`.
2. pkgdown - Builds the [pkgdown site](https://silver-potato-cfe8c2fb.pages.github.io/) for `{gsm}`.  
3. Qualification report - Builds the qualification vignette as an attached artifact to the Pull Request.  This should be reviewed by the Pull Request owner for completeness and correctness to ensure the artifact that is added to the release is correct.

