require(plotGoogleMaps) 
########################################################
# MEUSE DATA
########################################################
data(meuse)
coordinates(meuse)<-~x+y
proj4string(meuse) <- CRS('+init=epsg:28992')
m<-plotGoogleMaps(meuse,zcol='zinc')
# zinc labels
ic=iconlabels(meuse$zinc, height=12)
m<-plotGoogleMaps(meuse,zcol='zinc', iconMarker=ic)
# landuse labels and markers
ic=iconlabels(meuse$landuse, height=12, colPalette=rainbow(15) )
m<-plotGoogleMaps(meuse,zcol='landuse',colPalette=rainbow(15), iconMarker=ic)
ic=iconlabels(meuse$landuse, height=12, colPalette='#9ECAE1', icon=TRUE)
m<-plotGoogleMaps(meuse,zcol='landuse',colPalette='#9ECAE1', iconMarker=ic)

# Data preparation
data(meuse)
coordinates(meuse)<-~x+y
proj4string(meuse) <- CRS('+init=epsg:28992')
pies<-pieSP(meuse,zcol=c('zinc','lead','copper'), max.radius=120)
pies$pie=rep(c('zinc','lead','copper'),155)
m=plotGoogleMaps(pies, zcol='pie')
pies$pie2=rep(1:3,155)
spplot(pies, 'pie2')
pies2<-pieSP(meuse,zcol=c('zinc','dist.m'), max.radius=70,scalelist=FALSE)
pies2$pie=rep(c('zinc','dist.m'),155)
m=plotGoogleMaps(pies2, zcol='pie')
# plotKML(pies, col='pie')
# Data preparation


data(meuse)
coordinates(meuse)<-~x+y
proj4string(meuse) <- CRS('+init=epsg:28992')
m<-plotGoogleMaps(meuse,zcol='zinc')
# see results in your working directory
# similar classic plot
cols=PolyCol(meuse$zinc)$cols
plot(meuse,col=cols)
str(PolyCol(meuse$zinc))
m<-plotGoogleMaps(meuse,zcol='zinc',at=c(0,300,600, max(meuse$zinc)), colPalette=rainbow(3))
# similar classic plot

# Data preparation
data(meuse)
coordinates(meuse)<-~x+y
proj4string(meuse) <- CRS('+init=epsg:28992')
m<-segmentGoogleMaps(meuse,zcol=c('zinc','lead','copper'))


require(maptools)
# Line data
data(meuse.grid)
coordinates(meuse.grid)<-c('x','y')
meuse.grid<-as(meuse.grid,'SpatialPixelsDataFrame')
im<-as.image.SpatialGridDataFrame(meuse.grid['dist'])
cl<-ContourLines2SLDF(contourLines(im))
proj4string(cl) <- CRS('+init=epsg:28992')

# Combine point and line data
mapMeusePoints<- plotGoogleMaps(meuse,add=TRUE,mapTypeId='TERRAIN')
mapMeuseCl<- plotGoogleMaps(cl,previousMap=mapMeusePoints,filename='myMap2.htm')
# see results in your working directory



###########################################################################
require(plotGoogleMaps)
UPA <- read.table("Unidades_de_Saudev6.csv", header=TRUE, sep=";", 
                         na.strings="NA", dec=",", strip.white=TRUE)

UPA<-data.frame(UPA)
position <-data.frame(UPA,Longitude=UPA$X,Latitude=UPA$Y)
edit(UPA)

coordinates(position)<-~Longitude+Latitude
proj4string(position) <- CRS("+init=epsg:4326")

plotGoogleMaps(position)
plotGoogleMaps(position, zcol='gestao')
plotGoogleMaps(position, zcol='Equipes')

pies<-pieSP(position,zcol=c('P_OTIMO','P_BOM','P_REGULAR', 'P_INSUFICIENTE'), max.radius=1000)
pies$pie=rep(c('P_OTIMO','P_BOM','P_REGULAR', 'P_INSUFICIENTE'),42,5)
plotGoogleMaps(pies, zcol='pie')

pies<-pieSP(position,zcol=c('P_OTIMO','P_BOM','P_REGULAR', 'P_INSUFICIENTE'), max.radius=100)
pies$pie=rep(c('P_OTIMO','P_BOM','P_REGULAR', 'P_INSUFICIENTE'),42,5)
plotGoogleMaps(pies, zcol='pie')
