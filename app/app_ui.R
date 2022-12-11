library(markdown)
library(maps)
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(plotly)
library(bslib)


source("app_server.R")

intro_panel <- tabPanel(
  "Introduction",
  h2("Introduction"),
  p("Ian Pascal Fink"),
  
  p("Over the past 50 years, carbon emissions have been increasing throughout the world. In this project, we will focus on which type of emissions are being produced the most by the country. Co2, methane, and greenhouse gases have been increasing due to the usage of fossil fuels. These fossil fuels are burned for energy that we use in our everyday lives such as electricity, gas, etc. Leading to the increase of carbon concentration in our air and thus, climate change. In this visualization, we hope to see any patterns relating to which countries are producing the most emissions. This will provide us with the necessary information relating to making steps towards slowing down these greenhouse gasses polluting the air.",

"As of 2021, the country that puts out the most C02 content is ", highest_recent_co2_country, "with ", highest_recent_co2_value, ".But when focusing on only total C02 oil content, the country that produces the most happens to be ", highest_recent_oil_co2_country, " with ", highest_recent_oil_co2_value, ".The year with the highest average number of c02 content produced from all countries is ", highest_average_co2_year, ".Comparing the change of c02 content of the last 30 years we see that 1990 average c02 content by year happened to be ", recent_average_co2_val, " and 2021 content was ", oldest_average_co2_val, ".Which would tell us that c02 content from the past 30 years has been steadily increasing globally.
")
)




co2_main_content <- mainPanel(
  plotlyOutput("co2map")
)




emissions_sidebar_content <- sidebarPanel(
  
  selectInput(
    "type",
    label = "Type of emission",
    choices = list(
      "Total C02 Emissions" = "co2",
      "oil co2" = "oil_co2",
      "methane" = "methane",
      "ghg" = "total_ghg"
    )
  ),
  sliderInput(
    "time",
    label = "Change year",
    min = 1990,
    max = 2021,
    value = 2005,
    sep = ""
  )
)



co2_map_panel <- tabPanel(
  "Emission Map",
  titlePanel("Choropleth map of co2"),
  p(" This emissions map allows us to visually see any patterns and trends related to total emissions produced by the country. When you adjust the years and change the type of emission the country doesn't necessarily change. The United States, India, China, and Russia all clear most countries related to total emissions. But when you adjust the years you can see the gradual increase throughout all countries across the world. It is not surprising that the United States is at the top of emissions due to us using a lot of transportation which burns lots of fossil fuels. But this visualization helps us confirm which countries deal with the most. It is evidently seen that a lot of the smaller countries produce a lot fewer emissions."),
  sidebarLayout(
    
    emissions_sidebar_content,
    
    co2_main_content
    
    
  )
  
)


ui <- navbarPage(
  "A5 assignment",
  theme = shinythemes::shinytheme("united"),
  intro_panel,
  co2_map_panel,
)


