#' Helper function to compile "long" group metadata
#'
#' Used to format group-level metadata (dfGroups) for use in charts and reports. This function takes a data frame and a string specifying the group columns, and returns a long format data frame.
#'
#' @param df The input data frame.
#' @param strGroupCols A string specifying the group columns.
#'
#' @return A long format data frame.
#'
#' @examples
#' df <- data.frame(GroupID = c(1, 2, 3), Param1 = c(10, 20, 30), Param2 = c(100, 200, 300))
#' MakeGroupInfo(df, "GroupID")
#'
#' @export

MakeGroupInfo <- function(data, strGroupLevel, strGroupCols="GroupID"){
    param_cols <- names(data)[!(names(data) %in% strGroupCols)]
    data <- data %>% mutate(across(everything(), as.character))

    df_long <- pivot_longer(
        data, 
        cols = param_cols, 
        names_to = "Param", 
        values_to = "Value",
        values_transform = list(Value = as.character)
    )
    df_long <- df_long %>% mutate(GroupLevel = strGroupLevel)
    
    return(df_long)
}