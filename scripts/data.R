
#--- Load Libraries ----

pacman::p_load(tidyverse,
               rnaturalearth, #Globe scheme for visualization
               rnaturalearthdata,
               sf             #Companion library to help map countries and pollution
               )


# --- File Input ----

visual <- readr::read_rds("data/visualization_world_air_quality.rds")


# --- Sanity Checks ----

#v_data == visual #Check to see if both variables are identical (Logical T/F)


# --- Set up Visualization ----

visual <- mutate(visual,                     #Create a new date column to help create a "seek-bar" in our visual
                 date = as.Date(
                   sprintf("%04d-%02d-01", year, month))) 

pollutants <- sort(unique(visual$pollutant)) #List of pollutants for visualization
min_date <- min(visual$date, na.rm = TRUE)   #Starting date
max_date <- max(visual$date, na.rm = TRUE)   #Ending date
date_seq <- seq(min_date, max_date, by = "month")  #Sequence of dates to use in seek bar


# --- Load polygons (sf) ----

world_sf <- rnaturalearth::ne_countries(
  scale = "medium",       # "small" | "medium" | "large"
  returnclass = "sf"
)                         %>% 
  dplyr::filter(iso_a2 != "AQ")

#"iso_a2" %in% names(world_sf) #Check joining point between rnaturalearth and our data (country code 2 letters)
