function (..., .named = FALSE, .ignore_empty = c("trailing", 
    "none", "all"), .ignore_null = c("none", "all"), .unquote_names = TRUE, 
    .homonyms = c("keep", "first", "last", "error"), .check_assign = FALSE) {
    quos <- endots(call = sys.call(), frame_env = parent.frame(), 
        capture_arg = ffi_enquo, capture_dots = ffi_quos_interp, 
        named = .named, ignore_empty = .ignore_empty, ignore_null = .ignore_null, 
        unquote_names = .unquote_names, homonyms = .homonyms, 
        check_assign = .check_assign)
    structure(quos, class = c("quosures", "list"))
}
