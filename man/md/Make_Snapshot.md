# Return - Data Model Description

A named `list` of data.frames:

- `rpt_kri_bounds_details`, with columns: 

   - `studyid` - Unique Study ID
   - `snapshot_date` - Date that snapshot was created
   - `workflowid` - Unique KRI ID
   - `threshold` - KRI value
   - `numerator` - Threshold
   - `denominator` - Numerator used to calculate metric
   - `log_denominator` - Denominator used to calculate metric
   - `pt_cycle_id` - Log transformed denominator
   - `pt_data_dt` - Cycle ID
   - `gsm_analysis_date` - Data ID

- `rpt_kri_details`, with columns:

   - `studyid` - Name of study
   - `snapshot_date` - Date that snapshot was created
   - `workflowid` - Unique KRI
   - `metric` - Name of the KRI
   - `abbreviation` - KRI abbreviation
   - `kri_description` - KRI Description
   - `base_metric` - Numerator over denominator
   - `numerator` - Meta workflow numerator
   - `denominator` - Meta workflow denominator
   - `num_of_sites_at_risk` - Total number of grouped sites with amber flags
   - `num_of_sites_flagged` - Total number of grouped sites with red flags
   - `outcome` - The units output in the outcome of the KRI
   - `model` - The method of calculating the score for the KRI
   - `score` - The type of score used for the KRI
   - `data_inputs` - Data used as inputs
   - `data_filters` - Data filtering parameters
   - `gsm_version` - version of gsm used for analysis
   - `group` - group targeted by KRI
   - `total_num_of_sites` - Total number of sites in study
   - `pt_cycle_id` - Cycle ID
   - `pt_data_dt` - Data date
   - `active` - Logical value indicating if kri is currently active
   - `status` - Logical value indicating if kri was successfully run
   - `notes` - User input notes per kri
   - `gsm_analysis_date` - Date that snapshot was created

- `rpt_kri_threshold_param`, with columns:

   - `studyid` - Unique Study ID
   - `snapshot_date` - Date that snapshot was created
   - `workflowid` - Unique KRI ID
   - `gsm_version` - version of gsm used for analysis
   - `param` - Parameter used for QTL
   - `index` - Index used for threshold values
   - `default_s` - Default values for parameters
   - `configurable` - Logical field indicating if parameter can be configured
   - `pt_cycle_id` - Cycle ID
   - `pt_data_dt` - Data ID
   - `gsm_analysis_date` - Date that snapshot was created

- `rpt_qtl_analysis`, with columns:

   - `studyid` - Unique Study ID
   - `snapshot_date` - Date that snapshot was created
   - `workflowid` - Unique QTL ID
   - `param` - Parameter used for QTL
   - `value` - Score for the QTL
   - `pt_cycle_id` - Cycle ID
   - `pt_data_dt` - Data ID
   - `gsm_analysis_date` - Date that snapshot was created

- `rpt_qtl_details`, with columns:

   - `studyid` - Unique Study ID
   - `snapshot_date` - Date that snapshot was created
   - `workflowid` - Unique QTL ID
   - `metric` - QTL name
   - `numerator_name` - Name of the numerator used to calculate metric
   - `denominator_name` - Name of the denominator used to calculate metric
   - `qtl_value` - QTL numerical metric
   - `base_metric` - Name of numerator over name of denominator
   - `numerator_value` - numerator numerical metric
   - `denominator_value` - denominator numerical metric
   - `qtl_score` - QTL statistical score
   - `flag` - QTL flag value
   - `threshold` - Thershold used to determine score
   - `abbreviation` - Abbreviated QTL name
   - `outcome` - Units representing outcome
   - `model` - Model used for evaluation
   - `meta_score` - Statistical score used
   - `data_inputs` - Data used as inputs for the model
   - `data_filters` - Filters applied to data inputs
   - `gsm_version` - gsm version used for analysis
   - `group` - The grouping used for the analysis
   - `pt_cycle_id` - Cycle ID
   - `pt_data_dt` - Data ID
   - `gsm_analysis_date` - Date that snapshot was created

