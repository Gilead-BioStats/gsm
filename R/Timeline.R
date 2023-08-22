#' Create interactive timeline for study data
#'
#' @param study the table containing study data of interest
#' @param n_breaks the number of breaks to include in the x-axis. NOTE pretty breaks are used to assign break locations and may give more or less that the number of breaks specified.
#' @param date_format The format to apply to the x-axis labels
#'
#' @return `plot` interactive timeline plot.
#'
#' @examples
#' Make_Timeline(clindata::ctms_study)
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom gggenes geom_gene_arrow
#' @importFrom ggiraph geom_point_interactive girafe
#' @importFrom tidyr pivot_longer
#'
#' @export

Make_Timeline <- function(study, n_breaks = 10, date_format = "%b\n%Y") {
  # pull date columns and adjust label positions (case_when wasn't working for mutating disp for some reason)
  d <- study %>%
    mutate(across(
      everything(),
      ~ as.Date(as.character(.), tz = "UTC", format = "%Y-%m-%d")
    )) %>%
    select_if(!is.na(.))

  if (ncol(d) > 1) {
    d <- d %>%
      tidyr::pivot_longer(everything(), names_to = "activity", values_to = "date") %>%
      mutate(
        date = as.Date(.data$date),
        estimate = grepl("est", .data$activity),
        disp = case_when(
          grepl("\n", date_format) & .data$estimate ~ 3.75,
          grepl("\n", date_format) &
            !.data$estimate ~ -3.75,
          !grepl("\n", date_format) &
            .data$estimate ~ 2.7,
          !grepl("\n", date_format) &
            !.data$estimate ~ -2.7
        ),
        label = case_when(
          grepl("fpfv", .data$activity) ~ "First Patient First Visit",
          grepl("lpfv", .data$activity) ~ "Last Patient First Visit",
          grepl("lplv", .data$activity) ~ "Last Patient Last Visit",
          TRUE ~ .data$activity
        )
      )

    # Define x axis breaks
    breaks <- pretty(seq(min(d$date), max(d$date), by = "day"), n_breaks)

    # Define blank plot theme
    empty <- function() {
      (theme(
        plot.background = element_rect(fill = "white"),
        panel.background = element_rect(fill = "white"),
        legend.position = c(0.5, 0.425),
        legend.key = element_rect(fill = "white"),
        legend.text.align = 0,
        legend.direction = "horizontal",
        legend.text = element_text(size = 8),
        legend.margin = margin(
          t = 1,
          r = 1,
          b = 1,
          l = 1,
          unit = "mm"
        ),
        legend.box.background = element_rect(fill = "white", color = "black"),
        legend.spacing.y = unit(0, "cm"),
        axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.line = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank()
      ))
    }

    # Generate Plot
    a <- ggplot(d, aes_string(d$date, d$disp)) +
      scale_x_date(
        date_labels = date_format,
        limits = c(
          min(d$date) - (as.numeric(max(d$date) - min(d$date)) * .1),
          max(d$date) + (as.numeric(max(d$date) - min(d$date)) * .1)
        ),
        expand = c(.15, -.15)
      ) +
      gggenes::geom_gene_arrow(
        aes(
          xmin = min(date) - (as.numeric(max(date) - min(date)) * .1),
          xmax = max(date) + (as.numeric(max(date) - min(date)) * .1),
          y = 0
        ),
        color = "dodgerblue",
        arrowhead_height = unit(15, "mm"),
        arrow_body_height = unit(ifelse(grepl("\n", date_format), 10, 7), "mm")
      ) +
      ggiraph::geom_point_interactive(
        aes(
          color = .data$label,
          shape = .data$estimate
        ),
        size = 3
      ) +
      scale_shape_manual(values = c(19, 1), labels = c("Actual", "Estimated")) +
      annotate(geom = "text", x = breaks, y = 0, label = format(breaks, format = date_format), size = 3, fontface = 2) +
      expand_limits(y = c(30, -50)) +
      guides(
        alpha = "none",
        shape = guide_legend(title.position = "top"),
        color = guide_legend(
          ncol = 3,
          title.position = "top"
        )
      ) +
      labs(
        shape = "Fill/Empty",
        color = "Legend"
      ) +
      empty()

    return(ggiraph::girafe(ggobj = a))
  } else {
    cli::cli_alert_warning("Could not detect any columns in date format.")
  }
}
