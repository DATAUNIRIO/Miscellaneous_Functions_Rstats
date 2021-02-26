
load("~/GitHub/Base_de_dados/df_pokemon.RData")

# ROTULO
percentual <- prop.table(table(df$type_1))*100
percentual <- round(percentual,digits = 1)
rotulo <- paste0(percentual,"%")
rotulo
# COR
cor<-unique(df$color_1)
#cor2 <- RColorBrewer::brewer.pal(11,"RdYlGn")
#GRÁFICO DE BARRA
grafico_barras <- barplot(table(df$type_1),  ylab="Frequência",col=cor, main="Gráfico 1")
text(grafico_barras, 0, rotulo,cex=1,pos=3,col = "blue")
#-------------------------------------------------------------------------------------------
# METODO ALTERNATIVO COM  O OPERADOR PIPE E O DPLYR
#-------------------------------------------------------------------------------------------
library(dplyr)
# ROTULO
percentual <- df %>% 
  pull(type_1) %>%
  table() %>%
  prop.table()*100
percentual <- round(percentual,digits = 1)
rotulo <- paste0(percentual,"%")
rotulo
#GRÁFICO DE BARRA
grafico_barras2<- df %>% 
  pull(type_1) %>%
  table() %>%
  barplot(ylab="Frequência",col=RColorBrewer::brewer.pal(11,"RdYlGn"),main="Gráfico 1")
text(grafico_barras2, 0, rotulo,cex=1,pos=3,col = "black")

poke_type1<-table(df$type_1)
a = barplot(poke_type1,
            main = "Gráfico 1 - Distruição de Pokemons por tipo Principal",
            ylim = c(0,120), 
            space = c(0.4),
            las = 2,
            col = cor)
text(a,poke_type1 + 6, labels = poke_type1)

