
# devtools::install_github("wilkox/ggfittext")

library(ggplot2)
library(ggfittext)

ggplot(altitudes, aes(x = craft, y = altitude, label = altitude)) +
  geom_col(fill="darkblue") +
  geom_bar_text()