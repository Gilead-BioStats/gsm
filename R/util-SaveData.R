SaveData <- function(lWorkflow, lConfig, strDomain = NULL) {
    stopifnot(
        '[ lWorkflow ] must be specified.' = !is.null(lWorkflow),
        '[ lConfig ] must be specified.' = !is.null(lConfig),
        '[ lWorkflow ] must have a result.' = !is.null(lWorkflow$lResult)
    )

    #lSchema <- lConfig$schemas[[ lWorkflow$meta$Type ]]

    if (is.null(strDomain)) {
        strDomain <- glue::glue('{lWorkflow$meta$Type}_{lWorkflow$meta$ID}')
    }

    if (!strDomain %in% names(lConfig$domains)) {
        cli::cli_alert(
            "No information available for domain [ {strDomain} ]."
        )

        return(NULL)
    }

    lDomainConfig <- lConfig$domains[[ strDomain ]]

    # Add metadata to the result.
    lWorkflow$lResult$StudyID <- lConfig$StudyID
    lWorkflow$lResult$SnapshotDate <- lConfig$SnapshotDate
    lWorkflow$lResult$Type <- lWorkflow$meta$Type
    lWorkflow$lResult$ID <- lWorkflow$meta$ID

    # Handle edge case for metric workflows that are nested by ID.
    if (grepl('\\{ID}', lDomainConfig$table)) {
        # Replace {ID} with the workflow ID.
        lDomainConfig$table <- sub('\\{ID}', lWorkflow$meta$ID, lDomainConfig$table)

        # Create workflow directory if it doesn't exist.
        strTableDirectory <- dirname(lDomainConfig$table)
        if (!dir.exists(strTableDirectory)) {
            cli::cli_alert_info(
                "Creating directory [ {strTableDirectory} ]."
            )
            dir.create(strTableDirectory, recursive = TRUE)
        }

        # Differentiate data between metrics.
        lWorkflow$lResult$MetricID <- glue::glue('{lWorkflow$meta$Type}_{lWorkflow$meta$ID}')
    }

    cli::cli_h3(
        "Saving [ {strDomain} ] to `{ lDomainConfig$table }`."
    )

    if (lDomainConfig$db == 'local') {
        # check extension
        if (grepl('\\.csv$', lDomainConfig$table)) {
            write.csv(
                lWorkflow$lResult,
                glue::glue('{lDomainConfig$table}'),
                row.names = FALSE
            )
        } else if (grepl('\\.ya?ml$', lDomainConfig$table)) {
            yaml::write_yaml(
                lWorkflow$lResult,
                glue::glue('{lDomainConfig$table}')
            )
        } else {
            cli::cli_alert(
                glue::glue(
                    "Unknown extension for file [ {lDomainConfig$table} ]."
                )
            )
        }
    } else if (lDomainConfig$db == 's3') {
    }
}

