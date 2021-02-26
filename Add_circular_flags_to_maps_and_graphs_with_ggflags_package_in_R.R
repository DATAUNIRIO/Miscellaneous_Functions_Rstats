https://rforpoliticalscience.com/2020/12/22/add-flags-to-graphs-with-ggimage-package-in-r/
https://rforpoliticalscience.com/2020/12/28/add-flags-to-maps-in-r/
  https://rforpoliticalscience.com/2021/01/13/add-circular-flags-to-maps-and-graphs-with-ggflag-package-in-r/
  
  
library(ggflags)
library(bbplot) # for pretty BBC style graphs
library(countrycode) # for ISO2 country cod
library(rvest)

coord <- read_html("https://developers.google.com/public-data/docs/canonical/countries_csv")

coord_tables <- coord %>% html_table(header = TRUE, fill = TRUE)

coord <- coord_tables[[1]]

map_df2 <- merge(map_df, coord, by.x= "iso_a2", by.y = "country", all.y = TRUE)
