#' Utility function to suppress all messages in unit tests
#'
#' @param action 'start' (the default) or 'stop'. Used in `testthat/setup.R` to temporarily divert messages to a log file.
#'
quietDown <- function(action = "start") {

  if (action == "start") {
  # Open a file to send messages to
  echoChamber <- file("messages.Rout", open = "wt")
  # Divert messages to that file
  sink(echoChamber, type = "message")
  }

  if (action == "stop") {
    sink(type = "message")
  }
}
