table_funcs <- c(ls(loadNamespace("gt")), ls(loadNamespace("kableExtra")), ls(loadNamespace("DT")), ls(loadNamespace("knitr")))
table_funcs <- table_funcs[which(table_funcs != "%||%")]
files_to_check <- list.files(".", full.names = TRUE)

# Initialize an empty data frame
check <- data.frame(File = character(0), Line = integer(0), Function = character(0), stringsAsFactors = FALSE)

for(i in seq_along(files_to_check)) {
  readfile <- readLines(files_to_check[i])
  for(j in seq_along(table_funcs)) {
    # Use fixed = TRUE to avoid regex issues
    hit_lines <- grep(paste0(table_funcs[j], "("), readfile, fixed = TRUE)
    if(length(hit_lines) > 0) {
      # Create a temporary data frame with matches
      temp_df <- data.frame(
        File = files_to_check[i],
        Line = hit_lines,
        Function = table_funcs[j],
        stringsAsFactors = FALSE
      )
      # Append the temporary data frame to check
      check <- rbind(check, temp_df)
    }
  }
}

check <- check %>%
  mutate(package = map(Function, ~ getAnywhere(.x)$where))
