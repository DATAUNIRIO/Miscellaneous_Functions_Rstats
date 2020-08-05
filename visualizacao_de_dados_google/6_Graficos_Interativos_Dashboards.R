

#######################################################
#DASHBOARD
#######################################################
require(googleVis)

colnames(WorldBank) <- c("iso2c","Pais","ANO", "TaxadeFecundidade",
                         "EspectativadeVidaaoNascer","Populacao", "PIB_per_capita",
                         "mulheresde15a25anosalfabetizadas","iso3c","Regiao",
                         "capital","longitude","latitude","income","lending")



#######################################################
#Merging charts
#######################################################

G <- gvisGeoChart(Exports, "Country", "Profit", 
                  options=list(width=300, height=300))
T <- gvisTable(Exports, 
               options=list(width=220, height=300))

GT <- gvisMerge(G,T, horizontal=TRUE) 

plot(G)
plot(T)
plot(GT)

#######################################################
#Merging charts v2
#######################################################

datSK <- data.frame(From=c(rep("A",3), rep("B", 3)),
                    To=c(rep(c("X", "Y", "Z"),2)),
                    Weight=c(5,7,6,2,9,4))
N <- gvisSankey(datSK, from="From", to="To", weight="Weight",
                     options=list(
                       sankey="{link: {color: { fill: '#d799ae' } },
                       node: { color: { fill: '#a61d4c' },
                       label: { color: '#871b47' } }}"))


GN <- gvisMerge(G,N, horizontal=TRUE) 
TN <- gvisMerge(T,N, horizontal=TRUE) 

plot(GN)

plot(TN)


#######################################################
#Merging charts v3
#######################################################

Ga <-  gvisGauge(CityPopularity, 
                 options=list(min=0, max=800, greenFrom=500,
                              greenTo=800, yellowFrom=300, yellowTo=500,
                              redFrom=0, redTo=300, width=300, height=300))

GaN <- gvisMerge(Ga,N, horizontal=TRUE) 

plot(GaN)


#######################################################
#Merging charts v4
#######################################################
Map <- gvisMap(Andrew, "LatLong" , "Tip", 
                     options=list(showTip=TRUE, 
                                  showLine=TRUE, 
                                  enableScrollWheel=TRUE,
                                  mapType='terrain', 
                                  useMapTypeControl=TRUE))
GaMap <- gvisMerge(Map,Ga horizontal=FALSE) 

plot(GaMap)

#######################################################
#Merging charts v5
#######################################################
Tab <- gvisTable(Population, 
                      formats=list(Population="#,###",
                                   '% of World Population'='#.#%'),
                      options=list(page='enable'))

TabMap <- gvisMerge(Map,Tab, horizontal=FALSE) 

plot(TabMap)

