# AA-AA-000-0000

This project includes all RBQM-related analytics files for the study AA-AA-000-0000. A list of the
files included in this project is provided below.

## Files

- `README.md`: This file.
- `config/`: Study-specific database-, metric-, and module--level configuration files.
- `data/`: Local data file store
  - `data/yyyy-mm-dd/`: Data snapshots
    - `data/yyyy-mm-dd/Mapped/`: Mapped data layer
    - `data/yyyy-mm-dd/Analysis/{MetricID}/`: Analysis data layer
    - `data/yyyy-mm-dd/Reporting/`: Reporting data layer
- `modules/`: Local module output file store
  - `modules/yyyy-mm-dd/`: Module output files
- `workflows/`:
  - `workflows/1_mapped/`: Workflows for each mapped data domain
  - `workflows/2_analysis/`: Workflows for each metric
  - `workflows/3_reporting/`: Workflows for each reportin data domain
  - `workflows/4_modules/`: Workflows for each module, including reports
