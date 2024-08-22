validate_df <- function(
    df,
    allow_null = FALSE,
    required_colnames = character(),
    df_arg = rlang::caller_arg(df),
    call = rlang::caller_env()
) {
  if (allow_null && is.null(df)) {
    return(NULL)
  }
  if (!is.data.frame(df)) {
    cli::cli_abort("{.arg {df_arg}} must be a data.frame.")
  }
  missing_colnames <- setdiff(required_colnames, colnames(df))
  if (length(missing_colnames)) {
    cli::cli_abort(
      "{.arg {df_arg}} must contain {cli::qty(missing_colnames)} column{?s} {.val {missing_colnames}}."
    )
  }
  return(df)
}
