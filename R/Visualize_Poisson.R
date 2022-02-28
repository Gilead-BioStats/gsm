#' Site-level visualization of site-level Poisson Model results
#'
#' @param dfFlagged analyze_poisson results with flags added.
#' @param unit exposure time unit. Defaults to "days".
#'
#' @return site level plot object
#'
#' @examples
#' dfInput <- AE_Map_Adam( safetyData::adam_adsl, safetyData::adam_adae )
#' dfTransformed <- Transform_EventCount( dfInput, cCountCol = 'Count', cExposureCol = "Exposure" )
#' dfAnalyzed <- Analyze_Poisson( dfTransformed)
#' dfFlagged <- Flag( dfAnalyzed , strColumn = 'Residuals', vThreshold =c(-5,5))
#' 

#' @import ggplot2
#'
#' @export
AE_Visualize <- function( dfFlagged, unit="days"){

  ### Calculate upper and lower boundaries
  dfBounds <- gsm::AE_Poisson_PredictBounds( dfFlagged )

  ### Plot of data
  p <- ggplot(
      dfFlagged,
      aes(
        x=LogExposure, 
        y=TotalCount, 
        color=as.factor(Flag))
    ) +
    # Formatting
    theme_bw() +
    scale_x_continuous(
      breaks=log(c(5,10,50, 100, 500, 1000, 5000, 10000)),
      labels=c(5,10,50, 100, 500, 1000, 5000, 10000)
    ) +
    theme(legend.position = "none") +
    scale_color_manual(
      breaks = c("0", "-1", "1"),
      values=c("#999999", "red", "red")
    ) +
    # Add chart elements
    geom_point() +
    xlab(paste0("Site Total Exposure (",unit," - log scale)")) +
    ylab("Site Total Events") +
    geom_line( data = dfBounds, aes( x = LogExposure, y = MeanCount), color="red") +
    geom_line( data = dfBounds, aes( x = LogExposure, y = LowerCount), color="red", linetype="dashed") +
    geom_line( data = dfBounds, aes( x = LogExposure, y = UpperCount), color="red", linetype="dashed") +
    geom_text(
        data = dfFlagged%>%filter(Flag !=0),
        aes( x = LogExposure, y = TotalCount, label = SiteID),
        vjust = 1.5,
        col="red",
        size=3.5
      )   
    
  
  return(p)
}

