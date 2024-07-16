#' Helper function to compile "wide" group metadata
#'
#' Used convert metadata dictionary (dfMeta) to a wide format data frame for use in charts and reports. 
#'
#' @param dfMeta The meta data dictionary with one row per GroupID per Param. Must have columns GroupID, GroupLevel, Param, and Value.
#' @param strGroupLevel A string specifying the group level; used to filter dfMeta$GroupLevel. 
#'
#' @return A long format data frame.
#'
#' @export

MakeWideGroups <- function(dfMeta, strGroupLevel){
   stopifnot(all(c("GroupID","GroupLevel","Param","Value") %in% names(dfMeta)))
    dfMeta <- dfMeta %>% filter(GroupLevel == strGroupLevel)
    df_wide <- pivot_wider(
        dfMeta,
        names_from=Param, 
        values_from=Value
    )

    return(df_wide)
}
