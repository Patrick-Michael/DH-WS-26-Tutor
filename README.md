# DH-WS-26-Tutor

A tutorial-style R project designed to demonstrate a clean and practical project structure for data cleaning, analysis, and visualization using R and Shiny.

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
│   ├── world_air_quality.csv
│   ├── clean_world_air_quality.rds
│   └── visualization_world_air_quality.rds
├── .gitignore
├── R - Tutor demo.Rproj
```


The `app.R` file serves as the single entry point for the Shiny application and sources the required scripts from the `scripts/` directory.

The `scripts/` folder contains both tutorial-style data processing scripts and modular Shiny components.  
While not all scripts are required at runtime, they are included to illustrate how data cleaning, analysis, and visualization logic can be separated within a single project.

The `data/` directory contains the raw input data as well as intermediate and final datasets used for analysis and visualization. All data in this project is synthetic and provided solely for instructional purposes.

