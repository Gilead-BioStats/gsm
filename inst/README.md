# 📄 `inst` Summary


This README summarizes the contents found in the `gsm/inst` directory.

---

# 📁 `gismo-tables` 

#### Description

JSON files used to test data pipeline functionality, and used as a reference for expected outputs from certain `{gsm}` workflows.

#### Contents

```
├── country-dropdown-list.json
├── kri-details-sites.json
├── kri-graph-details.json
├── kri-headers-details.json
├── kri-list-details.json
├── kri-sites-dropdown.json
├── pretty-print.py
├── qtl-graph-details.json
├── qtl-headers-details.json
├── site-custom-columns.json
├── site-details-graph.json
├── site-details-kris.json
├── site-header-details.json
├── site-summary-details.json
├── site-summary-sparklines.json
├── snapshot-dates.json
├── study-details.json
└── study-headers-details.json
```

---

# 📁 `htmlwidgets`

#### Description

`.js` and `.yaml` files that are used to configure [`htmlwidgets`](https://www.htmlwidgets.org/) that use a custom JavaScript charting library.


#### Contents

```
├── Widget_BarChart.js
├── Widget_BarChart.yaml
├── Widget_ScatterPlot.js
├── Widget_ScatterPlot.yaml
├── Widget_TimeSeries.js
├── Widget_TimeSeries.yaml
├── Widget_TimeSeriesQTL.js
└── Widget_TimeSeriesQTL.yaml
```

---

# 📁 `mappings`

#### Description

`YAML` files containing key/value pairs for use in mapping data to an assessment's data standards. 

There are two types of mappings:
- Assessment-specific mappings (e.g., `AE_Assess.yaml`, `LB_Assess.yaml`)
- Data domain-specific mappings (e.g., `mapping_rawplus.yaml`, `mapping_ctms.yaml`).

#### Contents

**Assessment Mappings**:

```
├── AE_Assess.yaml
├── Consent_Assess.yaml
├── DataChg_Assess.yaml
├── DataEntry_Assess.yaml
├── Disp_Assess.yaml
├── IE_Assess.yaml
├── LB_Assess.yaml
├── PD_Assess_Binary.yaml
├── PD_Assess_Rate.yaml
├── QueryAge_Assess.yaml
├── QueryRate_Assess.yaml
├── Screening_Assess.yaml
```

**Data Mappings**:

```
├── mapping_adam.yaml
├── mapping_ctms.yaml
├── mapping_domain.yaml
├── mapping_edc.yaml
└── mapping_rawplus.yaml
```

---

# 📁 `qualification`

#### Description

R scripts and a specification file that are used as part of the automated qualification framework.

#### Contents

```
├── qualification_map.R
├── qualification_specs.csv
├── specs.R
└── test_cases.R
```

---

# 📁 `rbm-viz-*`

#### Description

Bundled/minified JavaScript charting library that is used as part of the `htmlwidget` configuration.

#### Contents

```
└── rbm-viz.js
```

---

# 📁 `report`

#### Description

R Markdown files that are used as templates underlying the [`gsm::Study_Report()`](https://gilead-biostats.github.io/gsm/reference/Study_Report.html) function. Also includes a `.css` file for HTML styling.

#### Contents

```
├── KRIReportByCountry.Rmd
├── KRIReportByQTL.Rmd
├── KRIReportBySite.Rmd
└── styles.css
```
---

# 📁 `report_examples`

#### Description

Reports that have been generated from [`gsm::Study_Report()`](https://gilead-biostats.github.io/gsm/reference/Study_Report.html) that are used to host sample reports on the [`{gsm}` webpage](https://gilead-biostats.github.io/gsm/). 

#### Contents

```
├── gsm_country_report.html
└── gsm_site_report.html
```

---

# 📁 `specs`

#### Description

YAML files that contain criteria for domain-specific columns that are required (`vRequired`), allowed to contain `NA` values (`vNACols`), and are expected to be unique (`vUniqueCols`). 

#### Contents

```
├── AE_Assess.yaml
├── AE_Map_Adam.yaml
├── AE_Map_Raw.yaml
├── Consent_Assess.yaml
├── Consent_Map_Raw.yaml
├── DataChg_Assess.yaml
├── DataChg_Map_Raw.yaml
├── DataEntry_Assess.yaml
├── DataEntry_Map_Raw.yaml
├── Disp_Assess.yaml
├── Disp_Map_Raw_Study.yaml
├── Disp_Map_Raw_Treatment.yaml
├── IE_Assess.yaml
├── IE_Map_Raw.yaml
├── LB_Assess.yaml
├── LB_Map_Raw.yaml
├── PD_Assess_Binary.yaml
├── PD_Assess_Rate.yaml
├── PD_Map_Raw_Binary.yaml
├── PD_Map_Raw_Rate.yaml
├── QueryAge_Assess.yaml
├── QueryAge_Map_Raw.yaml
├── QueryRate_Assess.yaml
├── QueryRate_Map_Raw.yaml
├── Screening_Assess.yaml
└── Screening_Map_Raw.yaml
```

---

# 📁 `utils-0.0.1`

#### Description

JavaScript utility functions used to configure `htmlwidgets` and for custom reporting functions.

#### Contents

```
├── addSiteSelect.js
├── clickCallback.js
├── dragOverallSiteDropdown.js
├── number_to_array.js
├── overallSiteDropdown.js
└── showMetaTableDetails.js
```
---

# 📄 Wordlist

#### Description

Text file that contains words that are omitted from `devtools::spell_check()`.

---

# 📁 `workflow`

#### Description

YAML files that are used to configure assessment workflows, passed into `gsm::Study_Assess()` or `gsm::Make_Snapshot()`.

#### Contents

```
├── cou0001.yaml
├── cou0002.yaml
├── cou0003.yaml
├── cou0004.yaml
├── cou0005.yaml
├── cou0006.yaml
├── cou0007.yaml
├── cou0008.yaml
├── cou0009.yaml
├── cou0010.yaml
├── cou0011.yaml
├── cou0012.yaml
├── experimental
│   ├── aeGrade.yaml
│   ├── aeQTL.yaml
│   ├── consent.yaml
│   ├── dispStudyWithdrew.yaml
│   ├── dispTreatmentByPhase.yaml
│   ├── ie.yaml
│   ├── lbCategory.yaml
│   ├── pdCategory.yaml
│   └── sae.yaml
├── kri0001.yaml
├── kri0002.yaml
├── kri0003.yaml
├── kri0004.yaml
├── kri0005.yaml
├── kri0006.yaml
├── kri0007.yaml
├── kri0008.yaml
├── kri0009.yaml
├── kri0010.yaml
├── kri0011.yaml
├── kri0012.yaml
├── qtl0004.yaml
└── qtl0006.yaml
```

