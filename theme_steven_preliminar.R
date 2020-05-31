
data(mtcars)
mtcars$cyl<-as.factor(mtcars$cyl)

library(ggplot2)
ggplot(mtcars) +
  aes(x = mpg, colour = cyl) +
  geom_histogram(bins = 30L, fill = "#ffffff") +
  scale_color_hue() +
  theme_minimal() +
  facet_wrap(vars(vs))+
  
  labs(x = "Number of seats won",
     y = "Party",
     title = "Victorian election 2018 lower house results",
     caption = "Data source: Victorian Electoral Commission") +
#   Mudando o fundo
  theme(plot.background=element_rect(fill="darkseagreen"),
#   theme(plot.background=element_rect(fill="red"),
      plot.margin = unit(c(1, 1, 1, 1), "cm")) #top, right, bottom, left



