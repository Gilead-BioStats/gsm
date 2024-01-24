function (domain, mapping = NULL, mapping_path = "./inst/mappings/", 
    spec = NULL, spec_path = "./inst/specs/", out_path = "./man/md/", 
    header = "# Data specification") {
    if (is.null(mapping)) {
        mapping <- gsm::parse_data_mapping(file = paste0(mapping_path, 
            domain, ".yaml"))
        if (is.null(mapping)) {
            warning("[ mapping ] does not exist.")
            return(NULL)
        }
    }
    else if ("list" %in% class(mapping)) {
        mapping_attempt <- tryCatch({
            mapping <- gsm::parse_data_mapping(mapping)
        }, error = function(error) {
            message(error)
            return(NULL)
        }, finally = message("Transforming [ spec ] from `list` to `data.frame`."))
        if (is.null(mapping_attempt)) {
            return(NULL)
        }
    }
    if (is.null(spec)) {
        spec <- gsm::parse_data_spec(file = paste0(spec_path, 
            domain, ".yaml"))
        if (is.null(spec)) {
            warning("[ spec ] does not exist.")
            return(NULL)
        }
    }
    else if ("list" %in% class(spec)) {
        spec_attempt <- tryCatch({
            spec <- gsm::parse_data_spec(spec)
        }, error = function(error) {
            message(error)
            return(NULL)
        }, finally = message("Transforming [ spec ] from `list` to `data.frame`."))
        if (is.null(spec_attempt)) {
            return(NULL)
        }
    }
    table <- mapping %>% dplyr::right_join(spec, c("domain", 
        "col_key")) %>% mutate(col_value = ifelse(is.na(.data$col_value) & 
        domain == "dfInput" & .data$col_key == "strGroupCol", 
        "SiteID", .data$col_value))
    knitr.kable.NA <- options(knitr.kable.NA = "")
    on.exit(knitr.kable.NA)
    col_name_dict <- c(domain = "Domain", col_key = "Column Key", 
        col_value = "Default Value", vRequired = "Required?", 
        vUniqueCols = "Require Unique Values?", vNACols = "Accept NA/Empty Values?")
    col_name_dict_bold <- paste0("**", col_name_dict, "**")
    names(col_name_dict_bold) <- names(col_name_dict)
    md <- knitr::kable(table, format = "markdown", col.names = col_name_dict_bold[names(table)]) %>% 
        paste(collapse = "\n")
    if (!is.null(header)) {
        md <- paste0(header, "\n\n", md)
    }
    writeLines(md, paste0(out_path, domain, ".md"))
    table
}
