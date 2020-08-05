#######################################################
# Exemplo mostrando os dados de letramento dos EUA por estados
#######################################################
require(googleVis)
require(datasets)
states <- data.frame(state.name, state.x77)
states

#O que eu faco hoje
GeoStates <- gvisGeoChart(states, "state.name", "Illiteracy",
                          options=list(region="US", 
                                       displayMode="regions", 
                                       resolution="provinces",
                                       width=600, height=400))
plot(GeoStates)



#######################################################
#######################################################
#######################################################

edit(UF) 

PIB_BRASIL<- gvisGeoChart(UF, "Estado", "PIB",
                      options=list(region="BR", 
                                   displayMode="regions", 
                                   resolution="provinces",
                                   width=600, height=400))
plot(PIB_BRASIL)


#######################################################

PIB_BRASIL<- gvisGeoChart(UF, "Estado", "PIB",
                      options=list(region="BR", 
                                   displayMode="regions", 
                                   resolution="provinces",
                                   width=600, height=400,
colorAxis="{values:[200000000,300000000,400000000,1400000000],
colors:[\'red', \'royalblue\', \'blue',\'darkblue']}"))
plot(PIB_BRASIL)

# Fazer o mesmo para o PIB per capita, IDH, Despesa_Corrente e Despesa_Corrente_per_capita


#######################################################
#######################################################
#######################################################

Despesa_Corrente_per_capita<- gvisGeoChart(UF, "Estado", "Despesa_Corrente_per_capita",
                      options=list(region="BR", 
                                   displayMode="regions", 
                                   resolution="provinces",
                                   width=600, height=400,
colorAxis="{values:[1695,2233,2804,4000],
colors:[\'white', \'royalblue', \'navy',\'darkblue']}"))
plot(Despesa_Corrente_per_capita)



#######################################################
#demo(AnimatedGeoChart)

