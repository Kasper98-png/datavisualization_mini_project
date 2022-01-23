# plot_ggplot_UI
# This is the UI function of our module.
# It works similar to ui.R, except when creating outputs
# you have to remember to encapsulate them with ns()
# ns() concatenates the module ID to your outputs.

plotly_violin_UI <- function(id) {
  ns = NS(id)
  list(
    fluidRow(
      h6("Tasks: How was the development in number of different types of accidents between 1985-1999 to 2000-2014?"),
      h6("How did the decrease in number of fatal accidents affect the number of fatalities?"),
      column(12, plotlyOutput(ns("violin_plot"))),
      column(12, plotlyOutput(ns("violin_plot2"))),
      column(12, plotlyOutput(ns("violin_plot3")))
      )
  )
}

# plot_ggplot
# This is our server function of the module.
# Beyond storing the namespace, all computations must happen inside the
# plotlyOutput reactive context.
plot_plotly_violin <- function(input, output, session, df) {
  ns <- session$ns
  
  output$violin_plot <- renderPlotly({
    #validate() ensures that our code is only executed if the dataframe
    # is available. The dataframe may not be present if the user hasnt uploaded
    # any csv file yet. The "vis" errorClass is used to show where the plot will
    # be plotted (optional).
    validate(need(df(), "Waiting for data."), errorClass = "vis")
    
    # To read the reactive dataframe 'df', we need to "evaluate" it.
    # We do this by calling it as a function df(). 
    df_vis <- df()
    
    # Now we can create a plot of the data.
    violin1 = df_vis %>%
      plot_ly(y = ~incidents_85_99, type = "violin",
              x0 = "1985-1999",
              box = list(visible = T),
              meanline = list(visible = T),
              orientation = "v") %>%
      layout(title = "Distribution of number of incidents",
             yaxis = list(title = "n", range = c(0,81))) %>%
      add_trace(y = ~incidents_00_14, type = "violin",
              x0 = "2000-2014",
              box = list(visible = T),
              meanline = list(visible = T),
              orientation = "v") %>%
      hide_legend()
    
    return(violin1)
    })
    
    output$violin_plot2 <- renderPlotly({
      #validate() ensures that our code is only executed if the dataframe
      # is available. The dataframe may not be present if the user hasnt uploaded
      # any csv file yet. The "vis" errorClass is used to show where the plot will
      # be plotted (optional).
      validate(need(df(), "Waiting for data."), errorClass = "vis")
      
      # To read the reactive dataframe 'df', we need to "evaluate" it.
      # We do this by calling it as a function df(). 
      df_vis <- df()
      
      # Now we can create a plot of the data.
      violin2 = df_vis %>%
        plot_ly(y = ~fatal_accidents_85_99, type = "violin",
                x0 = "1985-1999",
                box = list(visible = T),
                meanline = list(visible = T),
                orientation = "v") %>%
        layout(title = "Distribution of number of fatal accidents",
               yaxis = list(title = "n", range = c(0,17))) %>%
        add_trace(y = ~fatal_accidents_00_14, type = "violin",
                  x0 = "2000-2014",
                  box = list(visible = T),
                  meanline = list(visible = T),
                  orientation = "v") %>%
        hide_legend()
      
      return(violin2)
    })
    
    
    output$violin_plot3 <- renderPlotly({
      #validate() ensures that our code is only executed if the dataframe
      # is available. The dataframe may not be present if the user hasnt uploaded
      # any csv file yet. The "vis" errorClass is used to show where the plot will
      # be plotted (optional).
      validate(need(df(), "Waiting for data."), errorClass = "vis")
      
      # To read the reactive dataframe 'df', we need to "evaluate" it.
      # We do this by calling it as a function df(). 
      df_vis <- df()
      
      # Now we can create a plot of the data.
      violin3 = df_vis %>%
        plot_ly(y = ~fatalities_85_99, type = "violin",
                x0 = "1985-1999",
                box = list(visible = T),
                meanline = list(visible = T),
                orientation = "v") %>%
        layout(title = "Distribution of number of fatalities",
               yaxis = list(title = "n", range = c(0,700))) %>%
        add_trace(y = ~fatalities_00_14, type = "violin",
                  x0 = "2000-2014",
                  box = list(visible = T),
                  meanline = list(visible = T),
                  orientation = "v") %>%
        hide_legend()
      
      return(violin3)
    })
}

