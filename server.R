shinyServer(function(input, output, session) {
  
  # 1) REACTIVE DATA STRUCTURE
  # Dataframes does not react to user input in R by default. Therefore we need to
  # hold our variables inside a special data structure called "reactiveValues".
  # In this example, we declare a dataframe 'df' and a string 'source'
  # which we initialize to NULL.
  r <- reactiveValues(df = NULL, source = NULL)
  
  # 2) CALL THE MODULES
  # We need to initialize the main modules of our R shiny application.
  csv_data <- callModule(data_import, "import_game_csv")
  callModule(plot_plotly, "point_plot", reactive(r$df))
  callModule(page_linked_plots, "linked_plot", reactive(r$df))
  callModule(plot_plotly_violin, "violin_plot", reactive(r$df))
  
  # 3) OBSERVE INCOMING DATA
  # To delegate the data to the rest of the application, server.R needs to 
  # observe incoming data, process it and pass it on as a data frame.
  # We do this by observing a "trigger", which is just an integer that
  # we increase every time a new change happens.
  observeEvent(csv_data$trigger, {
    req(csv_data$trigger > 0)
    r$df <- csv_data$df
    r$source <- csv_data$filename
  })
})