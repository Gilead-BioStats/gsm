#' Validate df
#'
#' @param df `data.frame` The df to validate.
#' @param allow_null `logical` Whether the df can be empty.
#' @param required_colnames `character` 0 or more required columns.
#' @param df_arg `character` The name of the `df` in the calling function.
#' @param call `environment` Where the call came from, for error messaging.
#'
#' @return The validated df.
#' @keywords internal
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
    cli::cli_abort(
      "{.arg {df_arg}} must be a data.frame.",
      call = call
    )
  }
  missing_colnames <- setdiff(required_colnames, colnames(df))
  if (length(missing_colnames)) {
    cli::cli_abort(
      "{.arg {df_arg}} must contain {cli::qty(missing_colnames)} column{?s} {.val {missing_colnames}}.",
      call = call
    )
  }
  return(df)
}
