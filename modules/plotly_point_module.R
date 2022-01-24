# This is the UI function of the scatter plot module.
# It works similar to ui.R, except when creating outputs

plotly_point_UI <- function(id) {
  ns = NS(id)
  list(
    fluidRow(
      h6("Task: When looking at and interacting with the scatter plot below, does it seem like airlines have reduced the number of incidents from the period 1985-1999 to the period 2000-2014?"),
      plotlyOutput(ns("point_plot")),
      sliderInput(ns("slider1x"), "Range of x-axis", value = c(0,80), min = 0, max = 80, step = 5)
    )
  )
}

# This is the server function of the module.
plot_plotly <- function(input, output, session, df) {
  ns <- session$ns
  
  output$point_plot <- renderPlotly({
    #validate() ensures that our code is only executed if the dataframe
    # is available. The dataframe may not be present if the user has not uploaded
    # any csv file yet. The "vis" errorClass is used to show where the plot will
    # be plotted.
    validate(need(df(), "Waiting for data."), errorClass = "vis")
    
    # "Evaluate" the dataframe 'df in order to read it.
    df_vis <- df()
    
    # Now we can create a plot of the data.
    # Use slider values to filter data.
    df_vis = df_vis %>%
      filter(input$slider1x[1] < incidents_85_99 & incidents_85_99 < input$slider1x[2])
    model1 = lm(data = df_vis, incidents_00_14 ~ incidents_85_99)
    min_y = min(df_vis$incidents_00_14)
    max_y = max(df_vis$incidents_00_14)
    point1 = df_vis %>%
      plot_ly(x = ~incidents_85_99, y = ~incidents_00_14, type = "scatter", mode = "markers", name = "Airlines") %>%
      add_trace(x = ~incidents_85_99, y = fitted(model1), mode = "lines", name = "Linear model") %>%
      layout(title = "Correlation between number of incidents in 1985-1999 and 2000-2014",
             xaxis = list(title = "Incidents in 1985-1999"),
             yaxis = list(title = "Incidents in 2000-2014")) %>%
      add_lines(x = ~incidents_85_99, y = ~incidents_85_99, type = "line", name = "x=y") %>%
      layout(
        yaxis = list(
          range=c(min_y, max_y+3)
        )
      )
    
    return(point1)
  })
  
}
