load_all()

LoadData <- function(lWorkflow, lConfig, lData = NULL) {
  lData <- lData
    purrr::imap(
        lWorkflow$spec,
        ~ {
            input <- lConfig$Domains[[ .y ]]

            if (is.data.frame(input)) {
                data <- input
            } else if (is.function(input)) {
                data <- input()
            } else if (is.character(input)) {
                data <- read.csv(input)
            } else {
                cli::cli_abort("Invalid data source: {input}.")
            }

            lData[[ .y ]] <<- (ApplySpec(data, .x))
        }
    )
    return(lData)
}

SaveData <- function(lWorkflow, lConfig) {
    domain <- paste0(lWorkflow$meta$Type, '_', lWorkflow$meta$ID)
    cli::cli_alert_info(domain)

    if (exists(domain, lConfig$Domains)) {
        output <- lConfig$Domains[[ domain ]]
        cli::cli_alert_info(output)

        cli::cli_alert_info(
            'Saving output of `lWorkflow` to `{output}`.'
        )

        write.csv(
            lWorkflow$lResult,
            output
        )
    } else {
        cli::cli_alert_info(
            '{domain} not found.'
        )
    }
}

lConfig <- list(
    LoadData = LoadData,
    SaveData = SaveData,
    Domains = c(
        Raw_STUDY = function() { clindata::ctms_study },
        Raw_SITE = function() { clindata::ctms_site },
        Raw_PD = function() { clindata::ctms_protdev },

        Raw_SUBJ = function() { clindata::rawplus_dm },
        Raw_ENROLL = function() { clindata::rawplus_enroll },
        Raw_SDRGCOMP = function() { clindata::rawplus_sdrgcomp },
        Raw_STUDCOMP = function() { clindata::rawplus_studcomp },
        Raw_LB = function() { clindata::rawplus_lb },
        Raw_AE = function() { clindata::rawplus_ae },

        Raw_DATAENT = function() { clindata::edc_data_pages },
        Raw_DATACHG = function() { clindata::edc_data_points },
        Raw_QUERY = function() { clindata::edc_queries },

        Mapped_STUDY = file.path(tempdir(), 'mapped-study.csv'),
        Mapped_SITE = file.path(tempdir(), 'mapped-site.csv'),
        Mapped_COUNTRY = file.path(tempdir(), 'mapped-country.csv'),
        Mapped_PD = file.path(tempdir(), 'mapped-pd.csv'),

        Mapped_SUBJ = file.path(tempdir(), 'mapped-subj.csv'),
        Mapped_ENROLL = file.path(tempdir(), 'mapped-enroll.csv'),
        Mapped_SDRGCOMP = file.path(tempdir(), 'mapped-sdrgcomp.csv'),
        Mapped_STUDCOMP = file.path(tempdir(), 'mapped-studcomp.csv'),
        Mapped_LB = file.path(tempdir(), 'mapped-lb.csv'),
        Mapped_AE = file.path(tempdir(), 'mapped-ae.csv'),

        Mapped_DATAENT = file.path(tempdir(), 'mapped-dataent.csv'),
        Mapped_DATACHG = file.path(tempdir(), 'mapped-datachg.csv'),
        Mapped_QUERY = file.path(tempdir(), 'mapped-query.csv')
    )
)

lMappedData <- RunWorkflows(
    MakeWorkflowList(strPath = 'workflow/1_mappings'),
    lConfig = lConfig
)
