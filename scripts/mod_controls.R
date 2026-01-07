# scripts/mod_controls.R
# Controls module (latest-map mode):
# - Pollutant dropdown only
# Returns:
#   list(pollutant = reactive(character(1)))

pacman::p_load(shiny)

controls_ui <- function(id,
                        pollutants = NULL,
                        default_pollutant = NULL) {
  ns <- shiny::NS(id)
  
  # Fallback to global `visual` if pollutants not provided
  if (is.null(pollutants)) {
    if (!exists("visual", inherits = TRUE)) {
      stop("controls_ui(): Provide `pollutants` or define global `visual`.", call. = FALSE)
    }
    pollutants <- sort(unique(get("visual", inherits = TRUE)$pollutant))
  }
  
  if (is.null(default_pollutant)) default_pollutant <- pollutants[1]
  
  shiny::tagList(
    shiny::selectInput(
      inputId  = ns("pollutant"),
      label    = "Pollutant",
      choices  = pollutants,
      selected = default_pollutant
    )
  )
}

controls_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    list(
      pollutant = shiny::reactive({ input$pollutant })
    )
  })
}
