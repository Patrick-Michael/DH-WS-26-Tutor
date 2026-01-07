
# --- Loading Libraries ----

pacman::p_load(tidyverse,  
               janitor)    #Basic cleaning setup


# --- Input File ----
               

dataset <-read.csv("data/world_air_quality.csv", #Relative file path to avoid errors
                   sep = ";"                   ) #European CSV format 






# --- Sanity Check Functions ----

glimpse(dataset)    #Take a look on the vectors, data types, values present inside the data

summary(dataset$value) #Summarize the data in general or a chosen vector

ncol(dataset) #Show the number of columns in our data set

sum(is.na(dataset$location_label)) #Count N/A in a vector(column)

unique(dataset$value[dataset$value<0])   #Show unique values in a vector(column)

unique(dataset$unit[dataset$pollutant == "PM1"])

summary(dataset$value[dataset$pollutant =="CO"]) #Summarize the data that intersects these two vectors

# --- Cleaning Pipeline ----


dataset <- dataset                %>%  #Initiate cleaning pipeline to remove possible
  janitor::clean_names()          %>%  #Clean names of columns (lowercase and no space)
  janitor::remove_empty("rows")   %>%  #remove empty vectors
  janitor::remove_empty("cols")   %>% 
  mutate_if(is.character, list(~na_if(.,"")))          %>%  #Replace empty cells for character type data with NA to avoid errors
  tidyr::separate_wider_delim(cols =  coordinates,
                              delim = ", " , 
                              names = c("lat", "lon")) %>%  #Separate coordinates into latitude and longitude for easier mapping
  mutate(lat = as.numeric(lat), lon = as.numeric(lon)) %>%  #Convert the newly formed columns into numeric structure
  mutate(location_label = coalesce(city, location, 
                                   country_label,
                                   "Unknown"))         %>%  #Create a uniform labeling column for further use in mapping visualization
  mutate(last_updated = parse_datetime(last_updated,        #Convert last_updated character column into real date time format in UTC
                       locale = locale(tz = "UTC")))   %>%
  filter(pollutant %in% c("NO2" ,"PM1" ,
                          "O3" , "PM2.5" ,                   #Filter our data by the specific pollutants we are interested in and discard the rest
                          "SO2" , "CO"))               %>%             
  filter(value >=0)                                    %>%   #Impose physical limits on values to ensure validity
  filter(!(value > 1e6 & unit == "ppm"))               %>%
  filter(!(value > 1.2e9 & unit == "µg/m³"))           %>% 
  filter(!(pollutant %in% c("PM1", "PM2.5") & unit == "ppm")) #Filter out unconvertable data


# --- Export Clean File for Further Analysis ----

#readr::write_csv(dataset, file = "data/clean_world_air_quality.csv")

#readr::write_rds(dataset, file = "data/clean_world_air_quality.rds")
