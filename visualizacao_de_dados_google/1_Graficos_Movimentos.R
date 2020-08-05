
###############################################################################
# Exemplo com os dados do Banco Mundial
###############################################################################
require(googleVis)

edit(WorldBank)

colnames(WorldBank) <- c("iso2c","Pais","ANO", "TaxadeFecundidade",
                         "EspectativadeVidaaoNascer","Populacao", "PIB_per_capita",
                         "mulheresde15a25anosalfabetizadas","iso3c","Regiao",
                         "capital","longitude","latitude","income","lending")


Movimento <- gvisMotionChart(WorldBank,
                             idvar="Pais", timevar="ANO",        
                             xvar="EspectativadeVidaaoNascer", yvar="TaxadeFecundidade",
                             colorvar="Regiao", sizevar="Populacao",
                             options=list(width=700, height=600),
                             chartid="WorldBank")


plot(Movimento)
#demo(WorldBank)

# Se não funcionar, é necessário instalar o flash-player.
# pelo site https://helpx.adobe.com/flash-player.html

#########################################################################################
# Seria possível fazer isso com as BasesEstados.xlsx e BasesMunicipios.xlsx
#########################################################################################


# Considerações:
# Comparar o gráfico de barras do PIB SC, BA e MT
# Efeito outlier da capital na base de dados municípios
 
