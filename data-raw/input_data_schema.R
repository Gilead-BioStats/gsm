library(yaml)
library(tibble)
library(dplyr)
library(purrr)

mapping_rawplus <- read_yaml('inst/mappings/mapping_rawplus.yaml')
mapping_edc <- read_yaml('inst/mappings/mapping_edc.yaml')
mapping_domain <- read_yaml('inst/mappings/mapping_domain.yaml')

mapping_column <- c(mapping_rawplus, mapping_edc)

# TODO: identify required columns
required_columns <- list.files('inst/specs', 'Map_Raw', full.names = TRUE) %>%
    purrr::map_dfr(function(file) {
        filename <- stringr::str_split_1(file, '/') %>%
            tail(1)

        assessment <- sub('_Map_Raw.*$', '', filename)
        cli::cli_alert_info('assessment: {assessment}')

        spec <- yaml::read_yaml(file) %>%
            imap_dfr(function(value, key) {
                cli::cli_alert_info('domain: {key}')
                domain_mapping <- mapping_column[[ key ]]

                required_columns <- tibble(
                    assessment = assessment,
                    domain = key,
                    column = map_chr(
                        value$vRequired,
                        ~domain_mapping[[ .x ]]
                    )
                )

                required_columns
            })

        spec
    }) %>%
    distinct(domain, column) %>%
    arrange(domain, column)

domain_schema <- tibble(
    Source = mapping_domain %>% map_chr(~.x$source),
    Table = mapping_domain %>% map_chr(~.x$domain),
    Active = mapping_domain %>% map_lgl(~.x$active),
    GSM_Key = names(mapping_domain)
)

get_column_schema <- function(mapping) {
    names(mapping) %>%
        purrr::map_df(function(domain) {
            column_mapping <- mapping[[ domain ]] %>%
                keep_at(grepl('Col$', names(.)))

            column_mapping %>%
                purrr::imap(function(value, key) {
                    tibble::tibble(
                        GSM_Key = domain,
                        Column = value,
                        Description = key %>%
                            # remove 'str' prefix and 'Col' suffix
                            gsub('^str|Col$', '', .) %>%
                            # replace camelCase with Prop Case
                            gsub('(?<=[a-z])([A-Z])', ' \\1', ., perl = TRUE) %>%
                            sub('^ID$', 'Subject ID', .)
                        )
                }) %>%
                purrr::list_rbind()
        })
}

column_schema <- bind_rows(
    get_column_schema(mapping_rawplus),
    get_column_schema(mapping_edc)
)

input_data_schema <- domain_schema %>%
    full_join(
        column_schema,
        'GSM_Key',
        multiple = 'all'
    ) %>%
    filter(Active) %>%
    select(-Active) %>%
    distinct(GSM_Key, Column, .keep_all = TRUE)

usethis::use_data(
    input_data_schema,
    overwrite = TRUE
)
