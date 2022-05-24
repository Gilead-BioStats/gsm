<!-- badges: start -->

[![R-CMD-check](https://github.com/Gilead-BioStats/gsm/workflows/R-CMD-check-main/badge.svg)](https://github.com/Gilead-BioStats/gsm/actions) [![Codecov test coverage](https://codecov.io/gh/Gilead-BioStats/gsm/branch/dev/graph/badge.svg)](https://codecov.io/gh/Gilead-BioStats/gsm?branch=dev)

<!-- badges: end -->

# Gilead Statistical Monitoring {gsm} R package

{gsm} is a centralized statistical monitoring tool used to proactively measure KRIs in a clinical study to help protect patients, ensure quality data and process, and achieve study objectives.

The {gsm} package will perform statistical assessments primarily focused on detecting differences in quality at the site-level. "High quality" is defined as absence of errors that matter. We interpret this as focusing on detecting potential issues related to critical data or process across the major risk categories of safety, efficacy, disposition, treatment, and general quality, where each category consists of one or more risk assessment(s). Each risk assessment will analyze the data to flag potential issues and provide a visualization to help the user understand the issue. Further expansion of the package will include exploratory plots and data outputs to allow the user to deep dive into the subject-level data for a flagged site of interest.

Below are some reading references to help better understand the purpose of the GSM package:

**Papers on Centralized Statistical Monitoring:** [1](https://documents.pub/reader/full/centralized-statistical-monitoring-to-detect-data-integrity-issues-statisticalcentralized), [2](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7308734/), [3](https://www.magiworld.org/Journal/2014/1411_Centralized.pdf)

**EMA/FDA Guidance on Risk Based Management:** [1](https://www.fda.gov/media/121479/download), [2](https://www.fda.gov/media/116754/download), [3](https://www.fda.gov/media/129527/download), [4](https://www.ema.europa.eu/en/documents/scientific-guideline/reflection-paper-risk-based-quality-management-clinical-trials_en.pdf)

**Risk Based Quality Management:** [1](https://www.acrohealth.org/wp-content/uploads/2019/10/CRO-Forum-RBQM-Oversight-Paper-FINAL-Oct-2019.pdf), [2](http://www.transceleratebiopharmainc.com/wp-content/uploads/2017/09/Risk-Based-Quality-Managment.pdf), [3](https://www.magiworld.org/Journal/2014/1411_Centralized.pdf)

**Industry Examples:** [1](https://cluepoints.com/), [2](https://www.saama.com/case-study/rbm-success-story/)

### Overview

The Gilead Statistical Monitoring or {gsm} R package provides a framework for statistical data monitoring using R. The package provides a framework that allows users to **assess** and **visualize** clinical trial data, allowing users to detect issues at sites, identify the root cause, and decide on the appropriate action.

The package currently provides assessments for the following domains:

1.  Adverse Event Frequency
2.  Serious Adverse Event Frequency
3.  Protocol Deviation Frequency
4.  Important Protocol Deviation Frequency

### Data Pipeline

{gsm}'s data pipeline has 2 main components:

1.  **Assess** data to detect potential issues at sites.
2.  **Visualize** the findings for understanding.

To learn more about {gsm}'s data pipeline, visit the [Data Pipeline Vignette](https://github.com/Gilead-BioStats/gsm/wiki/Data-Pipeline-Vignette)

### Assess

{gsm} uses a standardized 6 step process for **assessing** data issues. The steps are listed below along with their inputs and outputs.

1.  **Map** (*Optional*) - Converts `raw` data to `input` data.
2.  **Transform** - Converts `input` data to `transformed` data.
3.  **Analyze** - Converts `transformed` data to `analyzed` data.
4.  **Threshold** - Uses `analyzed` data to create one or more numeric `thresholds`.
5.  **Flag** - Uses `analyzed` data and numeric `thresholds` to create `flagged` data.
6.  **Summarize** - Selects key columns from `flagged` data to create `summary` data.

### Visualize

By default, {gsm} produces a visualization for each assessment.
