mapping_rawplus <- yaml::read_yaml(
  system.file("mappings", "mapping_rawplus.yaml", package = "gsm")
)

mapping_edc <- yaml::read_yaml(
  system.file("mappings", "mapping_edc.yaml", package = "gsm")
)

test_that("common domain mappings contain identical column mappings", {
  common_domains <- intersect(names(mapping_rawplus), names(mapping_edc))

  for (domain in common_domains) {
    expect_equal(
      mapping_rawplus[[domain]],
      mapping_edc[[domain]]
    )
  }
})
