#' to plot the hydrograph of a watershed
#' @param data a data frame of date and hydrological time series, e.g., rainfall and runoff
#' @param time_series the name of the datetime column in the data
#' @param precip the name of the rainfall column in the data
#' @param streamflow the names of the observed and simulated runoff columns in the data
#' @param start the starting date to be ploted
#' @param end the ending date to be ploted
#' @param variable optional variable to sort streamflow data by
#' @return to plot the hydrograph and return NULL
hydrograph <- function(data, time_series, precip, streamflow, 
                       start = "1970-01-01", end = "2020-12-31",
                       variable = NULL) {
  
  require(lubridate)
  require(ggplot2)
  require(ggthemes)
  require(cowplot)
  
  time_series <- enquo(time_series)
  precip <- enquo(precip)
  streamflow <- enquo(streamflow)
  variable <- enquo(variable)
  
  data <- data %>%
    mutate(date = as_date(!!time_series)) %>%
    filter(between(date, as.Date(start), as.Date(end)))

  ## rain plot
  g.top <- data %>%
    distinct(as_datetime(date_time), .keep_all = TRUE) %>%
    ggplot(aes(x = !!time_series, y = !!precip)) +
    geom_col(fill = "steelblue1") +
    scale_y_continuous(trans = "reverse") +
    scale_x_datetime() +
    theme_bw(base_size = 11) +
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          plot.margin = unit(c(5.5, 5.5, 1, 5.5), units= "points"),
          axis.title.y = element_text(vjust = 0.3))+
    labs(y = "Rainfall (mm)")
  
  ## flow plot
    k <- data %>%
      summarise(max(!!streamflow)) %>%
      pull()
    k <- k * 1.1
    
    g.bottom <- data %>%
      ggplot(aes(x = !!time_series, y = !!streamflow, color = !!variable)) +
      geom_line(alpha = 0.7) +
      theme_bw(base_size = 11) +
      theme(plot.margin = unit(c(0,5,1,1), units="points"), 
            legend.position = c(0.15, 0.8),
            legend.title = element_blank()) +
      ggthemes::scale_color_hc() +
      ylim(c(0, k)) +
      labs(x = "Date", y = "Runoff (mm)")
  
  ## layout plots
  plots <- align_plots(g.top, g.bottom, align = "v", axis = "l")
  plot_grid(plots[[1]], plots[[2]], ncol=1, rel_heights = c(0.3, 0.7))

}