#' Load assessments from a package/directory
#'
#' @details
#'
#' Coming soon
#' 
#' @param path location of assessment yaml files. If package is specified looks in /inst folder.
#' @param package package with assessments
#'
#' @examples
#'  makeAssessmentList(path="assessments", package="gsm")
#'
#' @return A list of assessments
#' 
#' @export

makeAssessmentList <- function(path="assessments", package="gsm"){
    if(!is.null(package)){
        path <- system.file(path, package = 'gsm')
    }
    
    yaml_files <- list.files(path,  pattern = "\\.yaml$",full.names=TRUE)

    #copied from tools package
    file_path_sans_ext <-function (x) {
        sub("([^.]+)\\.[[:alnum:]]+$", "\\1", x)
    }
    
    assessments <- yaml_files %>% 
    map(function(path){
        assessment<-read_yaml(path)
        assessment$path <- path
        if(!hasName(assessment,"name")){
            assessment$name <- path %>% file_path_sans_ext %>% basename        
        }
        return(assessment)
    })
    names(assessments) <- assessments %>% map_chr(~.x$name)
    return(assessments)
}