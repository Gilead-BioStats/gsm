# This example runs multiple assessments on a single trial in the rawplus format. 

# Load all rawplus data from the study saved in clindata
clindata<-ls('package:safetyData') %>% 
    keep(stringr::str_detect(.x, "rawplus_"))%>%
    parse%>%
    as.list

# load the default mapping 
mapping<- read_yaml(clindata.yaml)

# create a report that includes assessment results along with a summary of data compatability
results <- gsm::study_assess(data=clindata, mapping=yaml)

# see a summary of assessments that are included in results 
print(results$dataChecks)

# make a markdown report
run_report(results$assessment)
@jwildfire
draft