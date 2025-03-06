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
        Raw_STUDY = function() { gsm::lSource$Raw_STUDY },
        Raw_SITE = function() { gsm::lSource$Raw_SITE },
        Raw_PD = function() { gsm::lSource$Raw_PD },

        Raw_SUBJ = function() { gsm::lSource$Raw_SUBJ },
        Raw_ENROLL = function() { gsm::lSource$Raw_ENROLL },
        Raw_SDRGCOMP = function() { gsm::lSource$Raw_SDRGCOMP },
        Raw_STUDCOMP = function() { gsm::lSource$Raw_STUDCOMP },
        Raw_LB = function() { gsm::lSource$Raw_LB },
        Raw_AE = function() { gsm::lSource$Raw_AE },

        Raw_DATAENT = function() { gsm::lSource$Raw_DATAENT },
        Raw_DATACHG = function() { gsm::lSource$Raw_DATACHG },
        Raw_QUERY = function() { gsm::lSource$Raw_QUERY },

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

core_mappings <- c("AE", "COUNTRY", "DATACHG", "DATAENT", "ENROLL", "LB",
                   "PD", "QUERY", "STUDY", "STUDCOMP", "SDRGCOMP", "SITE", "SUBJ")

lMappedData <- RunWorkflows(
    MakeWorkflowList(strNames = core_mappings, strPath = 'workflow/1_mappings', strPackage = "gsm.mapping"),
    lConfig = lConfig
)