- `rpt_qtl_threshold_param`, with columns:

   - `studyid` - Unique Study ID
   - `snapshot_date` - Date that snapshot was created
   - `workflowid` - Unique QTL ID
   - `gsm_version` - version of gsm used for analysis
   - `param` - Parameter used for QTL
   - `index` - Index used for threshold values
   - `default_s` - Default values for parameters
   - `configurable` - Logical field indicating if parameter can be configured
   - `pt_cycle_id` - Cycle ID
   - `pt_data_dt` - Data ID
   - `gsm_analysis_date` - Date that snapshot was created

- `rpt_site_details`, with columns:

   - `studyid` - Unique Study ID
   - `snapshot_date` - Date that snapshot was created
   - `siteid` - Unique Site ID
   - `site_num` - Number of site
   - `institution` - Name of site
   - `status` - Status of site
   - `start_date` - Start date of site
   - `invname` - Investigator's name
   - `country` - Country site is located
   - `state` - State site is located
   - `city` - City site is located
   - `region` - Region of site
   - `enrolled_participants` - Enrolled participants
   - `planned_participants` - Planned participants
   - `num_of_at_risk_kris` - Total number of amber flags per KRI
   - `num_of_flagged_kris` - Total number of red flags per KRI
   - `pt_cycle_id` - Cycle ID
   - `pt_data_dt` - Data ID
   - `gsm_analysis_date` - Date that snapshot was created

- `rpt_site_kri_details`, with columns:

   - `studyid` - Unique Study ID
   - `snapshot_date` - Date that snapshot was created
   - `siteid` - Unique Site ID
   - `workflowid` - Unique KRI ID
   - `metric_value` - KRI value
   - `score` - KRI score based on value
   - `numerator_value` - Numerator used to calculate metric
   - `denominator_value` - Denominator used to calculate metric
   - `flag_value` - Flag value reported based on score
   - `no_of_consecutive_loads` - The number of times the site KRI has been continuously flagged
   - `upper_threshold` - Value from status_param when index = 3
   - `lower_threshold` - Value from status_param when index = 2
   - `bottom_lower_threshold` - Value from status_param when index = 1
   - `top_upper_threshold` - Value from status_param when index = 4
   - `metric` - Name of KRI
   - `country_aggregate` - Country aggregate
   - `study_aggregate` - Study aggregate
   - `numerator_name` - Description of Numerator
   - `denominator_name` - Description of Denominator
   - `pt_cycle_id` - Cycle ID
   - `pt_data_dt` - Data ID
   - `gsm_analysis_date` - Date that snapshot was created

- `rpt_study_details`, with columns:

   - `studyid` - Unique Study ID
   - `snapshot_date` - Date that snapshot was created
   - `title` - Title of protocol
   - `ta` - Area of therapy
   - `indication` - Protocol indication
   - `phase` - Phase of study
   - `product` - Name of product
   - `enrolled_sites` - Sites enrolled in study
   - `enrolled_participants` - Participants enrolled in study
   - `planned_sites` - Total planned sites for study
   - `planned_participants` - Total planned participants for study
   - `est_fpfv` - First patient first visit
   - `est_lpfv` - Last patient first visit
   - `est_lplv` - Last patient last visit
   - `status` - Study status
   - `fpfv` - First patient first visit
   - `lpfv` - Last patient first visit
   - `lplv` - Last patient last visit
   - `study_age` - Total age of the study in YMD
   - `num_of_sites_flagged` - Total number of sites with red flags
   - `enrolling_sites_with_flagged_kris` - Enrolled sites with flagged kris
   - `pt_cycle_id` - Cycle ID
   - `pt_data_dt` - Data ID
   - `gsm_analysis_date` - Date that snapshot was created

- `rpt_study_snapshot`, with columns:

   - `study_id` - Unique Study ID
   - `snapshot_date` - Date that snapshot was created
   - `is_latest` - Is this the latest snapshot?
   - `next_snapshot_date` - Next snapshot date
   - `pt_cycle_id` - Cycle ID
   - `pt_data_dt` - Data ID
   - `gsm_analysis_date` - Date that snapshot was created
