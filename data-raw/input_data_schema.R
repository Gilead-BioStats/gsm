library(yaml)
library(tibble)
library(dplyr)
library(purrr)

mapping_rawplus <- read_yaml('inst/mappings/mapping_rawplus.yaml')
mapping_edc <- read_yaml('inst/mappings/mapping_edc.yaml')
mapping_domain <- read_yaml('inst/mappings/mapping_domain.yaml')

domain_schema <- tibble(
    System = 'G.DASH',
    Source = mapping_domain %>%
        map_chr(~.x$source),
    Table = mapping_domain %>%
        map_chr(~.x$domain),
    Method = mapping_domain %>%
        map_chr(~.x$method),
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
                            gsub('^str|Col$', '', .) %>%
                            gsub('(?<=[a-z])([A-Z])', ' \\1', ., perl = TRUE)
                        )
                }) %>%
                purrr::list_rbind()
        })
}

column_schema <- bind_rows(
    get_column_schema(mapping_rawplus),
    get_column_schema(mapping_edc)
)

data_schema <- domain_schema %>%
    full_join(
        column_schema,
        'GSM_Key'
    )
