# Use cli style messages via logger

    Code
      LogMessage(level = "info", message = "cli style info", cli_detail = "h1")
    Message
      
      -- cli style info --------------------------------------------------------------

---

    Code
      LogMessage(level = "info", message = "cli style info", cli_detail = "h2")
    Message
      
      -- cli style info --
      

---

    Code
      LogMessage(level = "info", message = "cli style info", cli_detail = "h3")
    Message
      
      -- cli style info 

---

    Code
      LogMessage(level = "info", message = "cli style info", cli_detail = "alert_success")
    Message
      v cli style info

---

    Code
      tryCatch(LogMessage(level = "warn", message = "cli style warn"))
    Condition
      Warning:
      cli style warn

