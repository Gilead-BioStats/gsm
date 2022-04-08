#' Utility function to suppress all messages in unit tests
#'
quietDown <- function() {
  # Open a file to send messages to
  echoChamber <- file("messages.Rout", open = "wt")
  # Divert messages to that file
  sink(echoChamber, type = "message")
}
