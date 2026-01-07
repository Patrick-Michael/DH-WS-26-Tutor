# scripts/app.R
pacman::p_load(shiny, dplyr)

source("scripts/data.R")
source("scripts/mod_controls.R")
source("scripts/mod_map.R")
source("scripts/mod_bars.R")

ui <- fluidPage(
  titlePanel("Air Pollution Dashboard (Latest Available by Country)"),
  sidebarLayout(
    sidebarPanel(
      controls_ui(
        id = "controls",
        pollutants = pollutants,
        default_pollutant = pollutants[1]
      ),
      tags$hr(),
      tags$strong("Coverage"),
      textOutput("coverage_txt"),
      tags$strong("Median latest date"),
      textOutput("median_date_txt")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          "Map",
          map_ui("map")
        ),
        tabPanel(
          "Top / Bottom 5",
          bars_ui("bars", height = 420)
        )
      )
    )
    
  )
)

server <- function(input, output, session) {
  
  ctrl <- controls_server("controls")
  
  # Total possible countries in the map (valid ISO2 only)
  coverage_total <- sum(!is.na(world_sf$iso_a2) & world_sf$iso_a2 != "-99")
  
  # Latest-available snapshot per country for the selected pollutant
  latest_snapshot <- reactive({
    req(ctrl$pollutant())
    
    dat <- visual %>%
      mutate(country_code = toupper(country_code)) %>%
      filter(pollutant == ctrl$pollutant(), !is.na(mean_value), !is.na(date)) %>%
      arrange(country_code, desc(date)) %>%
      group_by(country_code) %>%
      slice_head(n = 1) %>%
      ungroup()
    
    dat
  })
  
  # Coverage text: X / Y
  output$coverage_txt <- renderText({
    dat <- latest_snapshot()
    n <- dplyr::n_distinct(dat$country_code)
    paste0(n, " / ", coverage_total, " countries")
  })
  
  # Median latest date text
  output$median_date_txt <- renderText({
    dat <- latest_snapshot()
    if (nrow(dat) == 0) return("NA")
    as.Date(stats::median(dat$date)) |> format("%Y-%m")
  })
  
  # Render modules
  map_server("map", world_sf = world_sf, snapshot = latest_snapshot)
  bars_server("bars", snapshot = latest_snapshot)
}

shinyApp(ui, server)
