
#Use geom_rect or geom_polygon from ggplot2 for shading effects
#by: Valentin Stefan
# fonte: https://rpubs.com/valentin/ggplot2-geoms-rect-polygon-shading-effects


#For problems with the code, please open an issue on GitHub here.

library(ggplot2)
library(dplyr)

theme_set(
  theme_bw() +
    theme(panel.grid.major = element_blank(),
          axis.text = element_text(size = 8))
)

# geom_rect

y_lim <- 20 # a custom threshold for the horizontal line

ggplot() +
  geom_point(data = mtcars,
             aes(x = hp, y = mpg)) +
  geom_hline(yintercept = y_lim) +
  # Shade area under y_lim
  geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = y_lim),
            alpha = 1/5,
            fill = "blue") +
  # Shade area above y_lim
  geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = y_lim, ymax = Inf),
            alpha = 1/5,
            fill = "red")

#geom_polygon

model <- lm(mpg ~ log(hp), data = mtcars) # some model

# Get the predictions for plotting. Here, df_line, is a data frame with new
# coordinates that will be used for plotting the trend line and further for
# building the polygons for shading.
min_x <- min(mtcars$hp)
max_x <- max(mtcars$hp)
df_line <- data.frame(hp = seq(from = min_x, to = max_x, by = 1))
df_line$mpg <- predict(model, newdata = df_line)

p <- ggplot() +
  geom_point(data = mtcars,
             aes(x = hp, y = mpg)) +
  geom_line(data = df_line,
            aes(x = hp, y = mpg))
p

df_poly_under <- df_line %>%
  tibble::add_row(hp = c(max_x, min_x),
                  mpg = c(-Inf, -Inf))

df_poly_above <- df_line %>%
  tibble::add_row(hp = c(max_x, min_x),
                  mpg = c(Inf, Inf))

p +  geom_polygon(data = df_poly_under,
               aes(x = hp, y = mpg),
               fill = "blue",
               alpha = 1/5) +
  geom_polygon(data = df_poly_above,
               aes(x = hp, y = mpg),
               fill = "red",
               alpha = 1/5)

#ggsave(filename = "shade-plot-background.png",
#         plot = last_plot(),
#         width = 10,
#         height = 6,
#         units = "cm",
#         dpi = 300)

