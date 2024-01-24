function (flag_value, title = NULL) {
    if (is.na(flag_value)) {
        return(fontawesome::fa("minus", fill = "#aaa", title = title))
    }
    if (flag_value == -2) {
        a <- fontawesome::fa("angles-down", fill = "#FF5859", 
            title = title)
    }
    if (flag_value == -1) {
        a <- fontawesome::fa("angle-down", fill = "#FEAA02", 
            title = title)
    }
    if (flag_value == 0) {
        a <- fontawesome::fa("check", fill = "#3DAF06", title = title)
    }
    if (flag_value == 1) {
        a <- fontawesome::fa("angle-up", fill = "#FEAA02", title = title)
    }
    if (flag_value == 2) {
        a <- fontawesome::fa("angles-up", fill = "#FF5859", title = title)
    }
    return(a)
}
