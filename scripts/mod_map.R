# scripts/mod_map.R
pacman::p_load(shiny, leaflet, dplyr, sf, htmltools)

map_ui <- function(id, height = "70vh") {
  ns <- shiny::NS(id)
  leaflet::leafletOutput(ns("map"), height = height)
}

map_server <- function(id, world_sf, snapshot) {
  shiny::moduleServer(id, function(input, output, session) {
    
    # Base map with wrap-around (infinite east/west drag)
    output$map <- leaflet::renderLeaflet({
      shiny::req(world_sf)
      
      leaflet::leaflet(
        world_sf,
        options = leaflet::leafletOptions(
          worldCopyJump = TRUE,
          maxBoundsViscosity = 0
        )
      ) %>%
        leaflet::addProviderTiles(
          leaflet::providers$CartoDB.Positron,
          options = leaflet::providerTileOptions(noWrap = FALSE)
        ) %>%
        leaflet::setView(lng = 0, lat = 20, zoom = 2)
    })
    
    # Update polygons + legend when snapshot changes
    shiny::observeEvent(snapshot(), {
      dat <- snapshot()
      shiny::req(nrow(dat) > 0)
      
      # Ensure ISO2 uppercase to match Natural Earth
      dat <- dat %>%
        dplyr::mutate(country_code = toupper(country_code))
      
      joined <- world_sf %>%
        dplyr::left_join(
          dat %>% dplyr::select(country_code, country_label, mean_value, date),
          by = c("iso_a2" = "country_code")
        )
      
      vals <- joined$mean_value
      pal <- leaflet::colorNumeric("YlOrRd", domain = vals, na.color = "#D9D9D9")
      
      label <- sprintf(
        "%s<br/>Value: %s µg/m³<br/>Date: %s",
        dplyr::coalesce(joined$name_long, joined$admin, joined$iso_a2),
        ifelse(is.na(joined$mean_value), "NA", round(joined$mean_value, 2)),
        ifelse(is.na(joined$date), "NA", format(joined$date, "%Y-%m"))
      ) %>% lapply(htmltools::HTML)
      
      leaflet::leafletProxy(session$ns("map"), session = session, data = joined) %>%
        leaflet::clearShapes() %>%
        leaflet::clearControls() %>%
        leaflet::addPolygons(
          fillColor = ~pal(mean_value),
          fillOpacity = 0.8,
          color = "#666666",
          weight = 0.4,
          opacity = 1,
          label = label,
          highlightOptions = leaflet::highlightOptions(
            weight = 1.5,
            color = "#222222",
            fillOpacity = 0.9,
            bringToFront = TRUE
          )
        ) %>%
        leaflet::addLegend(
          position = "bottomright",
          pal = pal,
          values = vals,
          title = "Latest value",
          opacity = 0.9
        )
      
    }, ignoreInit = FALSE)
    
  })
}
