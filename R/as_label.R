function(x) {
  x <- quo_squash(x)
  if (is_missing(x)) {
    return("<empty>")
  }
  switch(typeof(x),
    `NULL` = "NULL",
    symbol = as_string(x),
    language = {
      if (is_data_pronoun(x)) {
        return(data_pronoun_name(x) %||% "<unknown>")
      }
      if (use_as_label_infix() && infix_overflows(x)) {
        return(as_label_infix(x))
      }
      name <- deparse_one(x)
      name <- gsub("\n.*$", "...", name)
      name
    },
    if (is_bare_atomic(x, n = 1)) {
      name <- expr_text(x)
      name <- gsub("\n.*$", "...", name)
      name
    } else {
      paste0("<", rlang_type_sum(x), ">")
    }
  )
}
