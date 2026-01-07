# --- Loading Libraries ----

pacman::p_load(tidyverse, # A collection of useful packages such as lubridate, dplyr, and others we will use.
               rstatix    # IQR, outliers and extremes management 
               )


# --- Importing Clean File ---- 

c_data <- readr::read_rds("data/clean_world_air_quality.rds")


# --- Sanity Checks ----

#glimpse(dataset)    #Take a look on the vectors, data types, values present inside the data

#summary(dataset$value) #Summarize the data in general or a chosen vector

#ncol(dataset) #Show the number of columns in our data set

#sum(is.na(dataset$location_label)) #Count N/A in a vector(column)

#s <- c_data %>% filter(
  #c_data$pollutant %in% c("PM1", "PM2.5") &
   # c_data$unit == "µg/m³") #Check unchanged status for these pollutants
#names(c_data)
#?case_when

#unique(dataset$value[dataset$value<0])   #Show unique values in a vector(column)

#unique(dataset$pollutant)

#summary(c_data$value_ugm3[dataset$pollutant =="O3"]) #Summarize the data that intersects these two vectors

#class(c_data$last_updated)    #Check the class type and the time zone for our vector (last_updated)
#attr(c_data$last_updated, "tzone") #Stands for object attributes (parameters in other languages)



# --- Create Custom Function ----

ppm2ugm3 <- function(value, pollutant, unit){  #Create a function that takes in values from these 3 vectors
  
  mw <- c(              #List of the gases whose units require conversion
    "NO2" = 46.01,
    "SO2" = 64.07,
    "CO"  = 28.01,
    "O3"  = 48.00
  )
  
  case_when (unit == "ppm" & pollutant %in% names(mw) ~  #Our logical condition "if the function finds a pollutant in the list and the corresponding unit is ppm" etc
   value * 1000 * mw[pollutant] / 24.45,    #Our conversion formula taken from online sources (standard is ppb so we multiply our ppm by 1000)
  
  TRUE ~
   value) #Return the end result. Note that these results are not saved anywhere. We will need to use mutate() in the pipeline to save the results.
}


# --- Data Analysis ----

gas_pollutants <- c("NO2", "SO2", "CO", "O3")   #Group our desired pollutants for unit conversion

value_lookup <- tibble(                         #Create a look-up table to set numerical plausability limits for each pollutant
  pollutant = c( "NO2" , "SO2" ,  "PM2.5"  , "CO"  ,  "O3"   , "PM1"),
  cap_ugm3 = c(4000, 3000, 2000, 60000, 1200, 2000)
)                  

c_data <- c_data %>% 
  mutate(value_ugm3 = as.numeric(
    ppm2ugm3(value, pollutant, unit)))                  %>%  #Create a new column with the unified units (ugm3 - microgram per cubic meter) and make it numeric
  
  left_join(value_lookup, by = "pollutant")             %>%  #Join our new tibble and automatically fill in the max limit 
  mutate(above_limit = 
             (value_ugm3 > cap_ugm3))                   %>%  #Flag if a value exceeds plausibility limits
  filter(!above_limit)                                  %>%  #Select rows that do not exceed that limit
  
  mutate(month = lubridate::month(last_updated))        %>%  #Create a new column to collect the data month to help with further analysis
  group_by(pollutant,month,country_code)                %>%  
  mutate(extreme_value = is_extreme(value_ugm3))        %>%  #Find the extremes for flagging by utlizing IQR. Extremes are 3x IQR
  mutate(year = lubridate::year(last_updated))               #Create a new column to show year to help with visualization


v_data <- c_data %>%   #Create a new object ready for visualization
  filter(extreme_value == FALSE)                          %>% #Select our desired filter
  group_by(country_code, country_label, month, year, pollutant)        %>% #Group by our desired columns
  summarise(mean_value = mean(value_ugm3))                   #Create our summary
  
#extremes <- c_data %>% #Create a new object to document extremes 
 # filter(extreme_value | above_limit )                           %>% #Same as above just for documenting the extremes
  #group_by(country_label, month, year, pollutant)                    #Documented and discarded        
  
  


# --- Exporting Files for Documentation and Visualization ----

#readr::write_csv(v_data, "data/visualisation_world_air_quality.csv")
#readr::write_csv(extremes, "data/extremes.csv")  
#readr::write_csv(c_data, "data/c-data")

#readr::write_rds(v_data, "data/visualization_world_air_quality.rds")
