SaveData <- function(lData, lInputConfig) {
    purrr::iwalk(
        lData[
            names(lData)[ !grepl('^Temp_', names(lData)) ]
        ],
        function(data, domain) {
            if (!domain %in% names(lInputConfig$domains)) {
                cli::cli_alert(
                    glue::glue(
                        "No information available for domain [ {domain} ]."
                    )
                )

                return(NULL)
            }

            domain_config <- lInputConfig$domains[[ domain ]]

            cli::cli_h3(
                "Saving [ {domain} ] to `{ domain_config$table }`."
            )

            if (domain_config$db == 'local') {
                # check extension
                if (grepl('\\.csv$', domain_config$table)) {
                    write.csv(
                        data,
                        glue::glue('{domain_config$table}'),
                        row.names = FALSE
                    )
                } else if (grepl('\\.ya?ml$', domain_config$table)) {
                    yaml::write_yaml(
                        data,
                        glue::glue('{domain_config$table}')
                    )
                } else {
                    cli::cli_alert(
                        glue::glue(
                            "Unknown extension for file [ {domain_config$table} ]."
                        )
                    )
                }
            } else if (domain_config$db == 's3') {
            }
        }
    )
}
