library(tidyverse)
library(plotly)
library(shiny)
library(shinyjs)

# 1) SET R OPTIONS
# Sometimes R defaults are not ideal for the app we use.
# shiny.fullstacktrace: prints full error messages from R Shiny for debugging.
# digits.secs: Show milliseconds in timestamps.
# shiny.maxRequestSize: increase maximum file upload size to 50MB.
options(shiny.fullstacktrace=TRUE)
options("digits.secs"=6)
options(shiny.maxRequestSize=50*1024^2)

# 2) IMPORT MODULES
# Importing a module makes it callable in the R Shiny application.
source("modules/data_import_module.R", local = T)
source("modules/plotly_point_module.R", local = T)
source("modules/plot_linked_module.R", local = T)
source("modules/page_linked_plots_module.R", local = T)
source("modules/violin_plot_module.R", local = T)