#install.packages("dygraphs")
require(RcmdrMisc)
require(googleVis)
require("dygraphs")


# Importar
Bancodeseries <- readXL("Baseserietemporal.xlsx", rownames=FALSE, header=TRUE, 
  na="", sheet="Plan1", stringsAsFactors=TRUE)

# Transformar em série temporal
Taxa_desemprego <- ts(Bancodeseries$Taxa_desemprego, start=c(1990, 12), end=c(2016, 12), frequency=12)
IGPM <- ts(Bancodeseries$IGPM, start=c(1990, 12), end=c(2017, 05), frequency=12)
Taxa_de_cambio_USA<- ts(Bancodeseries$Taxa_de_cambio_USA, start=c(1990, 12), end=c(2017, 05), frequency=12)

# Juntar as séries temporais
SerieTemporal <- cbind(Taxa_desemprego, Taxa_de_cambio_USA)
dygraph(SerieTemporal)

SerieTemporal2 <- cbind(Taxa_desemprego,IGPM, Taxa_de_cambio_USA)
dygraph(SerieTemporal2)

# Gráfico 
dygraph(SerieTemporal) %>% dyRangeSelector()
dygraph(SerieTemporal2) %>% dyRangeSelector()


# Gráfico com seleção de período
dygraph(SerieTemporal) %>%
  dySeries("Taxa_desemprego", label = "Taxa de Desemprego Aberto") %>%
  dySeries("Taxa_de_cambio_USA", label = "Taxa de C?mbio Real/Dolar m?dia") %>%
  dyOptions(stackedGraph = TRUE) %>%
  dyRangeSelector()

# Gráfico com anotação
dygraph(IGPM) %>%
  dySeries(, label = "IGP-M Inflação") %>%
  dyOptions(stackedGraph = TRUE) %>%
  dyAnnotation("1994-3-1", text = "Real", tooltip = "Plano Real") %>%
  dyRangeSelector()

# Gráfico com cores e título
dygraph(SerieTemporal, main = "Minha primeira s?rie temporal no R") %>%
  dySeries("Taxa_desemprego", label = "Taxa de Desemprego Aberto") %>%
  dySeries("Taxa_de_cambio_USA", label = "Taxa de C?mbio Real/Dolar m?dia") %>%
  dyShading(from = "1995-1-1", to = "2002-12-31", color = "#4570e0") %>%
  dyShading(from = "2003-1-1", to = "2011-12-31", color = "#e04545") %>%
  dyOptions(stackedGraph = TRUE) %>%
  dyRangeSelector()

# Como poder?amos colocar essa cor mais fraca?
#main = "S?rie temporal no R:") %>%
#"#a7b9e8" e "#ed7676"

# Intervalo Horizontal
dygraph(SerieTemporal, main = "S?rie temporal no R:") %>%
  dySeries("Taxa_desemprego", label = "Taxa de Desemprego Aberto") %>%
  dySeries("Taxa_de_cambio_USA", label = "Taxa de C?mbio Real/Dolar m?dia") %>%
  dyShading(from = 8, to = 14, axis = "y", color = "#6b6b6b") %>%
  dyOptions(stackedGraph = TRUE) %>%
  dyRangeSelector()

# Como poder?amos colocar essa cor mais fraca?
#f2f2f2"




# Podemos colocar tamb?m linhas verticais
dygraph(SerieTemporal, main = "S?rie temporal no R:  Nacional") %>%
  dySeries("Taxa_desemprego", label = "Taxa de Desemprego Aberto") %>%
  dySeries("Taxa_de_cambio_USA", label = "Taxa de C?mbio Real/Dolar m?dia") %>%
  dyShading(from = "1995-1-1", to = "2002-12-31", color = "#deeaef") %>%
  dyShading(from = "2003-1-1", to = "2011-12-31", color = "#f4d4d4") %>%
  dyEvent("1995-1-1", "FHC", labelLoc = "bottom") %>%
  dyEvent("2003-1-1", "Lula", labelLoc = "bottom") %>%
  dyOptions(stackedGraph = TRUE) %>%
  dyRangeSelector()

# Como poder?amos colocar tamb?m o Itamar e a Dilma?









# Colocando tudo junto 
dygraph(SerieTemporal, main = "S?rie temporal no R") %>%
  dySeries("Taxa_desemprego", label = "Taxa de Desemprego Aberto") %>%
  dySeries("Taxa_de_cambio_USA", label = "Taxa de C?mbio Real/Dolar m?dia") %>%
  dyShading(from = "1995-1-1", to = "2002-12-31", color = "#deeaef") %>%
  dyShading(from = "2003-1-1", to = "2011-12-31", color = "#f4d4d4") %>%
  dyEvent("1992-12-29", "Itamar", labelLoc = "bottom") %>%
  dyEvent("1995-1-1", "FHC", labelLoc = "bottom") %>%
  dyEvent("2003-1-1", "Lula", labelLoc = "bottom") %>%
  dyEvent("2012-1-1", "Dilma", labelLoc = "bottom") %>%
  dyOptions(stackedGraph = TRUE) %>%
  dyRangeSelector()





# Outros comandos interessantes
# Modelos de Box?Jenkins
ARIMA<-arima(Taxa_desemprego, order = c(0,1,1), seasonal = list(order = c(0,1,1)))
ARIMA

# FAC e FACP
acf(IGPM, lag.max=36) 
pacf(IGPM, lag.max=36) 

#Sazonalidade pode ser detectada pelo comando (stl): 
plot(stl(log(Taxa_desemprego), "periodic"))
plot(stl(IGPM, "periodic"))
