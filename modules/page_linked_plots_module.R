# page_data_investigator_UI
# This is a page module. Typically page modules have a contain (mainPanel)
# and define what goes on inside that page. Page modules may also render
# text or plot graphs, but can also delegate that to submodules.
page_linked_plots_UI <- function(id) {
  ns = NS(id)
  fluidPage(
    # Here we let a submodule do the graph plot for us.
    plot_linked_UI(ns("linked_plots"))
  )
}

page_linked_plots <- function(input, output, session, df, meta) {
  ns <- session$ns
  
  # Calling Plot Submodule Example
  callModule(plot_linked, "linked_plots", df)
}