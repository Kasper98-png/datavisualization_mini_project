# page_data_investigator_UI
# This is a page module. Typically page modules have a contain (mainPanel)
# and define what goes on inside that page. Page modules may also render
# text or plot graphs, but can also delegate that to submodules.
distribution_plots_UI <- function(id) {
  ns = NS(id)
  list(
    fluidRow(tags$h3("Distributions plots"),
             column(8, plotly_histogram_UI("histogram_plot")),
             column(8, plotly_violin_UI("violin_plot"))
             )
    )
}

distribution_plots <- function(input, output, session, df, meta) {
  ns <- session$ns
  
  callModule(plot_plotly_histogram, "histogram_plot", df)
  callModule(plot_plotly_violin, "violin_plot", df)
}