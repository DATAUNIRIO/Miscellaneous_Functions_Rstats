#install.packages("googleVis")

require(RcmdrMisc)
require(googleVis)

Estados <- readXL("BasesEstadosSerie.xlsx", rownames=FALSE, header=TRUE, 
  na="", sheet="Series", stringsAsFactors=TRUE)



EstadosMovimento <- gvisMotionChart(Estados,
                      idvar="Sigla", timevar="ANO",        
                      xvar="Despesa_orcamentaria", yvar="PIB_Estadual",
                      colorvar="Regiao", sizevar="Populacao",
                      options = list(width = "automatic",  height = "automatic"),
                      #options=list(width=700, height=600),
                      chartid="WorldBank")
plot(EstadosMovimento) 

# Como fazer esse mesmo gráfico para municipios?





# Gabarito
Municipios <- readXL("BasesMunicipiosSerie.xlsx", rownames=FALSE, header=TRUE, 
  na="", sheet="BD_comRJ", stringsAsFactors=TRUE)

#MunicipiosMovimento <- gvisMotionChart(Municipios,
#                      idvar="Municipio", timevar="Ano",        
#                      xvar="Prog_Bolsa_Familia_valor", yvar="PIB",
#                      colorvar="Mesoregiao", sizevar="Populacao",
#                      options = list(width = "automatic",  height = "automatic"),
#                      #options=list(width=700, height=600),
#                      chartid="WorldBank")
#plot(MunicipiosMovimento) 

# Se não funcionar, é necessário instalar o flash-player.
# pelo site https://helpx.adobe.com/flash-player.html