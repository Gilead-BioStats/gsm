#' Creates button dropdown list for plotly by names provided
#'
#' @param names `vector` the names with which to populate the dropdown
#'
#' @export
#'
#' @keywords Internal
add_dropdown <- function(names){
  n_names = length(names)
  buttons = vector("list",n_names)

  for(i in seq_along(buttons)){
    vis <- c(list(TRUE), replicate(list(FALSE), n = n_names))
    vis[[i]] <- TRUE
    buttons[i] = list(list(method = "restyle",
                           args = list("transforms[0].value", unique(names)[i]),
                           label = names[i]))
  }

  return_list = list(
    list(
      type = 'dropdown',
      active = 1,
      buttons = buttons
    )
  )

  return(return_list)
}
