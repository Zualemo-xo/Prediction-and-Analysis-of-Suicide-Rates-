# init.R
#
# R code to install packages if not already installed
#


my_packages = c("plotly", "DT","shiny","tidyverse","caret","dplyr","ggplot2","plotly","treemapify","stringr","ggthemes","plotrix","shinythemes","data.table","shinydashboard")

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

invisible(sapply(my_packages, install_if_missing))
