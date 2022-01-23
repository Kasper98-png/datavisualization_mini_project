# plot_linked_UI
# This is the UI function of our module.
# It works similar to ui.R, except when creating outputs
# you have to remember to encapsulate them with ns()
# ns() concatenates the module ID to your outputs.

plot_linked_UI <- function(id) {
  ns = NS(id)
  fluidRow(
    h6("The two plots below are linked, which means that you can select points (airlines) in the upper plot and the bottom plot will show information about those points (airlines)."),
    h6("Tasks: What is the effect of ASK per week on number of incidents?"),
    h6("When interacting with the linked plots, which airline has the biggest difference in incidents?"),
    h6("What is the difference in incidents of SAS?"),
    h6("What is the approximate difference in incidents for an airline with greater than 5B ASK per week?"),
    selectInput(ns("search"), "Select specific airlines:",
                choices = c("Show all" = "Show all", "Aer Lingus", "Aeroflot*", "Aerolineas Argentinas", "Aeromexico*", "Air Canada", "Air France", "Air India*",
                            "Alaska Airlines*", "Alitalia", "All Nippon Airways", "American*", "Austrian Airlines", "Avianca", "British Airways*",
                            "China Airlines", "Condor", "COPA", "Delta / Northwest*", "Egyptair", "El Al", "Ethiopian Airlines", "Finnair", 
                            "Garuda Indonesia", "Gulf Air", "Hawaiian Airlines", "Iberia", "Japan Airlines", "Kenya Airways", "KLM*",
                            "Korean Air", "LAN Airlines", "Lufthansa*", "Malaysia Airlines", "Pakistan International", "Philippine Airlines",
                            "Qantas*", "Royal Air Maroc", "SAS*", "Saudi Arabian", "Singapore Airlines", "South African", "Southwest Airlines",
                            "Sri Lankan / AirLanka", "SWISS*", "TACA", "TAM", "TAP - Air Portugal", "Thai Airways", "Turkish Airlines", "United / Continental*",
                            "US Airways / America West*", "Vietnam Airlines", "Virgin Atlantic", "Xiamen Airlines"),
                selected = "Show all",
                multiple = TRUE),
    column(12, plotlyOutput(ns("seatkm"))),
    column(12, plotlyOutput(ns("diff_inc")))
  )
}

# This is our server function of the module.
# Beyond storing the namespace, all computations must happen inside the
# plotlyOutput reactive context.
plot_linked <- function(input, output, session, df) {
  ns <- session$ns
  
  output$seatkm <- renderPlotly({
    #validate() ensures that our code is only executed if the dataframe
    # is available. The dataframe may not be present if the user hasnt uploaded
    # any csv file yet. The "vis" errorClass is used to show where the plot will
    # be plotted (optional).
    validate(need(df(), "Waiting for data."), errorClass = "vis")

    # To read the reactive dataframe 'df', we need to "evaluate" it.
    # We do this by calling it as a function df(). 
    df_vis <- df()
    df_vis$rowID <- 1:nrow(df_vis)
    
    choice = input$search
    # To link scatter plot to bar plot we need to use "event_register()" and
    # specify what interaction we want to link. "plotly_selecting" sends
    # events everytime you make a selection and drag over an item.
    if ("Show all" %in% choice | is.null(choice)){plot = df_vis %>%
      plot_ly(x = ~avail_seat_km_per_week) %>%
      add_markers(y = ~incidents_85_99, text = ~airline, type = "scatter", name = "Incidents in 1985-1999") %>%
      add_markers(y = ~incidents_00_14, text = ~airline, type = "scatter", name = "Incidents in 2000-2014") %>%
      layout(dragmode = "select", clickmode = 'event+select' ) %>%
      layout(title = "Incidents vs Available seat km per week",
             xaxis = list(title = "Available seat km per week"),
             yaxis = list(title = "Incidents")) %>%
      event_register("plotly_selecting")
    
    return(plot)}
    else {plot = df_vis %>%
      filter(airline %in% choice) %>%
      plot_ly(x = ~avail_seat_km_per_week) %>%
      add_markers(y = ~incidents_85_99, text = ~airline, type = "scatter", name = "Incidents in 1985-1999") %>%
      add_markers(y = ~incidents_00_14, text = ~airline, type = "scatter", name = "Incidents in 2000-2014") %>%
      layout(dragmode = "select", clickmode = 'event+select' ) %>%
      layout(title = "Incidents vs Available seat km per week",
             xaxis = list(title = "Available seat km per week"),
             yaxis = list(title = "Incidents")) %>%
      event_register("plotly_selecting")
    
    return(plot)}
  })

    
  output$diff_inc <- renderPlotly({
    #validate() ensures that our code is only executed if the dataframe
    # is available. The dataframe may not be present if the user hasnt uploaded
    # any csv file yet. The "vis" errorClass is used to show where the plot will
    # be plotted (optional).
    validate(need(df(), "Waiting for data."), errorClass = "vis")
    
    # To read the reactive dataframe 'df', we need to "evaluate" it.
    # We do this by calling it as a function df(). 
    df_vis <- df()
    df_vis$rowID <- 1:nrow(df_vis)
    df_vis$incidents_difference = df_vis$incidents_00_14-df_vis$incidents_85_99
    
    choice = input$search
    
    select.data <- event_data(event = "plotly_selecting")
    
    if (!is.null(select.data)) {
      if (class(select.data) != class(list())){
        select.data = select.data %>% filter(select.data$curveNumber == 0||select.data$curveNumber == 1)
        df_vis = df_vis %>% filter(rowID %in% (select.data$pointNumber+1))
      }
    }
    else if(!("Show all" %in% choice)){
      df_vis = df_vis %>% filter(airline %in% choice)
    }
    
    barplot = df_vis %>%
      plot_ly(x = ~airline, y = ~incidents_difference, type = "bar") %>%
      layout(title = "Difference in incidents",
             xaxis = list(title = "Airline"),
             yaxis = list(title = "Difference in Incidents"))
    
    return(barplot)
  })
  
}