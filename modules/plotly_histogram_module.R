# plot_ggplot_UI
# This is the UI function of our module.
# It works similar to ui.R, except when creating outputs
# you have to remember to encapsulate them with ns()
# ns() concatenates the module ID to your outputs.

plotly_histogram_UI <- function(id) {
  ns = NS(id)
  list(
    fluidRow(
      plotlyOutput(ns("histogram_plot")),
      sliderInput(ns("slider2x"), "Range of x-axis", value = c(0,8000000), min = 0, max = 8000000, step = 1000000)
    )
  )
}

plot_plotly_histogram <- function(input, output, session, df) {
  ns <- session$ns
  
  output$histogram_plot <- renderPlotly({
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
      filter(input$slider2x[1] < avail_seat_km_per_week/1000 & avail_seat_km_per_week/1000 < input$slider2x[2])
    hist1 = df_vis %>%
      plot_ly(x = ~avail_seat_km_per_week/1000, type = "histogram") %>%
      layout(title = "Histogram of available seat distance per week measured in 1000",
             xaxis = list(title = "Available seat distancen per week (1000)"))
    
    return(hist1)
  })
  
}