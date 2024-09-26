#' Update Config
#'
#' Update the study configuration file with the snapshot date. Also creates dated directories under
#' - config
#' - data
#' - modules
#'
#' @param strStudyPath `character` Path to study directory.
#' @param strSnapshotDate `character` Snapshot date.
#'
#' @return `list` Comprehensive study configuration metadata for snapshot.
#'
#' @export

UpdateConfig <- function(
    strStudyPath = '.',
    strSnapshotDate = as.character(Sys.Date())
) {
    config <- yaml::read_yaml(glue::glue('{strStudyPath}/config/study.yaml'))

    # Update the snapshot date in the configuration.
    config$SnapshotDate <- strSnapshotDate
    config <- config %>%
        yaml::as.yaml() %>%
        gsub('\\{SnapshotDate\\}', strSnapshotDate, .) %>%
        yaml::read_yaml(text = .)

    # Create a list of all domains.
    config$domains <- config$schemas %>%
        map('domains') %>%
        unname() %>%
        unlist(FALSE)

    # Create dated directories.
    for (dir in c('config', 'data', 'modules')) {
        dir.create(
            glue::glue('{strStudyPath}/{dir}/{config$SnapshotDate}'),
            recursive = TRUE
        )
    }

    # Create a directory in [ data/YYYY-MM-DD ] for each schema.
    for (schema in names(config$schemas)) {
        dir.create(
            glue::glue('{strStudyPath}/data/{config$SnapshotDate}/{schema}'),
            recursive = TRUE
        )
    }

    # Write the updated configuration to the study directory.
    yaml::write_yaml(
        config,
        glue::glue('{strStudyPath}/config/snapshot.yaml')
    )

    yaml::write_yaml(
        config,
        glue::glue('{strStudyPath}/config/{config$SnapshotDate}/config.yaml')
    )

    return(config)
}
