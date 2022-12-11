#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(markdown)
library(maps)
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(plotly)
library(shinythemes)

# library("rsconnect")

source("app_server.R")
source("app_ui.R")

shinyApp(ui = ui, server = server)
