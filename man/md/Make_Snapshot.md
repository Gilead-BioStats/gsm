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
   - `indication` - Indication
   - `ta` - Therapeutic Area 
   - `phase` - Phase
   - `status` - Study Status 
   - `fpfv` - First-patient first visit date 
   - `lplv` - Last-patient last visit date 
   - `rbm_flag` - Risk-based monitoring flag 

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
   
 - `status_workflow`, with columns:
 
   - `studyid` - Unique Study ID 
   - `workflowid` - Unique Workflow ID 
   - `gsm_version` - GSM version of workflow 
   - `active` - Is workflow active?  
   - `status` - Did workflow run? 
   - `notes` - Status notes 
   
 - `status_param`, with columns: 
 
   - `study_id` - Unique Study ID 
   - `workflowid` - Unique Workflow ID 
   - `gsm_version` - GSM version of workflow 
   - `param` - Parameter name 
   - `index` - Index value for parameter 
   - `value` - Value for parameter at index 
   
 - `status_schedule`, with columns:
 
   - `study_id` - Unique Study ID 
   - `snapshot_date` - Snapshot Date 
   
 - `results_summary`, with columns: 
 
   - `studyid` - Unique Study ID 
   - `workflowid` - Unique Workflow ID 
   - `groupid` - Unique Group ID (e.g. SiteID for KRI workflows) 
   - `numerator` - Metric numerator 
   - `denominator` - Metric denominator 
   - `metric` - Metric value 
   - `score` - Statistical Score 
   - `flag` - Flag 
  
 - `results_bounds`, with columns:  
 
   - `studyid` - Unique Study ID 
   - `workflowid` - Unique Workflow ID 
   - `threshold` - Threshold
   - `numerator` - Y value
   - `denominator` - X value
   - `log_denominator` - Log X value
  
- `meta_workflow`, with columns: 

   - `workflowid` - Unique Workflow ID
   - `gsm_version` - GSM Version of workflow
   - `group` - Group for workflow - Site, Country, Region, or Study
   - `metric` - Metric Label
   - `numerator` - Numerator Label 
   - `denominator` - Denominator Label 
   - `outcome` - Metric Outcome Type (e.g. rate) 
   - `model` - Statistical Model used to create score 
   - `score` - Score Label 
   - `data_inputs` - Data inputs for workflow 
   - `data_filters` - Filters applied in workflow 
  
- `meta_param`, with columns:

   - `workflowid` - Unique Workflow ID 
   - `gsm_version` - GSM version of workflow 
   - `param` - Parameter name 
   - `index` - Parameter index 
   - `default` - Default value for parameter at index 
   - `configurable` - Is parameter configurable?  

