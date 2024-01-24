function (dfInput, strCountCol, strGroupCol = "SiteID") {
    stopifnot(`dfInput is not a data frame` = is.data.frame(dfInput), 
        `strCountCol not found in input data` = strCountCol %in% 
            names(dfInput), `strCountCol is not numeric or logical` = is.numeric(dfInput[[strCountCol]]) | 
            is.logical(dfInput[[strCountCol]]), `NA's found in strCountCol` = !anyNA(dfInput[[strCountCol]]))
    dfTransformed <- dfInput %>% group_by(GroupID = .data[[strGroupCol]]) %>% 
        summarise(TotalCount = sum(.data[[strCountCol]])) %>% 
        mutate(Metric = .data$TotalCount) %>% select("GroupID", 
        everything())
    return(dfTransformed)
}
