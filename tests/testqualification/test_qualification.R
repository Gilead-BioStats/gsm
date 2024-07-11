library(testthat)

devtools::load_all()

# read original DESCRIPTION file
d <- readLines("DESCRIPTION")

# change 'true' to 'false' to turn off parallel testing for qualification tests
modified_description <- gsub("Config/testthat/parallel: true", "Config/testthat/parallel: false", fixed = TRUE, x = d)
writeLines(modified_description, here::here("DESCRIPTION"))

# reload package with modified DESCRIPTION file
devtools::load_all()
test_dir(here::here("tests", "testqualification", "qualification"), package = "gsm")

# save the original DESCRIPTION file
writeLines(d, here::here("DESCRIPTION"))
