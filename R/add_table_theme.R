function (x) {
    x %>% gt::tab_options(table.width = "80%", table.font.size = 14, 
        table.font.names = c("Roboto", "sans-serif"), table.border.top.style = "hidden", 
        table.border.bottom.style = "hidden", data_row.padding = gt::px(5), 
        column_labels.font.weight = "bold") %>% gt::cols_width(Parameter ~ 
        gt::pct(60), Value ~ gt::pct(40)) %>% gt::opt_row_striping()
}
