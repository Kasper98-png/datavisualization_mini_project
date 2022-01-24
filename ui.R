#The layout of the homepage and calls to sub-module UI's

shinyUI(
  fluidPage(title = "Flight safety",
    data_import_UI("import_game_csv"),
    h1("Has it become safer to use aerial transportation when comparing 1985-1999 with 2000-2014?"),
    navlistPanel(id = "pageChooser", well= FALSE, widths=c(2,5),
                 tabPanel("Homepage",
                          p("The variables from the data set, based on the Aviation Safety Network's database, used in the application is available seat km. per week, incidents, accidents, fatalities, and airline."),
                          p("Available seat km. per week (ASK per week) is a number for how many km. an airline has flown seats in a week as of December 2012. If an airline flew 10 seats for 100 km. in one week the ASK per week is 1000."),
                          p("Incidents is all incidents with or without fatalities and accidents is incidents with fatalities."),
                          p("The problem statement that the interactive plots in this application will help answer is:"),
                          p("Has it become safer to use aerial transportation and how can interactivity with data visualizations help answer this question?"),
                          p("The sub questions are:"),
                          p("What is the development in number of incidents?"),
                          p("How does available seat km. per week affect the number of incidents and at which value of available seat km. per week is the difference in number of incidents biggest?"),
                          p("The first thing to do is uploade the data file ('airline_safety.csv') from the folder with the script files.")),
                 tabPanel("Number of Incidents", plotly_point_UI("point_plot")),
                 tabPanel("ASK per week vs Incidents", page_linked_plots_UI("linked_plot")),
                 tabPanel("Distributions", plotly_violin_UI("violin_plot"))
    )
))
