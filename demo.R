library(dash)
library(dashCoreComponents)
library(ggplot2)
library(plotly)
library(purrr)
library(tidyverse)

test <- function(data, by='Overall', ascending=FALSE, show_n=10) {
    df_nation <- data %>% 
        group_by(Nationality) %>%
        summarise({{by}} := mean(obj[[{{by}}]])) %>%
        arrange(obj[[{{by}}]], ascending=FALSE) %>%
        head(show_n) 
    
    return(df_nation)
}
    
data <- read_csv('data/processed/processed_data.csv')
test(data)
