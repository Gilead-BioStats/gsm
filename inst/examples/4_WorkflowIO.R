load_all()

LoadData <- function(lWorkflow, lConfig) {
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

            return(ApplySpec(data, .x))
        }
    )
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
    Domains = list(
        Raw_PD = function() { clindata::ctms_protdev },
        Raw_SUBJ = function() { clindata::rawplus_dm },
        Raw_SITE = function() { clindata::ctms_site },

        Mapped_PD = file.path(tempdir(), 'mapped-pd.csv'),
        Mapped_SUBJ = file.path(tempdir(), 'mapped-subj.csv'),
        Mapped_SITE = file.path(tempdir(), 'mapped-site.csv')
    )
)

lMappedData <- RunWorkflows(
    MakeWorkflowList(c('SUBJ', 'PD', 'SITE')),
    lConfig = lConfig
)
