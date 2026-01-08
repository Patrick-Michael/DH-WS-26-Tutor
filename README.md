# DH-WS-26-Tutor

A tutorial-style R project designed to demonstrate a clean and practical project structure for data cleaning, analysis, and visualization using R and Shiny.

## Live Application
[![Launch Shiny App](https://img.shields.io/badge/Launch-Shiny%20App-blue?style=for-the-badge)](https://patrickmichael.shinyapps.io/AirPollutionVisualization/)



## Overview
This repository was created as a learning resource for beginners and students with basic R knowledge.  
It demonstrates how a single R project can be structured to support the full workflow of a small data task, from data preparation and analysis to interactive visualization.

The project uses synthetic data for demonstration purposes only and does not reflect real-world findings or analytical results. 

The accompanying Shiny application is publicly deployed and intended to be used by students as a hands-on example.

## Project Structure
The repository is organized to reflect a simple and transparent structure for an R project that covers data cleaning, analysis, and visualization using Shiny.

``` graphql
├── app.R                     # Main application entry point
├── scripts/                  # R scripts for data processing and Shiny modules
│   ├── data.R                # Data loading and preparation for visualization
│   ├── dataset_cleaning.R    # Data cleaning pipeline (tutorial example)
│   ├── dataset_analysis.R    # Data transformation and aggregation
│   ├── mod_controls.R        # Shiny UI controls
│   ├── mod_map.R             # Interactive map module
│   └── mod_bars.R            # Bar chart visualization module
├── data/                     # Input and processed datasets
│   ├── world_air_quality.csv               # Raw data
│   ├── clean_world_air_quality.rds         # Clean data ready for analysis
│   └── visualization_world_air_quality.rds # Final output to be used for visualization
├── .gitignore
├── R - Tutor demo.Rproj
```


The `app.R` file serves as the single entry point for the Shiny application and sources the required scripts from the `scripts/` directory.

The `scripts/` folder contains both tutorial-style data processing scripts and modular Shiny components.  
While not all scripts are required at runtime, they are included to illustrate how data cleaning, analysis, and visualization logic can be separated within a single project.

The `data/` directory contains the raw input data as well as intermediate and final datasets used for analysis and visualization. All data in this project is synthetic and provided solely for instructional purposes.

## Analytical Scope
The analytical scope of this project involves a **structured data preparation and validation workflow**.

The analysis pipeline demonstrated in this project includes:
- Cleaning and standardizing raw input data
- Handling missing values and inconsistent labeling
- Enforcing basic physical and unit-related plausibility constraints
- Converting pollutant measurements into a unified unit system where applicable
- Identifying and excluding extreme values using an interquartile range (IQR)–based approach
- Aggregating pollutant concentrations at the country level to produce summary statistics

Following preprocessing, the cleaned and validated data is summarized using mean values and prepared for visualization. These summaries are then used to generate country-level comparisons displayed through an interactive map and ranked bar charts.

The analysis is **descriptive and comparative in nature**. The Shiny application presents a snapshot derived from the processed dataset.

## Technologies Used
This project is implemented entirely in **R** and uses a small, focused set of packages to demonstrate common data analysis and visualization workflows.

### Core Language
- **R** – data cleaning, analysis, and application logic

### Data Wrangling and Analysis
- **tidyverse** – data manipulation, transformation, and aggregation
- **janitor** – cleaning and standardizing raw dataset structure
- **rstatix** – IQR-based detection of extreme values
- **lubridate** – handling and extracting date components

### Geospatial Data and Mapping
- **sf** – handling spatial data structures
- **rnaturalearth / rnaturalearthdata** – country-level polygon data for global mapping
- **leaflet** – interactive map visualization

### Visualization
- **plotly** – interactive bar charts and comparative visualizations

### Application Framework and Deployment
- **shiny** – interactive web application framework
- **shinyapps.io** – public deployment of the application



