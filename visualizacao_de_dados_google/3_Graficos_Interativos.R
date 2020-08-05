
require(googleVis)

################################################################
# Exemplo mostrando os dados de popularidade das cidades dos EUA
################################################################

edit(CityPopularity)

#O que eu faria no passado
barplot(CityPopularity$Popularity,names.arg=CityPopularity$City, col="royalblue")


#O que eu faco hoje
Gauge <-  gvisGauge(CityPopularity, 
                    options=list(min=0, max=800, greenFrom=500,
                                 greenTo=800, yellowFrom=300, yellowTo=500,
                                 redFrom=0, redTo=300, width=400, height=300))


plot(Gauge)

################################################################
######### Grafico de Bolhas
################################################################
edit(Fruits)
Bubble <- gvisBubbleChart(Fruits, idvar="Fruit", 
                          xvar="Sales", yvar="Expenses",
                          colorvar="Year", sizevar="Profit",
                          options=list(
                            hAxis='{minValue:75, maxValue:125}'))
plot(Bubble)


#######################################################
# Grafico - Calendario
#######################################################
edit(Cairo)

Cal <- gvisCalendar(Cairo, 
                    datevar="Date", 
                    numvar="Temp",
                    options=list(
                      title="Daily temperature in Cairo",
                      height=320,
                      calendar="{yearLabel: { fontName: 'Times-Roman',
                      fontSize: 32, color: '#1A8763', bold: true},
                      cellSize: 10,
                      cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                      focusedCellColor: {stroke:'red'}}")
                    )
plot(Cal)

#######################################################
######  Barras e Mapas 
#######################################################
df=data.frame(country=c("US", "GB", "BR", "FR", "AU"), 
              variavel1=c(10,13,14,13,12), 
              variavel2=c(23,12,32,20,30))
df

Bar <- gvisBarChart(df)
plot(Bar)


Intensity <- gvisIntensityMap(df)
plot(Intensity)



########################################################################
# Gr?fico Sankey
#
# Sankey diagrams are a specific type of flow diagram, in which
# the width of the arrows is shown proportionally to the flow quantity.
# Sankey diagrams are typically used to visualize energy or material or
#cost transfers between processes. They can also visualize the energy 
#accounts or material flow accounts on a regional or national level.
########################################################################

datSK <- data.frame(From=c(rep("A",3), rep("B", 3)),
                    To=c(rep(c("X", "Y", "Z"),2)),
                    Weight=c(5,7,6,2,9,4))
edit(datSK)
Sankey <- gvisSankey(datSK, from="From", to="To", weight="Weight",
                     options=list(
                       sankey="{link: {color: { fill: '#d799ae' } },
                       node: { color: { fill: '#a61d4c' },
                       label: { color: '#871b47' } }}"))
plot(Sankey)

#######################################################
# Grafico Treemap
#######################################################

edit(Regions)
Tree <- gvisTreeMap(Regions,  
                    "Region", "Parent", 
                    "Val", "Fac", 
                    options=list(fontSize=16))
plot(Tree)


#######################################################
# Tabela paginada
#######################################################
edit(Population)
PopTable <- gvisTable(Population, 
                      formats=list(Population="#,###",
                                   '% of World Population'='#.#%'),
                      options=list(page='enable'))
plot(PopTable)

#######################################################
# Mostrando o Furacao Andrew (1992). O caminho da tempestade
#######################################################

head(Andrew)

AndrewGeo <- gvisGeoChart(Andrew, 
                        locationvar="LatLong", 
                        sizevar = "Speed_kt", 
				colorvar =  "Speed_kt", 
                        hovervar="Category", 
                        options=list(height=350, 
                                     region="US", 
                                     dataMode="markers"))
plot(AndrewGeo)

#######################################################
# Mostrando o Furac?o Andrew (1992) O caminho da tempestade/ Versão 2
#######################################################

AndrewMap <- gvisMap(Andrew, "LatLong" , "Tip", 
                     options=list(showTip=TRUE, 
                                  showLine=TRUE, 
                                  enableScrollWheel=TRUE,
                                  mapType='terrain', 
                                  useMapTypeControl=TRUE))
plot(AndrewMap)

