# plot_ggplot_UI
# This is the UI function of our module.
# It works similar to ui.R, except when creating outputs
# you have to remember to encapsulate them with ns()
# ns() concatenates the module ID to your outputs.

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

# plot_ggplot
# This is our server function of the module.
# Beyond storing the namespace, all computations must happen inside the
# plotlyOutput reactive context.
plot_plotly <- function(input, output, session, df) {
  ns <- session$ns
  
  output$point_plot <- renderPlotly({
    #validate() ensures that our code is only executed if the dataframe
    # is available. The dataframe may not be present if the user hasnt uploaded
    # any csv file yet. The "vis" errorClass is used to show where the plot will
    # be plotted (optional).
    validate(need(df(), "Waiting for data."), errorClass = "vis")
    # To read the reactive dataframe 'df', we need to "evaluate" it.
    # We do this by calling it as a function df(). 
    df_vis <- df()
    # Now we can create a plot of the data.
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
