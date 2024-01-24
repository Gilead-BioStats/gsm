function(x) {
  if (is_quosure(x)) {
    x <- quo_get_expr(x)
  }
  as_string(x)
}
