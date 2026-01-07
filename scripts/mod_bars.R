# scripts/mod_bars.R
# Top 5 + Bottom 5 bar chart module with:
# - always-visible labels (value + date)
# - hover tooltips (country + value + date)
# - stable subplot headers via annotations (no per-plot layout titles)
#
# Expects snapshot(): reactive data.frame/tibble with columns:
#   country_code, country_label, mean_value, date

pacman::p_load(shiny, dplyr, plotly)

bars_ui <- function(id, height = 520) {
  ns <- shiny::NS(id)
  plotly::plotlyOutput(ns("bars"), height = height)
}

bars_server <- function(id, snapshot) {
  shiny::moduleServer(id, function(input, output, session) {
    
    output$bars <- plotly::renderPlotly({
      dat <- snapshot()
      shiny::req(!is.null(dat), nrow(dat) > 0)
      
      dat2 <- dat %>%
        dplyr::filter(mean_value != 0) %>%
        dplyr::mutate(
          country_name = dplyr::coalesce(country_label, country_code),
          # Full hover (multi-line)
          hover = paste0(
            country_name,
            "<br>Value: ", round(mean_value, 2), " µg/m³",
            "<br>Date: ", format(date, "%Y-%m")
          ),
          # Always-visible label (keep it short)
          label = paste0(
            round(mean_value, 2), " µg/m³",
            "<br>", format(date, "%Y-%m")
          )
        )
      
      shiny::req(nrow(dat2) > 0)
      n_pick <- min(5L, nrow(dat2))
      
      top_df <- dat2 %>%
        dplyr::arrange(dplyr::desc(mean_value)) %>%
        dplyr::slice_head(n = n_pick) %>%
        dplyr::mutate(country_name = factor(country_name, levels = rev(country_name)))
      
      bottom_df <- dat2 %>%
        dplyr::arrange(mean_value) %>%
        dplyr::slice_head(n = n_pick) %>%
        dplyr::mutate(country_name = factor(country_name, levels = rev(country_name)))
      
      p_top <- plotly::plot_ly(
        data = top_df,
        x = ~mean_value,
        y = ~country_name,
        type = "bar",
        orientation = "h",
        # Always-visible labels
        text = ~label,
        textposition = "outside",
        cliponaxis = FALSE,
        # Hover tooltip
        hoverinfo = "text",
        hovertext = ~hover,
        name = "Top 5"
      ) %>%
        plotly::layout(
          xaxis = list(title = "Mean value (µg/m³)"),
          yaxis = list(title = "")
        )
      
      p_bottom <- plotly::plot_ly(
        data = bottom_df,
        x = ~mean_value,
        y = ~country_name,
        type = "bar",
        orientation = "h",
        # Always-visible labels
        text = ~label,
        textposition = "outside",
        cliponaxis = FALSE,
        # Hover tooltip
        hoverinfo = "text",
        hovertext = ~hover,
        name = "Bottom 5"
      ) %>%
        plotly::layout(
          xaxis = list(title = "Mean value (µg/m³)"),
          yaxis = list(title = "")
        )
      
      plotly::subplot(
        p_top, p_bottom,
        nrows = 2,
        shareX = TRUE,
        titleY = TRUE,
        margin = 0.12  # <- increases spacing between the two panels (use 0.08–0.18)
      ) %>%
        plotly::layout(
          showlegend = FALSE,
          # Give room for outside labels and headers (tweak if labels get clipped)
          margin = list(t = 70, r = 90, b = 40, l = 70),
          # Panel headers as annotations (keep y within 0..1 to avoid "out of bounds")
          annotations = list(
            list(
              text = "5 Most Polluted Countries",
              x = 0.5, y = 1.00,
              xref = "paper", yref = "paper",
              xanchor = "center", yanchor = "bottom",
              showarrow = FALSE,
              font = list(size = 18)
            ),
            list(
              text = "5 Least Polluted Countries",
              x = 0.5, y = 0.4,
              xref = "paper", yref = "paper",
              xanchor = "center", yanchor = "bottom",
              showarrow = FALSE,
              font = list(size = 18)
            )
          )
        )
    })
    
  })
}
