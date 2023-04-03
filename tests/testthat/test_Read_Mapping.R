test_that("mappings have nog changed", {
  expect_snapshot(
    Read_Mapping()
  )
})

test_that("Read_Mapping and yaml::read_yaml create identical lists for single domains", {
  rawplus <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
  ctms <- yaml::read_yaml(system.file("mappings", "mapping_ctms.yaml", package = "gsm"))
  edc <- yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))
  adam <- yaml::read_yaml(system.file("mappings", "mapping_adam.yaml", package = "gsm"))

  expect_equal(Read_Mapping("rawplus"), rawplus)
  expect_equal(Read_Mapping("ctms"), ctms)
  expect_equal(Read_Mapping("edc"), edc)
  expect_equal(Read_Mapping("adam"), adam)
})

test_that("Read_Mapping and yaml::read_yaml create identical lists for combined domains", {
  rawplus <- yaml::read_yaml(system.file("mappings", "mapping_rawplus.yaml", package = "gsm"))
  ctms <- yaml::read_yaml(system.file("mappings", "mapping_ctms.yaml", package = "gsm"))
  edc <- yaml::read_yaml(system.file("mappings", "mapping_edc.yaml", package = "gsm"))
  adam <- yaml::read_yaml(system.file("mappings", "mapping_adam.yaml", package = "gsm"))

  expect_equal(
    sort(names(Read_Mapping(c("rawplus", "ctms")))),
    sort(names(c(rawplus, ctms)))
    )

  expect_equal(
    sort(names(Read_Mapping())),
    sort(names(c(rawplus, ctms, edc, adam)))
  )

})


test_that("error is shown when incorrect mapping domain is specified", {
  expect_snapshot(
    Read_Mapping("Gandalf")
  )
})
