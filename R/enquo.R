function(arg) {
  .Call(ffi_enquo, substitute(arg), parent.frame())
}
