library(readxl)
library(tidyverse)
library(dplyr)
library(maps)
library(ggplot2)
library(plotly)

owid_co2_data <- read_excel("owid_co2.xlsx")



countries_co2_data <- owid_co2_data %>%
  filter(!(country %in% c("Africa", "Asia", "Asia (excl. China & India)", "EU-27", "World",
                                             "EU-28", "Europe", "Europe (excl. EU-27)",
                                             "Europe (excl. EU-28)", "International transport", 
                                             "KP Annex B", "Non-OECD", "North America", "Oceania",
                                             "North America (excl. USA)", "OECD", "Reunion", "Asia (GCP)",
                                             "South America", "Non KP Annex B", "Africa (GCP)", "Non-OECD (GCP)",
                                             "Upper-middle-income countries", "High-income countries", "OECD (GCP)",
                                             "Asia (excl. China and India)")))

countries_co2_data <- countries_co2_data %>% 
  mutate(country = str_replace(country, "United States", "USA"))
countries_co2_data <- countries_co2_data %>%
  filter(year >= 1990)


highest_recent_co2_country <- countries_co2_data %>%
  filter(year == 2021) %>%
  filter(co2 == max(co2, na.rm = TRUE)) %>%
  pull(country)

highest_recent_co2_value <- countries_co2_data %>%
  filter(year == 2021) %>%
  filter(co2 == max(co2, na.rm = TRUE)) %>%
  pull(co2)


highest_recent_oil_co2_country <- countries_co2_data %>%
  filter(year == 2021) %>%
  filter(oil_co2 == max(oil_co2, na.rm = TRUE)) %>%
  pull(country)

highest_recent_oil_co2_value <- countries_co2_data %>%
  filter(year == 2021) %>%
  filter(oil_co2 == max(oil_co2, na.rm = TRUE)) %>%
  pull(oil_co2)


highest_average_co2_year <- countries_co2_data %>%
  group_by(year) %>%
  summarize(avgco2 = mean(co2, na.rm = TRUE)) %>%
  filter(avgco2 == max(avgco2)) %>%
  pull(year)


recent_average_co2_val <- countries_co2_data %>%
  group_by(year) %>%
  summarize(avgco2 = mean(co2, na.rm = TRUE)) %>%
  filter(year == max(year)) %>%
  pull(avgco2)


oldest_average_co2_val <- countries_co2_data %>%
  group_by(year) %>%
  summarize(avgco2 = mean(co2, na.rm = TRUE)) %>%
  filter(year == min(year)) %>%
  pull(avgco2)


  
#highest_average_
  


world_data <- map_data("world")

build_co2_map <- function(dataset, time, type){


selected_year <- dataset %>%
  filter(year == time)
  #filter(year == 1991)


map_data <- world_data %>%
  left_join(. , selected_year, by = c("region"="country")) %>%
  mutate(co2 = replace_na(co2, 0),
         oil_co2 = replace_na(oil_co2, 0),
         methane = replace_na(methane, 0),
         total_ghg = replace_na(total_ghg, 0))




emissions_map <- ggplot() +
  geom_polygon(data = map_data,
               aes(fill = map_data[, type], 
                   x = long,
                   y = lat, 
                   group = group, 
                   text = paste0(region, "<br>",
                                 "Contents: ", map_data[, type])),
               size = 0, alpha = .9, color = "black"
  ) + 
  labs(title = "Emissions by Year/type") +
  theme_void() +
  scale_fill_gradient(name = "contents of selected emission ", 
                      trans = "pseudo_log",
                      breaks = c(0, 100, 2500),
                      labels = c(0, 100, 2500),
                      low =  "#F7BB97",
                      high = "#F95F02") +
  theme(panel.grid.major = element_blank(),
        axis.line = element_blank(),
        plot.title = element_text(face = "bold")) 

interactive_co2_map <- ggplotly(emissions_map, tooltip = "text") %>% 
  config(displayModeBar = F) %>% 
  layout(legend = list(x = .1, y = .9))

return(interactive_co2_map)
}

server <- function(input, output) {
  output$co2map <- renderPlotly({ 
    return(build_co2_map(countries_co2_data, input$time, input$type))
  }) 

  
}