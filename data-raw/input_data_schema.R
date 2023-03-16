library(yaml)
library(tibble)
library(dplyr)
library(purrr)

mapping_rawplus <- read_yaml('inst/mappings/mapping_rawplus.yaml')
mapping_ctms <- read_yaml('inst/mappings/mapping_ctms.yaml')
mapping_edc <- read_yaml('inst/mappings/mapping_edc.yaml')
mapping_domain <- read_yaml('inst/mappings/mapping_domain.yaml')

# Domain-level schema
domain_schema <- tibble(
    Source = mapping_domain %>% map_chr(~.x$source),
    Name = mapping_domain %>% map_chr(~.x$name),
    Domain = mapping_domain %>% map_chr(~.x$domain),
    Active = mapping_domain %>% map_lgl(~.x$active),
    GSM_Domain_Key = names(mapping_domain)
)

get_column_schema <- function(mapping) {
    names(mapping) %>%
        purrr::map_df(function(domain) {
            column_mapping <- mapping[[ domain ]] %>%
                keep_at(grepl('Col$', names(.)))

            column_mapping %>%
                purrr::imap(function(value, key) {
                    tibble::tibble(
                        GSM_Domain_Key = domain,
                        Column = value,
                        GSM_Column_Key = key,
                        Description = key %>%
                            # remove 'str' prefix and 'Col' suffix
                            gsub('^str|Col$', '', .) %>%
                            # replace camelCase with Prop Case
                            gsub('(?<=[a-z])([A-Z])', ' \\1', ., perl = TRUE) %>%
                            sub('^ID$', 'Subject ID', .) %>%
                            sub('^EDCID$', 'Subject ID (EDC)', .)
                        )
                }) %>%
                purrr::list_rbind()
        })
}

# column-level schema
column_schema <- bind_rows(
    get_column_schema(mapping_rawplus),
    get_column_schema(mapping_ctms),
    get_column_schema(mapping_edc)
)

# all together now
input_data_schema <- domain_schema %>%
    full_join(
        column_schema,
        'GSM_Domain_Key',
        multiple = 'all'
    ) %>%
    filter(Active) %>%
    select(-Active) %>%
    distinct(GSM_Domain_Key, Column, .keep_all = TRUE)

usethis::use_data(
    input_data_schema,
    overwrite = TRUE
)
