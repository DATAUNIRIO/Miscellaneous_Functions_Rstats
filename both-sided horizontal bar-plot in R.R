# Tornado / both-sided horizontal bar-plot in R with chart axes crosses at a given value (instead of crossing at zero) - Stack Overflow


library(ggplot2)
library(plyr)
library(dplyr)
library(tidyverse)

# this is throwing some warnings in my computer, but it is reading the data frame correctly
df <- '
Parameter Lower_Bound Upper_Bound UL_Difference
Parameter01 8074 11181 3108 
Parameter02 8177 11007 2831 
Parameter03 8879 10188 1308 
Parameter04 4358 18697 14339 
Parameter05 9073 10087 1013 
Parameter06 12034 7572 4462 
Parameter07 11357 7933 3423 
Parameter08 9769 9202 567 
Parameter09 8833 10403 1570 
Parameter10 13450 4219 9231 
Parameter11 10691 7915 2776 
Parameter12 10036 8792 1244
' %>% read_table2()

# original value of output
base.value <- 9504

# get order of parameters according to size of intervals
# (I use this to define the ordering of the factors which I then use to define the positions in the plot)
order.parameters <- df %>% arrange(UL_Difference) %>%
  mutate(Parameter=factor(x=Parameter, levels=Parameter)) %>%
  select(Parameter) %>% unlist() %>% levels()

# width of columns in plot (value between 0 and 1)
width <- 0.95

# get data frame in shape for ggplot and geom_rect
df.2 <- df %>% 
  # gather columns Lower_Bound and Upper_Bound into a single column using gather
  gather(key='type', value='output.value', Lower_Bound:Upper_Bound) %>%
  # just reordering columns
  select(Parameter, type, output.value, UL_Difference) %>%
  # create the columns for geom_rect
  mutate(Parameter=factor(Parameter, levels=order.parameters),
         ymin=pmin(output.value, base.value),
         ymax=pmax(output.value, base.value),
         xmin=as.numeric(Parameter)-width/2,
         xmax=as.numeric(Parameter)+width/2)

# create plot
# (use scale_x_continuous to change labels in y axis to name of parameters)
#png(width = 960, height = 540)
ggplot() + 
  geom_rect(data = df.2, 
            aes(ymax=ymax, ymin=ymin, xmax=xmax, xmin=xmin, fill=type)) +
  theme_bw() + 
  theme(axis.title.y=element_blank(), legend.position = 'bottom',
        legend.title = element_blank()) + 
  geom_hline(yintercept = base.value) +
  scale_x_continuous(breaks = c(1:length(order.parameters)), 
                     labels = order.parameters) +
  coord_flip()
#dev.off()