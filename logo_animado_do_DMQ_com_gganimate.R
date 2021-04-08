# inspirtado em https://gist.github.com/emitanaka/6c654431a953e0ccde6fa0bdcc3ea608

library(gganimate)
library(tidyverse)

IBSlogo <- tribble(
  ~Row, ~Col, ~Fill, ~Text,
  3, 1, "#e0e2d5", "D",
  3, 2, "#05647a", "",
  3, 3, "#6db8bb", "", 
  2, 1, "#6db8bb", "", 
  2, 2, "#e0e2d5", "M", 
  2, 3, "#05647a", "", 
  1, 1, "#05647a", "", 
  1, 2, "#6db8bb", "", 
  1, 3, "#e0e2d5", "Q") 

getIBSlogowFrame <- function(frame, shuffle=TRUE) {
  if(shuffle) {
    IBSlogo %>% 
      mutate(Fill=sample(Fill),
             Frame=frame)
  } else {
    IBSlogo %>% 
      mutate(Frame=frame)
  }
}

set.seed(1)
df <- map2(1:10, c(rep(TRUE, 7), rep(FALSE, 3)), 
           getIBSlogowFrame) %>%
  plyr::ldply()

anim <- ggplot(df, aes(Col, Row)) + 
  geom_tile(aes(fill=I(Fill)), color="black",
            width=0.98, height=0.98) + 
  geom_text(aes(label=Text), size=20, 
            family = "Times New Roman", 
            fontface="bold") +
  theme_void() + 
  coord_equal()  + 
  transition_states(Frame, 
                    transition_length=1, 
                    state_length=1)

anim





animate(anim, width=300, height=300)
anim_save("DMQlogo.gif")