LoadData <- function(lWorkflow, lInputConfig) {
    domains <- names(lWorkflow$spec)
    lData <- list()

    for (domain in domains) {
        if (!domain %in% names(lInputConfig$domains)) {
            cli::cli_alert(
                glue::glue(
                    "No information available for domain [ {domain} ]."
                )
            )

            next
        }

        domain_config <- lInputConfig$domains[[ domain ]]

        cli::cli_h3(
            "Loading [ {domain} ] from `{ domain_config$db }.{ domain_config$table }`."
        )

        if (domain_config$db == 'clindata') {
            lData[[ domain ]] <- do.call(
                `::`,
                list(
                    'clindata',
                    domain_config$table
                )
            )
        } else if (domain_config$db == 'local') {
            # check extension
            if (grepl('\\.csv$', domain_config$table)) {
                lData[[ domain ]] <- readr::read_csv(domain_config$table)
            } else if (grepl('\\.ya?ml$', domain_config$table)) {
                lData[[ domain ]] <- yaml::read_yaml(domain_config$table)
            } else {
                cli::cli_alert(
                    glue::glue(
                        "Unknown extension for file [ {domain_config$table} ]."
                    )
                )
            }
            #lData[[ domain ]] <- dbConnect(duckdb()) %>%
            #    tbl(glue::glue("read_csv({domain_config$table})")) %>%
            #    collect()
        }
    }

    return(lData)
}
