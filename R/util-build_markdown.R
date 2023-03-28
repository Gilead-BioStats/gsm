#' build markdown from mapping.
#'
#' @param yaml_path path to adam mapping yaml
#'
#' @importFrom purrr map
#' @importFrom stringr word
#' @importFrom yaml read_yaml
#'
#' @noRd
build_markdown <- function() {
  specs <- list.files(
    "inst/specs/",
    "\\.yaml$",
    TRUE,
    TRUE
  )

  mappings <- c(
    yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm")),
    yaml::read_yaml(system.file("mappings", "mapping_ctms.yaml", package = "gsm")),
    yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm")),
    yaml::read_yaml(system.file("mappings", "mapping_adam.yaml", package = "gsm"))
  )

  specs %>%
    purrr::map(function(spec) {
      # Extract file name.
      name <- stringr::word(
        spec,
        -2,
        sep = "[\\\\/.]" # backslash, forward slash, period
      )

      print(paste0(
        "Processing [ ", name, " ]."
      ))

      if (file.exists(sub("specs", "mappings", spec))) {
        gsm::generate_md_table(name)
      } else if (grepl("_map_", name, ignore.case = TRUE)) {
        gsm::generate_md_table(name, mappings)
      } else {
        print(paste0(
          "[ ", name, " ] cannot be processed. ",
          "Please verify both an associated data mapping and data specification exist."
        ))
      }
    })
}
