LoadData <- function(lWorkflow, lConfig) {
    domains <- names(lWorkflow$spec)
    lData <- list()

    for (domain in domains) {
        if (!domain %in% names(lConfig$domains)) {
            cli::cli_alert(
                "No information available for domain [ {domain} ]."
            )

            next
        }

        domain_config <- lConfig$domains[[ domain ]]
        domain_spec <- lWorkflow$spec[[ domain ]]

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
        }
        else if (domain_config$db == 'local') {
            # Verify file exists.
            #if (!file.exists(domain_config$table)) {
            #    cli::cli_alert(
            #        "File [ {domain_config$table} ] does not exist."
            #    )

            #    next
            #}
            # check extension
            if (grepl('\\.csv$', domain_config$table)) {
                path <- domain_config$table %>% gsub('\\{.*}', '**', .)

                connection <- DBI::dbConnect(duckdb::duckdb())
                lData[[ domain ]] <- connection %>%
                    dplyr::tbl(glue::glue("read_csv('{path}', all_varchar = true)")) %>%
                    dplyr::collect()
                DBI::dbDisconnect(connection)
            } else if (grepl('\\.ya?ml$', domain_config$table)) {
                lData[[ domain ]] <- yaml::read_yaml(domain_config$table)
            } else {
                cli::cli_alert(
                    glue::glue(
                        "Unknown extension for file [ {domain_config$table} ]."
                    )
                )
            }
        }

        if (!is.null(domain_spec)) {
            lData[[ domain ]] <- ApplySpec(
                lData[[ domain ]],
                domain_spec,
                domain
            )
        }
    }

    return(lData)
}
