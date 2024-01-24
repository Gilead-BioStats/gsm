function (strFileName = NULL) {
    if (is.null(strFileName)) {
        strFileName <- paste0("gsm_log_", make.names(Sys.time()), 
            ".log")
    }
    else {
        strFileName <- paste0(strFileName, ".log")
    }
    possible_user_identity <- Sys.getenv(c("USER", "USERNAME", 
        "RSTUDIO_USER_IDENTITY"))
    con <- file(strFileName)
    sink(con, append = TRUE)
    sink(con, append = TRUE, type = "message")
    cli::cli_h1("BEGIN SESSION INFO")
    print(paste0("User: ", max(possible_user_identity)))
    print(paste0("Time: ", Sys.time()))
    print(sessionInfo())
    cli::cli_h1("END SESSION INFO")
}
