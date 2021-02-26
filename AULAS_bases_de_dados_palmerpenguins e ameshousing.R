#remotes::install_github("allisonhorst/palmerpenguins")

library(palmerpenguins)
data(package = 'palmerpenguins')
names(penguins)
names(penguins_raw)

library(AmesHousing)
ames <- 
  make_ames() %>% 
  # Remove quality-related predictors
  dplyr::select(-matches("Qu"))
