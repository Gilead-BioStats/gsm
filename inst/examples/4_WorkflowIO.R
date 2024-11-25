load_all()

LoadData <- function(lWorkflow, lConfig) {
    purrr::imap(
        lWorkflow$spec,
        ~ {
            if (is.data.frame(lConfig[[ .y ]])) {
                data <- lConfig[[ .y ]]
            } else if (is.function(lConfig[[ .y ]])) {
                data <- lConfig[[ .y ]]()
            } else if (is.character(lConfig[[ .y ]]) && file.exists(lConfig[[ .y ]])) {
                data <- read.csv(lConfig[[ .y ]])
            } else {
                cli::cli_abort("Invalid data source: {lConfig[[ .y ]]}.")
            }

            return(ApplySpec(data, .x))
        }
    )
}

SaveData <- function(lWorkflow, lConfig) {
    domain <- paste0(lWorkflow$meta$Type, '_', lWorkflow$meta$ID)
    cli::cli_alert_info(domain)

    if (exists(domain, lConfig)) {
        output <- lConfig[[ domain ]]
        cli::cli_alert_info(output)

        cli::cli_alert_info(
            'Saving output of `lWorkflow` to `{output}`.'
        )

        write.csv(
            lWorkflow$lResult,
            output
        )
    }
}

lConfig <- list(
    LoadData = LoadData,
    SaveData = SaveData,

    Raw_PD = function() { clindata::ctms_protdev },
    Raw_SUBJ = function() { clindata::rawplus_dm },
    Raw_SITE = function() { clindata::ctms_site },

    Mapped_PD = paste0(tempdir(), '/mapped-pd.csv'),
    Mapped_SUBJ = paste0(tempdir(), '/mapped-subj.csv'),
    Mapped_SITE = paste0(tempdir(), '/mapped-site.csv')
)

lMappedData <- RunWorkflows(
    MakeWorkflowList(c('SUBJ', 'PD', 'SITE')),
    lConfig = lConfig
)
