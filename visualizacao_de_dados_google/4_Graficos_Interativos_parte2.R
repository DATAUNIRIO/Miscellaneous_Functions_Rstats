
require(googleVis)


M <- matrix(nrow=6,ncol=6)
M[col(M)==row(M)] <- 1:6
dat <- data.frame(X=1:6, M)
edit(dat)

SC <- gvisScatterChart(dat, 
                       options=list(
                         title="mudando a forma dos pontos",
                         legend="right",
                         pointSize=30,
                         series="{
                         0: { pointShape: 'circle' },
                         1: { pointShape: 'triangle' },
                         2: { pointShape: 'square' },
                         3: { pointShape: 'diamond' },
                         4: { pointShape: 'star' },
                         5: { pointShape: 'polygon' }
                         }"))
plot(SC)

########################################################################
# Gráfico Sankey
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
# Gr?fico Treemap
#######################################################

edit(Regions)
Tree <- gvisTreeMap(Regions,  
                    "Region", "Parent", 
                    "Val", "Fac", 
                    options=list(fontSize=16))
plot(Tree)


#######################################################
# Organograma
#######################################################
edit(Regions)
Org <- gvisOrgChart(Regions, 
                    options=list(width=600, height=250,
                                 size='large', allowCollapse=TRUE))
plot(Org)


#######################################################
# Timeline
#######################################################

datTL <- data.frame(Position=c(rep("Presidente", 3), rep("Vice", 3)),
                    Name=c("Washington", "Adams", "Jefferson",
                           "Adams", "Jefferson", "Burr"),
                    start=as.Date(x=rep(c("1789-03-29", "1797-02-03", 
                                          "1801-02-03"),2)),
                    end=as.Date(x=rep(c("1797-02-03", "1801-02-03", 
                                        "1809-02-03"),2)))
edit(datTL)

Timeline <- gvisTimeline(data=datTL, 
                         rowlabel="Name",
                         barlabel="Position",
                         start="start", 
                         end="end",
                         options=list(timeline="{groupByRowLabel:false}",
                                      backgroundColor='#ffd', 
                                      height=350,
                                      colors="['#cbb69d', '#603913', '#c69c6e']"))
plot(Timeline)


#######################################################
# Timeline
#######################################################

datTL <- data.frame(Position=c(rep("Presidente", 3), rep("Vice", 3)),
                    Name=c("Washington", "Adams", "Jefferson",
                           "Adams", "Jefferson", "Burr"),
                    start=as.Date(x=rep(c("1789-03-29", "1797-02-03", 
                                          "1801-02-03"),2)),
                    end=as.Date(x=rep(c("1797-02-03", "1801-02-03", 
                                        "1809-02-03"),2)))
edit(datTL)

#######################################################
# Leonel Brizola		15 de março de 1983 	15 de março de 1987
# Moreira Franco		15 de março de 1987 	15 de março de 1991
# Leonel Brizola 		15 de março de 1991 	02 de abril de 1994
# Nilo Batista 		02 de abril de 1994 	01 de janeiro de 1995
# Marcello Alencar	01 de janeiro de 1995 	01 de janeiro de 1999
# Anthony Garotinho 	01 de janeiro de 1999 	06 de abril de 2002
# Benedita da Silva 	06 de abril de 2002 	01 de janeiro de 2003
# Rosinha Garotinho 	01 de janeiro de 2003 	01 de janeiro de 2007
# Sérgio Cabral Filho 	01 de janeiro de 2007 	03 de abril de 2014
# Luiz Fernando Pezão 	03 de abril de 2014 	01 de janeiro de 2019
#######################################################

datTL3 <- data.frame(Posicao=c(rep("Governador", 10)),
                     Nome=c("Brizola"," Moreira Franco","Brizola"," Nilo Batista"," Marcello Alencar","Garotinho"," Benedita","Rosinha"," Sergio Cabral","Pezao"),
                     Inicio=as.Date(x=c("1983-03-15","1987-03-15","1991-03-15","1994-04-02","1995-01-01","1999-01-01","2002-04-06","2003-01-01","2007-01-01","2014-04-03")),
                     Fim=as.Date(x=c("1987-03-15","1991-03-15","1994-04-02","1995-01-01","1999-01-01","2002-04-06","2003-01-01","2007-01-01","2014-04-03","2019-01-01")))
edit(datTL3)

# Com base nas informações da galeria, construir a Timeline

Timeline2 <- gvisTimeline(data=datTL3, 
                         rowlabel="Nome",
                         barlabel="Posicao",
                         start="Inicio", 
                         end="Fim",
                         options=list(timeline="{groupByRowLabel:false}",
                                      backgroundColor='#ffd', 
                                      height=350,
                                      colors="['#cbb69d', '#603913', '#c69c6e','#cbb69d']"))
plot(Timeline2)

#######################################################
# Annotation Chart
#######################################################

Stock
Anno <- gvisAnnotationChart(Stock, 
                            datevar="Date",
                            numvar="Value", 
                            idvar="Device",
                            titlevar="Title", 
                            annotationvar="Annotation",
                            options=list(
                              width=600, height=350,
                              fill=10, displayExactValues=TRUE,
                              colors="['#0000ff','#00ff00']")
)
plot(Anno)