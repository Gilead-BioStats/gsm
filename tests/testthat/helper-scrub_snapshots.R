scrub_bytecode <- function(x) {
  stringr::str_subset(
    x,
    "$<bytecode:",
    negate = TRUE
  )
}
