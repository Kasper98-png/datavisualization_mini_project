# This is a page module. We collect the linked plots in a sub-page instead of
# putting them straight into the global UI.
page_linked_plots_UI <- function(id) {
  ns = NS(id)
  fluidPage(
    # Let a submodule do the graph plot
    plot_linked_UI(ns("linked_plots"))
  )
}

page_linked_plots <- function(input, output, session, df, meta) {
  ns <- session$ns
  
  # Calling plot_linked submodule 
  callModule(plot_linked, "linked_plots", df)
}