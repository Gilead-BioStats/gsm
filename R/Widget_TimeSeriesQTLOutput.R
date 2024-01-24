function (outputId, width = "100%", height = "400px") {
    htmlwidgets::shinyWidgetOutput(outputId, "Widget_TimeSeriesQTL", 
        width, height, package = "gsm")
}
