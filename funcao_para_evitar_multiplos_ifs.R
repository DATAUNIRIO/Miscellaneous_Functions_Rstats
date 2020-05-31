

# MELHOR QUE O IF_ELSE

x <- 1:50
library(dplyr)
case_when(
  x %% 35 == 0 ~ "esse seria o primeir if",
  x %% 5 == 0 ~ " esse seria o segundo if",
  x %% 7 == 0 ~ "esse seria o terceiro if",
  TRUE ~ as.character(x)
)


# case_when is particularly useful inside mutate when you want to
# create a new variable that relies on a complex combination of existing
# variables
starwars %>%
  select(name:mass, gender, species) %>%
  mutate(
    type = case_when(
      height > 200 | mass > 200 ~ "large",
      species == "Droid"        ~ "robot",
      TRUE                      ~ "other"
    )
  )

