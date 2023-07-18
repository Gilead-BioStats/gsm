get_timeline <- function(study, n_breaks = 10, x_axis_label_format = "%b\n%Y"){
# function to extract date columns
is.convertible.to.date <- function(x) !is.na(as.Date(as.character(x), tz = 'UTC', format = '%Y-%m-%d'))

# pull date columns and adjust label positions (case_when wasn't working for mutating disp for some reason)
d <- data %>%
     select_if(is.convertible.to.date(.)) %>%
     pivot_longer(everything(), names_to = "activity", values_to = "date") %>%
     mutate(date = as.Date(date)) %>%
     {if(nrow(.) %% 3 == 0) {
         mutate(., disp = rep(c(1, .75, .5), nrow(.)/3))
     } else if(nrow(.) %% 3 == 1){
         mutate(., disp = c(rep(c(1, .75, .5), floor(nrow(dat)/3)), 1))
     } else if(nrow(.) %% 3 == 2){
         mutate(., disp = c(rep(c(1, .75, .5), floor(nrow(.)/3)), 1, .75))
     }} %>%
     mutate(disp = ifelse(row_number()%% 2 == 0, disp * -1, disp))

# Define x axis breaks
breaks <- pretty(seq(min(d$date), max(d$date), by = "month"), n_breaks)

# Define blank plot theme
empty <- function()(theme(plot.background = element_rect(fill = "white"),
                          panel.background = element_rect(fill = "white"),
                          legend.position = "none",
                          axis.title = element_blank(),
                          axis.text.y = element_blank(),
                          axis.ticks.y = element_blank(),
                          axis.line = element_blank(),
                          axis.ticks.x = element_blank(),
                          axis.text.x = element_text(size = 10, vjust = 70, face = "bold")))

# Generate Plot
ggplot(d, aes(date, disp)) +
    geom_lollipop(point.size = 1,
                  aes(color = as.factor(date))) +
    geom_segment(aes(x = min(date) - months(1), xend = max(date) + (as.numeric(max(date) - min(date)) *.1),
                     y = 0, yend = 0, alpha = .5),
                 linewidth = 2,
                 color = "dodgerblue",
                 arrow = grid::arrow(length = unit(0.1, "inches")),
                 lineend = "round") +
    geom_point(aes(x = min(date) - months(1), y = 0), size = 2) +
    scale_x_date(date_labels = x_axis_label_format,
                 breaks = breaks,
                 expand = c(.2, -.2)) +
    geom_text(aes(x = date, y = disp, label = paste0(activity, '\n', "(", date, ")")), d = d,
              hjust = 0, size = 3) +
    ggtitle(data$protocol_title,
            subtitle = paste0("Date generated: " , Sys.Date())) +
    expand_limits(y = c(1.35,-1.2)) +
    empty()
}


