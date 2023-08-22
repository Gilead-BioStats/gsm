get_test_data_from_github <- function() {

  snapshot_directories <- c("2015-12-01", "2016-12-01", "2017-12-01", "2018-12-01", "2019-12-01")

  a <- purrr::map(snapshot_directories, function(snapshot_directory) {

    req <- httr::GET(
      glue::glue("https://api.github.com/repos/Gilead-BioStats/clindata/contents/inst/data-longitudinal/AA-AA-000-0000/{snapshot_directory}?ref=fix-177")
    )

    snapshot_directory_content <- httr::content(req)

   # TODO: create overall directory equivalent of AA-AA-000-0000
   #       create subdirectories for all of the snapshot directories
   #       download files and store in subdirectories

  })


}
