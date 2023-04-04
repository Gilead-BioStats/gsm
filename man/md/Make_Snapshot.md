# Return - Data Model Description

A named `list` of data.frames:

 - `status_study`, with columns:
 
   - `studyid` - Unique Study ID 
   - `enrolled_sites` - # of enrolled sites 
   - `enrolled_participants` - # of enrolled participants 
   - `planned_sites` - # of planned sites 
   - `planned_participants` - # of planned participants 
   - `title` - Protocol title 
   - `nickname` - Protocol nickname 
   - `enrolled_sites_ctms` - # of enrolled sites (ctms)
   - `enrolled_participants_ctms` - # of enrolled participants (ctms)
   - `fpfv` - First-patient first visit date 
   - `lpfv` - Last-patient first visit date
   - `lplv` - Last-patient last visit date 
   - `ta` - Therapeutic Area 
   - `indication` - Indication
   - `phase` - Phase
   - `status` - Study Status 
   - `rbm_flag` - Risk-based monitoring flag 
   - `product` - Product
   - `protocol_type` - Protocol type
   - `protocol_row_id` - Protocol row ID
   - `est_fpfv` - Estimated first-patient first visit date
   - `est_lpfv` - Estimated last-patient first visit date
   - `est_lplv` - Estimated last-patient last visit date
   - `protocol_product_number` - Protocol product number
   - `gsm_analysis_date` - Date that `Make_Snapshot` was run

 - `status_site`, with columns:
 
   - `studyid` - Unique Study ID 
   - `siteid` - Unique Site ID 
   - `institution` - Institution Name 
   - `status` - Site Status 
   - `enrolled_participants` - # of enrolled participants 
   - `start_date` - Site Activation Date 
   - `city` - City 
   - `state` - State
   - `country` - Country
   - `invname` - Investigator name
   - `protocol_row_id` - Protocol Row ID
   - `site_num` - Site number
   - `site_row_id` - Site Row ID
   - `pi_number` - Principal Investigator Number
   - `pi_last_name`- Principal Investigator Last Name
   - `pi_first_name` - Principal Investigator First Name
   - `is_satellite` - Is location a satellite campus/site?
   - `gsm_analysis_date` - Date that `Make_Snapshot` was run
   
 - `status_workflow`, with columns:
 
   - `studyid` - Unique Study ID 
   - `workflowid` - Unique Workflow ID 
   - `gsm_version` - GSM version of workflow 
   - `active` - Is workflow active?  
   - `status` - Did workflow run? 
   - `notes` - Status notes 
   - `gsm_analysis_date` - Date that `Make_Snapshot` was run
   
 - `status_param`, with columns: 
 
   - `study_id` - Unique Study ID 
   - `workflowid` - Unique Workflow ID 
   - `gsm_version` - GSM version of workflow 
   - `param` - Parameter name 
   - `index` - Index value for parameter 
   - `value` - Value for parameter at index 
   - `gsm_analysis_date` - Date that `Make_Snapshot` was run
   
 - `results_summary`, with columns: 
 
   - `studyid` - Unique Study ID 
   - `workflowid` - Unique Workflow ID 
   - `groupid` - Unique Group ID (e.g. SiteID for KRI workflows) 
   - `numerator` - Metric numerator 
   - `denominator` - Metric denominator 
   - `metric` - Metric value 
   - `score` - Statistical Score 
   - `flag` - Flag 
   - `gsm_analysis_date` - Date that `Make_Snapshot` was run
  
 - `results_bounds`, with columns:  

   - `studyid` - Unique Study ID 
   - `workflowid` - Unique Workflow ID 
   - `threshold` - Threshold
   - `numerator` - Y value
   - `denominator` - X value
   - `log_denominator` - Log X value
   - `gsm_analysis_date` - Date that `Make_Snapshot` was run
  
- `meta_workflow`, with columns: 

   - `workflowid` - Unique Workflow ID
   - `gsm_version` - GSM Version of workflow
   - `group` - Group for workflow - Site, Country, Region, or Study
   - `abbreviation` - Abbreviation for KRI/assessment
   - `metric` - Metric Label
   - `numerator` - Numerator Label 
   - `denominator` - Denominator Label 
   - `outcome` - Metric Outcome Type (e.g. rate) 
   - `model` - Statistical Model used to create score 
   - `score` - Score Label 
   - `data_inputs` - Data inputs for workflow 
   - `data_filters` - Filters applied in workflow 
   - `gsm_analysis_date` - Date that `Make_Snapshot` was run
  
- `meta_param`, with columns:

   - `workflowid` - Unique Workflow ID 
   - `gsm_version` - GSM version of workflow 
   - `param` - Parameter name 
   - `index` - Parameter index 
   - `default` - Default value for parameter at index 
   - `configurable` - Is parameter configurable?  
   - `gsm_analysis_date` - Date that `Make_Snapshot` was run

