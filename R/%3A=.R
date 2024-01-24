function(x, y) {
  abort("`:=` can only be used within dynamic dots.", call = caller_env())
}
