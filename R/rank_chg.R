function (status) {
    if (status == 1) {
        logo_out <- fontawesome::fa("circle", fill = "green")
    }
    if (status == 2) {
        logo_out <- fontawesome::fa("circle", fill = "red")
    }
    if (status == 3) {
        logo_out <- fontawesome::fa("circle", fill = "#EED202")
    }
    gt::html(as.character(logo_out))
}
