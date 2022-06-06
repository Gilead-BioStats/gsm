#' build markdown from mapping
#'
#' @param yaml_path path to adam mapping yaml
#'
#' @importFrom purrr map
#' @importFrom stringr word
#' @importFrom yaml read_yaml
#'
#' @noRd
build_markdown <- function(yaml_path) {
  specs <- list.files(
    "inst/specs/",
    "\\.yaml$",
    TRUE,
    TRUE
  )

  mapping_adam <- yaml::read_yaml(yaml_path)

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

      # TODO: reference ADaM mapping once implemented in {clindata}
      if (file.exists(sub("specs", "mappings", spec))) {
        gsm::generate_md_table(name)
      } else if (grepl("map_raw", name, ignore.case = TRUE)) {
        gsm::generate_md_table(name, clindata::mapping_rawplus)
      } else if (grepl("map_adam", name, ignore.case = TRUE)) {
        gsm::generate_md_table(name, mapping_adam)
      } else {
        print(paste0(
          "[ ", name, " ] cannot be processed. ",
          "Please verify both an associated data mapping and data specification exist."
        ))
      }
    })
}
