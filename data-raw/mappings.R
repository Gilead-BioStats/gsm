library(magrittr)
library(purrr)
library(stringr)
library(usethis)
library(yaml)

system.file('mappings', package = 'gsm') %>% # path to ./inst/mappings
  list.files(
    'yaml$', # retrieve .yaml files in ./inst/mappings
    full.names = TRUE
  ) %>%
  purrr::walk(function(yaml) {
    mapping <- yaml::read_yaml(yaml) # read .yaml
    mapping_name <- stringr::word(yaml, -2, sep = '/|\\.') # name of mapping
    assign(mapping_name, mapping) # define local variable
    do.call(
      'use_data',
      list(
        as.name(mapping_name),
        overwrite = TRUE
      )
    )
  })
