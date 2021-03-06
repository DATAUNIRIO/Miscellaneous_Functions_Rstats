rm(list=ls())

library(curl)
library(tidyverse)
library(readxl)
library(paletteer)
library(sf)
library(scales)
library(ragg)
library(gtools)
library(ggridges)
library(patchwork)
library(extrafont)
library(ggrepel)

#Download vaccination data by MSOA
#https://www.england.nhs.uk/statistics/statistical-work-areas/covid-19-vaccinations/
vax <- tempfile()
url <- "https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2021/05/COVID-19-weekly-announced-vaccinations-20-May-2021.xlsx"
vax <- curl_download(url=url, destfile=vax, quiet=FALSE, mode="wb")

vaxdata <- read_excel(vax, sheet="MSOA", range="F16:Q6806", col_names=FALSE) %>% 
  rename(msoa11cd=`...1`, msoa11nm=`...2`, `<40`=`...3`,  `40-44`=`...4`, `45-49`=`...5`, 
         `50-54`=`...6`, `55-59`=`...7`, `60-64`=`...8`, `65-69`=`...9`, `70-74`=`...10`, 
         `75-79`=`...11`, `80+`=`...12`) %>% 
  gather(age, vaccinated, c(3:12))

#Download IMD data
temp <- tempfile()
source <- ("https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/833970/File_1_-_IMD2019_Index_of_Multiple_Deprivation.xlsx")
temp <- curl_download(url=source, destfile=temp, quiet=FALSE, mode="wb")

IMD <- read_excel(temp, sheet="IMD2019", range="A2:F32845", col_names=FALSE)[,c(1,2,5,6)]
colnames(IMD) <- c("LSOA11CD", "LSOA11NM", "IMDrank", "IMDdecile")

#Download LSOA to MSOA lookup
temp <- tempfile()
source <- ("https://opendata.arcgis.com/datasets/fe6c55f0924b4734adf1cf7104a0173e_0.csv")
temp <- curl_download(url=source, destfile=temp, quiet=FALSE, mode="wb")

lookup <- read.csv(temp) %>% 
  select(LSOA11CD, MSOA11CD, RGN11NM) %>% 
  unique()

#Merge into IMD data
IMD <- merge(IMD, lookup, by="LSOA11CD")

#Bring in population data for LSOAs
temp <- tempfile()
temp2 <- tempfile()
source <- "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fpopulationandmigration%2fpopulationestimates%2fdatasets%2flowersuperoutputareamidyearpopulationestimatesnationalstatistics%2fmid2019sape22dt13/sape22dt13mid2019lsoabroadagesestimatesunformatted.zip"
temp <- curl_download(url=source, destfile=temp, quiet=FALSE, mode="wb")
unzip(zipfile=temp, exdir=temp2)

pop <- read_excel(file.path(temp2, "SAPE22DT13-mid-2019-lsoa-Broad_ages-estimates-unformatted.xlsx"),
                  sheet="Mid-2019 Persons", range="A6:G34758", col_names=FALSE)[,c(1,7)]
colnames(pop) <- c("LSOA11CD", "pop")

#Merge into IMD data
IMD <- merge(IMD, pop)

#Calculate IMD rank at MSOA level as weighted average of LSOA level ranks, weight by population
IMD_MSOA <- IMD %>% 
  group_by(MSOA11CD) %>% 
  summarise(IMDrank=weighted.mean(IMDrank, pop), pop=sum(pop)) %>% 
  ungroup() 

pop2 <- read_excel(vax, sheet="Population estimates (NIMS)", range="S16:AE6806", col_names=FALSE) %>% 
  select(-c(2,3)) %>% 
  rename(msoa11cd=`...1`) %>% 
  gather(age, pop, c(2:11)) %>% 
  mutate(age=case_when(
    age=="...4" ~ "<40", 
    age=="...5" ~ "40-44",
    age=="...6" ~ "45-49",
    age=="...7" ~ "50-54",
    age=="...8" ~ "55-59",
    age=="...9" ~ "60-64",
    age=="...10" ~ "65-69",
    age=="...11" ~ "70-74",
    age=="...12" ~ "75-79",
    TRUE ~ "80+")) %>% 
  group_by(msoa11cd, age) %>% 
  summarise(pop=sum(pop)) %>% 
  ungroup()

#COMBINE
vaxdata <- merge(vaxdata, pop2) %>% 
  merge(IMD_MSOA %>% select(-pop), by.x="msoa11cd", by.y="MSOA11CD") %>% 
  mutate(vaxprop=vaccinated/pop)

#Add totals
vaxdata <- vaxdata %>% 
  group_by(msoa11cd, msoa11nm, IMDrank) %>% 
  summarise(vaccinated=sum(vaccinated), pop=sum(pop)) %>% 
  mutate(vaxprop=vaccinated/pop, age="Total") %>% 
  ungroup() %>% 
  bind_rows(vaxdata)

#Download Carl Baker's lovely cartogram
msoa <- tempfile()
source <- ("https://github.com/houseofcommonslibrary/uk-hex-cartograms-noncontiguous/raw/main/geopackages/MSOA.gpkg")
msoa <- curl_download(url=source, destfile=msoa, quiet=FALSE, mode="wb")

BackgroundMSOA <- st_read(msoa, layer="5 Background")

MSOA <- st_read(msoa, layer="4 MSOA hex") %>% 
  left_join(vaxdata, by="msoa11cd")

GroupsMSOA <- st_read(msoa, layer="2 Groups")

Group_labelsMSOA <- st_read(msoa, layer="1 Group labels") %>% 
  mutate(just=if_else(LabelPosit=="Left", 0, 1))

LAsMSOA <- st_read(msoa, layer="3 Local authority outlines (2019)")

save(BackgroundMSOA, Group_labelsMSOA,GroupsMSOA,IMD,             
IMD_MSOA,LAsMSOA,lookup,msoa,MSOA,pop,pop2,source,temp,temp2,
url,vax,vaxdata,file='C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/dados_mapa.RData')   

#------------------------------------------------------------------------------------------------------------------

load('C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/dados_mapa.RData') 

plot <- ggplot()+
  geom_sf(data=BackgroundMSOA, aes(geometry=geom))+
  geom_sf(data=MSOA %>% filter(age=="80+"), 
          aes(geometry=geom, fill=vaxprop), colour=NA)+
  geom_sf(data=LAsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="White", size=0.1)+
  geom_sf(data=GroupsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="Black")+
  geom_sf_text(data=Group_labelsMSOA %>% filter(RegionNation!="Wales"), 
               aes(geometry=geom, label=Group.labe,
                   hjust=just), size=rel(2.4), colour="Black")+
  scale_fill_paletteer_c("pals::ocean.haline", direction=-1, 
                         name="Proportion of\npopulation\nvaccinated", limits=c(0,1),
                         labels=label_percent(accuracy=1))+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)),
        text=element_text(family="Roboto"))+
  labs(title="Vaccination rates in the over 80s",
       subtitle="People vaccinated in England by Middle Super Output Area.",       
       caption="Data from NHS England, populations from NIMS, Cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA80+Cartogram.tiff", units="in", width=10, height=8, res=800)
plot
dev.off()

agg_png("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA80+Cartogram.png", units="in", width=10, height=8, res=800)
plot
dev.off()

plot2 <- ggplot()+
  geom_sf(data=BackgroundMSOA, aes(geometry=geom))+
  geom_sf(data=MSOA %>% filter(age=="75-79"), 
          aes(geometry=geom, fill=vaxprop), colour=NA)+
  geom_sf(data=LAsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="White", size=0.1)+
  geom_sf(data=GroupsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="Black")+
  geom_sf_text(data=Group_labelsMSOA %>% filter(RegionNation!="Wales"), 
               aes(geometry=geom, label=Group.labe,
                   hjust=just), size=rel(2.4), colour="Black")+
  scale_fill_paletteer_c("pals::ocean.haline", direction=-1, 
                         name="Proportion of\npopulation\nvaccinated", limits=c(0,1),
                         labels=label_percent(accuracy=1))+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)),
        text=element_text(family="Roboto"))+
  labs(title="Vaccination rates in 75-79 year olds",
       subtitle="People vaccinated in England by Middle Super Output Area.",       
       caption="Data from NHS England, populations from NIMS, Cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA75Cartogram.tiff", units="in", width=10, height=8, res=800)
plot2
dev.off()

agg_png("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA75Cartogram.png", units="in", width=10, height=8, res=800)
plot2
dev.off()

plot3 <- ggplot()+
  geom_sf(data=BackgroundMSOA, aes(geometry=geom))+
  geom_sf(data=MSOA %>% filter(age=="70-74"), 
          aes(geometry=geom, fill=vaxprop), colour=NA)+
  geom_sf(data=LAsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="White", size=0.1)+
  geom_sf(data=GroupsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="Black")+
  geom_sf_text(data=Group_labelsMSOA %>% filter(RegionNation!="Wales"), 
               aes(geometry=geom, label=Group.labe,
                   hjust=just), size=rel(2.4), colour="Black")+
  scale_fill_paletteer_c("pals::ocean.haline", direction=-1, 
                         name="Proportion of\npopulation\nvaccinated", limits=c(0,1),
                         labels=label_percent(accuracy=1))+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)),
        text=element_text(family="Roboto"))+
  labs(title="Vaccination rates in 70-74 year olds",
       subtitle="People vaccinated in England by Middle Super Output Area.",       
       caption="Data from NHS England, populations from NIMS, Cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA70Cartogram.tiff", units="in", width=10, height=8, res=800)
plot3
dev.off()

agg_png("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA70Cartogram.png", units="in", width=10, height=8, res=800)
plot3
dev.off()

plot4 <- ggplot()+
  geom_sf(data=BackgroundMSOA, aes(geometry=geom))+
  geom_sf(data=MSOA %>% filter(age=="65-69"), 
          aes(geometry=geom, fill=vaxprop), colour=NA)+
  geom_sf(data=LAsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="White", size=0.1)+
  geom_sf(data=GroupsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="Black")+
  geom_sf_text(data=Group_labelsMSOA %>% filter(RegionNation!="Wales"), 
               aes(geometry=geom, label=Group.labe,
                   hjust=just), size=rel(2.4), colour="Black")+
  scale_fill_paletteer_c("pals::ocean.haline", direction=-1, 
                         name="Proportion of\npopulation\nvaccinated", limits=c(0,1),
                         labels=label_percent(accuracy=1))+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)),
        text=element_text(family="Roboto"))+
  labs(title="Vaccination rates in 65-69 year olds",
       subtitle="People vaccinated in England by Middle Super Output Area.",       
       caption="Data from NHS England, populations from NIMS, Cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA65Cartogram.tiff", units="in", width=10, height=8, res=800)
plot4
dev.off()

agg_png("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA65Cartogram.png", units="in", width=10, height=8, res=800)
plot4
dev.off()

plot5 <- ggplot()+
  geom_sf(data=BackgroundMSOA, aes(geometry=geom))+
  geom_sf(data=MSOA %>% filter(age=="60-64"), 
          aes(geometry=geom, fill=vaxprop), colour=NA)+
  geom_sf(data=LAsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="White", size=0.1)+
  geom_sf(data=GroupsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="Black")+
  geom_sf_text(data=Group_labelsMSOA %>% filter(RegionNation!="Wales"), 
               aes(geometry=geom, label=Group.labe,
                   hjust=just), size=rel(2.4), colour="Black")+
  scale_fill_paletteer_c("pals::ocean.haline", direction=-1, 
                         name="Proportion of\npopulation\nvaccinated", limits=c(0,1),
                         labels=label_percent(accuracy=1))+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)),
        text=element_text(family="Roboto"))+
  labs(title="Vaccination rates in 60-64 year olds",
       subtitle="People vaccinated in England by Middle Super Output Area.",       
       caption="Data from NHS England, populations from NIMS, Cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA6064Cartogram.tiff", units="in", width=10, height=8, res=800)
plot5
dev.off()

agg_png("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA6064Cartogram.png", units="in", width=10, height=8, res=800)
plot5
dev.off()

plot6 <- ggplot()+
  geom_sf(data=BackgroundMSOA, aes(geometry=geom))+
  geom_sf(data=MSOA %>% filter(age=="55-59"), 
          aes(geometry=geom, fill=vaxprop), colour=NA)+
  geom_sf(data=LAsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="White", size=0.1)+
  geom_sf(data=GroupsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="Black")+
  geom_sf_text(data=Group_labelsMSOA %>% filter(RegionNation!="Wales"), 
               aes(geometry=geom, label=Group.labe,
                   hjust=just), size=rel(2.4), colour="Black")+
  scale_fill_paletteer_c("pals::ocean.haline", direction=-1, 
                         name="Proportion of\npopulation\nvaccinated", limits=c(0,1),
                         labels=label_percent(accuracy=1))+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)),
        text=element_text(family="Roboto"))+
  labs(title="Vaccination rates in 55-59 year-olds",
       subtitle="People vaccinated in England by Middle Super Output Area.",       
       caption="Data from NHS England, populations from NIMS, Cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA5559Cartogram.tiff", units="in", width=10, height=8, res=800)
plot6
dev.off()

agg_png("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA5559Cartogram.png", units="in", width=10, height=8, res=800)
plot6
dev.off()

plot7 <- ggplot()+
  geom_sf(data=BackgroundMSOA, aes(geometry=geom))+
  geom_sf(data=MSOA %>% filter(age=="50-54"), 
          aes(geometry=geom, fill=vaxprop), colour=NA)+
  geom_sf(data=LAsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="White", size=0.1)+
  geom_sf(data=GroupsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="Black")+
  geom_sf_text(data=Group_labelsMSOA %>% filter(RegionNation!="Wales"), 
               aes(geometry=geom, label=Group.labe,
                   hjust=just), size=rel(2.4), colour="Black")+
  scale_fill_paletteer_c("pals::ocean.haline", direction=-1, 
                         name="Proportion of\npopulation\nvaccinated", limits=c(0,1),
                         labels=label_percent(accuracy=1))+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)),
        text=element_text(family="Roboto"))+
  labs(title="Vaccination rates in 50-54 year-olds",
       subtitle="People vaccinated in England by Middle Super Output Area.",       
       caption="Data from NHS England, populations from NIMS, Cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA5054Cartogram.tiff", units="in", width=10, height=8, res=800)
plot7
dev.off()

agg_png("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA5054Cartogram.png", units="in", width=10, height=8, res=800)
plot7
dev.off()

plot8 <- ggplot()+
  geom_sf(data=BackgroundMSOA, aes(geometry=geom))+
  geom_sf(data=MSOA %>% filter(age=="45-49"), 
          aes(geometry=geom, fill=vaxprop), colour=NA)+
  geom_sf(data=LAsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="White", size=0.1)+
  geom_sf(data=GroupsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="Black")+
  geom_sf_text(data=Group_labelsMSOA %>% filter(RegionNation!="Wales"), 
               aes(geometry=geom, label=Group.labe,
                   hjust=just), size=rel(2.4), colour="Black")+
  scale_fill_paletteer_c("pals::ocean.haline", direction=-1, 
                         name="Proportion of\npopulation\nvaccinated", limits=c(0,1),
                         labels=label_percent(accuracy=1))+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)),
        text=element_text(family="Roboto"))+
  labs(title="Vaccination rates in 45-49 year-olds",
       subtitle="People vaccinated in England by Middle Super Output Area.",       
       caption="Data from NHS England, populations from NIMS, Cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOA4549Cartogram.tiff", units="in", width=10, height=8, res=800)
plot8
dev.off()

agg_png("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOAu4549Cartogram.png", units="in", width=10, height=8, res=800)
plot8
dev.off()

plot9 <- ggplot()+
  geom_sf(data=BackgroundMSOA, aes(geometry=geom))+
  geom_sf(data=MSOA %>% filter(age=="Total"), 
          aes(geometry=geom, fill=vaxprop), colour=NA)+
  geom_sf(data=LAsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="White", size=0.1)+
  geom_sf(data=GroupsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="Black")+
  geom_sf_text(data=Group_labelsMSOA %>% filter(RegionNation!="Wales"), 
               aes(geometry=geom, label=Group.labe,
                   hjust=just), size=rel(2.4), colour="Black")+
  scale_fill_paletteer_c("pals::ocean.haline", direction=-1, 
                         name="Proportion of adult population vaccinated", limits=c(0,1),
                         labels=label_percent(accuracy=1))+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)),
        text=element_text(family="Roboto"), legend.position="top")+
  guides(fill = guide_colorbar(title.position = 'top', title.hjust = .5,
                               barwidth = unit(20, 'lines'), barheight = unit(.5, 'lines')))+
  labs(title="Overall adult vaccination rates",
       subtitle="People vaccinated in England by Middle Super Output Area.\n ",       
       caption="Data from NHS England, populations from NIMS, Cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOACartogram.tiff", units="in", width=10, height=8, res=800)
plot9
dev.off()

agg_png("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOACartogram.png", units="in", width=10, height=8, res=800)
plot9
dev.off()

plot10 <- ggplot()+
  geom_sf(data=BackgroundMSOA, aes(geometry=geom))+
  geom_sf(data=MSOA %>% filter(age=="Total") %>% mutate(flag=if_else(vaxprop>=0.5, 1, 0)), 
          aes(geometry=geom, fill=as.factor(flag)), colour=NA, show.legend=FALSE)+
  geom_sf(data=LAsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="White", size=0.1)+
  geom_sf(data=GroupsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="Black")+
  geom_sf_text(data=Group_labelsMSOA %>% filter(RegionNation!="Wales"), 
               aes(geometry=geom, label=Group.labe,
                   hjust=just), size=rel(2.4), colour="Black")+
  scale_fill_paletteer_d("wesanderson::Darjeeling1")+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.8)),
        text=element_text(family="Roboto"))+  #, plot.subtitle=element_markdown())+
  labs(title="Who is half way there?",
       subtitle="Neighbourhoods in England where <span style='color:#00A08A;'>over 50% of adults </span>have received at least one dose of COVID vaccine",       
       caption="Data from NHS England, Cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOACartogramHalfWay.tiff", units="in", width=10, height=8, res=800)
plot10
dev.off()

#Calculate deprivation gradients within IMD deciles
#Allocate to deciles
vaxdeciles <- vaxdata %>% 
  mutate(decile=quantcut(-IMDrank, 10, labels=FALSE)) %>% 
  group_by(age, decile) %>% 
  mutate(decilemean=sum(vaccinated)/sum(pop)) %>% 
  ungroup() %>% 
  group_by(age) %>% 
  mutate(popmean=sum(vaccinated)/sum(pop)) %>% 
  ungroup()

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOASxIMDScatter.tiff", units="in", width=12, height=8, res=800)
ggplot(vaxdeciles %>% filter(age=="Total"), 
       aes(x=vaxprop, y=as.factor(decile), colour=vaxprop))+
  geom_jitter(shape=21, alpha=0.6, show.legend=FALSE)+
  geom_segment(aes(x=popmean, xend=popmean, y=Inf, yend=-Inf), colour="Grey20")+
  geom_point(aes(x=decilemean, y=as.factor(decile)), colour="Grey20", fill="Cyan", shape=23, size=2)+
  scale_colour_paletteer_c("viridis::magma", direction=-1)+
  scale_x_continuous(name="Proportion of adult population vaccinated",
                     labels=label_percent(accuracy=1))+
  scale_y_discrete(name="Index of Multiple Deprivation", labels=c("1 - least deprived", "2", "3", "4", "5", "6", "7", 
                                                                  "8", "9", "10 - most deprived"))+  
  theme_classic()+
  theme(plot.title=element_text(face="bold", size=rel(1.6)),
        text=element_text(family="Roboto"))+
  labs(title="COVID vaccination rates are lower in more deprived areas in England",
       subtitle="Number of adults vaccinated by MSOA compared compared to the estimated 80+ population in 2019.",
       caption="Vaccination data from NHS England, Population data from ONS\nPlot by @VictimOfMaths")+
  annotate("text", x=0.7, y=9.9, label="Each circle = 1 MSOA", size=3, family="Roboto")+
  annotate("text", x=0.54, y=6.5, label="Population average", size=3, family="Roboto")+
  annotate("text", x=0.59, y=3.5, label="Decile average", size=3, family="Roboto")+
  geom_segment(aes(x=0.434, y=6.5,  xend=0.5, yend=6.5), colour="Grey20")+
  geom_segment(aes(x=0.56, y=3.55,  xend=0.49, yend=3.95), colour="Grey20")
dev.off()

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOASxIMDRidges.tiff", units="in", width=8, height=6, res=800)
ggplot(vaxdeciles %>% filter(age=="Total"),
       aes(x=vaxprop, y=as.factor(decile), fill=vaxprop))+
  geom_density_ridges_gradient(aes(fill=stat(x)), rel_min_height=0.01, show.legend=FALSE)+
  scale_y_discrete(name="Index of Multiple Deprivation", labels=c("1 - least deprived", "2", "3", "4", "5", "6", "7", 
                                                                  "8", "9", "10 - most deprived"))+ 
  scale_x_continuous(name="Proportion of adult population vaccinated",
                     labels=label_percent(accuracy=1))+
  scale_fill_paletteer_c("pals::ocean.haline", direction=-1)+
  theme_classic()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)),
        text=element_text(family="Roboto"))+
  labs(title="Vaccination rates in England are lower in more deprived areas",
       subtitle="Distribution of MSOA-level vaccination rates for adults (aged 16+) in England",
       caption="Data from NHS England | Plot by @VictimOfMaths")
dev.off()

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOASxIMDxAgeRidges.tiff", units="in", width=10, height=7, res=800)
ggplot(vaxdeciles %>% filter(age!="Total"),
       aes(x=vaxprop, y=as.factor(decile), fill=vaxprop))+
  geom_density_ridges_gradient(aes(fill=stat(x)), rel_min_height=0.01, show.legend=FALSE)+
  scale_y_discrete(name="Index of Multiple Deprivation", labels=c("1 - least deprived", "2", "3", "4", "5", "6", "7", 
                                                                  "8", "9", "10 - most deprived"))+ 
  scale_x_continuous(name="Proportion of population vaccinated",
                     labels=label_percent(accuracy=1))+
  scale_fill_paletteer_c("pals::ocean.haline", direction=-1)+
  facet_wrap(~age)+
  theme_classic()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)),
        strip.background=element_blank(),
        strip.text=element_text(face="bold", size=rel(1)),
        text=element_text(family="Roboto"))+
  labs(title="Vaccination rates in England are lower in more deprived areas",
       subtitle="Distribution of MSOA-level vaccination rates for adults (aged 16+) in England",
       caption="Data from NHS England | Plot by @VictimOfMaths")
dev.off()

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOASxIMDScatterxAge.tiff", units="in", width=12, height=8, res=800)
ggplot(vaxdata %>% filter(age!="Total"), aes(x=vaxprop, y=-IMDrank, colour=vaxprop))+
  geom_point(shape=21, alpha=0.6, show.legend=FALSE)+
  scale_x_continuous(name="Proportion of population vaccinated", labels=label_percent(accuracy=1))+
  scale_y_continuous(name="Index of Multiple Deprivation", breaks=c(0, -32507),
                     labels=c("Most deprived", "Least deprived"))+
  scale_colour_paletteer_c("pals::ocean.haline", direction=-1)+
  facet_wrap(~age)+
  theme_classic()+
  theme(strip.background=element_blank(), strip.text=element_text(face="bold", size=rel(1)),
        plot.title=element_text(face="bold", size=rel(1.4)),
        text=element_text(family="Roboto"))+
  labs(title="COVID vaccine uptake is lower in more deprived areas in England",
       subtitle="Number of people vaccinated by age group and MSOA compared compared to the estimated population in 2019.",
       caption="Vaccination data from NHS England, Population data from ONS\nPlot by @VictimOfMaths")
dev.off()

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOASxIMDScatter.tiff", units="in", width=12, height=8, res=800)
ggplot(vaxdata %>% filter(age=="Total"), aes(x=vaxprop, y=-IMDrank, colour=vaxprop))+
  geom_point(shape=21, alpha=0.6, show.legend=FALSE)+
  scale_x_continuous(name="Proportion of population vaccinated", labels=label_percent(accuracy=1))+
  scale_y_continuous(name="Index of Multiple Deprivation", breaks=c(0, -32507),
                     labels=c("Most deprived", "Least deprived"))+
  scale_colour_paletteer_c("pals::ocean.haline", direction=-1)+
  theme_classic()+
  theme(strip.background=element_blank(), strip.text=element_text(face="bold", size=rel(1)),
        plot.title=element_text(face="bold", size=rel(1.4)),
        text=element_text(family="Roboto"))+
  labs(title="COVID vaccine uptake is lower in more deprived areas in England",
       subtitle="Number of people vaccinated by age group and MSOA compared compared to the estimated population in 2019.",
       caption="Vaccination data from NHS England, Population data from ONS\nPlot by @VictimOfMaths")
dev.off()

#############################
#Local analysis
#Download MSOA map
#Download shapefile of LA boundaries
temp <- tempfile()
temp2 <- tempfile()
source <- "https://opendata.arcgis.com/datasets/826dc85fb600440889480f4d9dbb1a24_0.zip?outSR=%7B%22latestWkid%22%3A27700%2C%22wkid%22%3A27700%7D"
temp <- curl_download(url=source, destfile=temp, quiet=FALSE, mode="wb")
unzip(zipfile=temp, exdir=temp2)

#The actual shapefile has a different name each time you download it, so need to fish the name out of the unzipped file
name <- list.files(temp2, pattern=".shp")
shapefile <- st_read(file.path(temp2, name))

#save(shapefile,file='C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/shapefile.RData')   
#-------------------------------------------------------------------------------------------------------------
load('C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/shapefile.RData')   
load('C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/dados_mapa.RData') 

map <- full_join(shapefile, MSOA %>% select(Laname, msoa11cd, IMDrank, vaxprop, pop, age) %>% as.data.frame(), 
                 by="msoa11cd", all.y=TRUE)

SheffIMD <- map %>% filter(age=="Total" & Laname=="Sheffield") %>% 
  ggplot()+
  geom_sf(aes(geometry=geometry, fill=IMDrank), show.legend=FALSE, colour=NA)+
  scale_fill_paletteer_c("pals::ocean.matter")+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)), text=element_text(family="Roboto"))+
  labs(title="Index of Multiple deprivation",
       subtitle="Darker colours = more deprived")

Sheffvax <- map %>% filter(age!="Total" & Laname=="Sheffield") %>% 
  ggplot()+
  geom_sf(aes(geometry=geometry, fill=vaxprop), colour=NA)+
  facet_wrap(~age)+
  scale_fill_paletteer_c("pals::ocean.haline", direction=-1, 
                         name="Proportion of\npopulation\nvaccinated", limits=c(0,1),
                         labels=label_percent(accuracy=1))+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)), text=element_text(family="Roboto"))+
  labs(title="COVID-19 vaccination rates",
       caption="Data from NHS England and ONS, Cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOASSheffield.tiff", units="in", width=12, height=8, res=800)
SheffIMD+Sheffvax
dev.off()

#Scatterplot of vax rates by MSOA in Sheffield
scatterdata <- MSOA %>% 
  filter(Laname=="Sheffield" & age %in% c("80+", "75-79", "70-74", "65-69", "60-64",
                                          "55-59", "50-54", "45-49", "40-44")) %>%
  group_by(msoa11cd, MSOA.name.HCL, IMDrank) %>% 
  summarise(vaccinated=sum(vaccinated), pop=sum(pop)) %>% 
  ungroup() %>% 
  mutate(vaxprop=vaccinated/pop,
         labels=if_else(vaxprop<0.75, MSOA.name.HCL, "")) 

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOASheffieldScatter.tiff", units="in", width=8, height=6, res=800)
ggplot(scatterdata, aes(x=vaxprop, y=-IMDrank))+
  geom_point(aes(size=pop), shape=21, colour="DarkRed", fill="tomato", alpha=0.8)+
  geom_segment(aes(x=1, xend=1, y=-1000, yend=-32000), colour="Grey70")+
  geom_text_repel(aes(label=labels), family="Roboto", size=rel(3),
                  box.padding = 0.4)+
  scale_x_continuous(name="Proportion of population aged 40+ vaccinated", 
                     labels=label_percent(accuracy=1), limits=c(NA, 1))+
  scale_y_continuous(name="Index of Multiple Deprivation rank", breaks=c(-1000, -32000),
                     labels=c("Most deprived", "Least deprived"))+
  scale_size_continuous(name="Population\nover 40")+
  theme_classic()+
  theme(axis.ticks.y=element_blank(), text=element_text(family="Roboto"),
        axis.text.y=element_text(size=rel(1.2), colour="Black"),
        plot.title.position="plot", plot.title=element_text(face="bold", size=rel(1.4)),
        plot.subtitle=element_text(colour="Grey50"), plot.caption.position ="plot",
        plot.caption=element_text(colour="Grey50"))+
  labs(title="Vaccine delivery is lowest in a small number of deprived areas in Sheffield",
       subtitle="Proportion of adults aged 50+ who have received at least one dose of COVID-19 vaccine",
       caption="Data from NHS England, populations from NIMS\nPlot by @VictimOfMaths")
dev.off()

#Regional version for Yorkshire
scatterdata2 <- MSOA %>% 
  filter(RegionNation=="Yorkshire and The Humber" & age %in% c("80+", "75-79", "70-74", "65-69", 
                                                               "60-64", "55-59", "50-54", "45-49", 
                                                               "40-44")) %>%
  group_by(msoa11cd, MSOA.name.HCL, IMDrank) %>% 
  summarise(vaccinated=sum(vaccinated), pop=sum(pop)) %>% 
  ungroup() %>% 
  mutate(vaxprop=vaccinated/pop,
         labels=if_else(vaxprop<0.6, MSOA.name.HCL, "")) 

agg_png("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOAYorksScatter.png", units="in", width=8, height=6, res=800)
ggplot(scatterdata2, aes(x=vaxprop, y=-IMDrank))+
  geom_point(aes(size=pop), shape=21, colour="DarkRed", fill="tomato", alpha=0.8)+
  geom_segment(aes(x=1, xend=1, y=-1000, yend=-32000), colour="Grey70")+
  geom_text_repel(aes(label=labels), family="Roboto", size=rel(2.2),
                  box.padding = 0.5, min.segment.length=0)+
  scale_x_continuous(name="Proportion of population aged 40+ vaccinated", 
                     labels=label_percent(accuracy=1), limits=c(NA, 1))+
  scale_y_continuous(name="Index of Multiple Deprivation rank", breaks=c(-1000, -32000),
                     labels=c("Most deprived", "Least deprived"), limits=c(NA, 2000))+
  scale_size_continuous(name="Over 40\npopulation")+
  theme_classic()+
  theme(axis.ticks.y=element_blank(), text=element_text(family="Roboto"),
        axis.text.y=element_text(size=rel(1.2), colour="Black"),
        plot.title.position="plot", plot.title=element_text(face="bold", size=rel(1.4)),
        plot.subtitle=element_text(colour="Grey50"), plot.caption.position ="plot",
        plot.caption=element_text(colour="Grey50"))+
  labs(title="Vaccine delivery is lowest in a small number of deprived areas in Yorkshire",
       subtitle="Proportion of adults aged 40+ who have received at least one dose of COVID-19 vaccine",
       caption="Data from NHS England, populations from NIMS\nPlot by @VictimOfMaths")
dev.off()

#Calculate age-standardised vaccination rates
asvax <- vaxdata %>% 
  filter(age!="Total") %>% 
  select(-c(vaccinated, pop)) %>% 
  spread(age, vaxprop) %>% 
  mutate(asrate=(`<40`*31000+`40-44`*7000+`45-49`*7000+`50-54`*7000+`55-59`*6500+`60-64`*6000+
                   `65-69`*5500+`70-74`*5000+`75-79`*4000+`80+`*5000)/84000)

MSOA2 <- st_read(msoa, layer="4 MSOA hex") %>% 
  left_join(asvax, by="msoa11cd") %>% 
  filter(RegionNation!="Wales")

plot10 <- ggplot()+
  geom_sf(data=BackgroundMSOA, aes(geometry=geom))+
  geom_sf(data=MSOA2, 
          aes(geometry=geom, fill=asrate), colour=NA)+
  geom_sf(data=LAsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="White", size=0.1)+
  geom_sf(data=GroupsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="Black")+
  geom_sf_text(data=Group_labelsMSOA %>% filter(RegionNation!="Wales"), 
               aes(geometry=geom, label=Group.labe,
                   hjust=just), size=rel(2.4), colour="Black")+
  scale_fill_paletteer_c("pals::ocean.dense", direction=-1, 
                         name="Proportion of adults vaccinated\n(age-standardised)", limits=c(0,NA),
                         labels=label_percent(accuracy=1))+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.4)),
        text=element_text(family="Roboto"), legend.position="top")+
  guides(fill = guide_colorbar(title.position = 'top', title.hjust = .5,
                               barwidth = unit(20, 'lines'), barheight = unit(.5, 'lines')))+
  labs(title="Vaccination rates are lowest in urban areas even after accounting\nfor the fact that they tend to have younger populations\n \n ",
       caption="Data from NHS England, populations from NIMS, Cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")

agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOAAgeStdCartogram.tiff", units="in", width=9, height=10, res=800)
plot10
dev.off()

agg_png("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDVaxMSOAAgeStdCartogram.png", units="in", width=9, height=10, res=800)
plot10
dev.off()

#Bivariate maps of age-standardised vax rate  against deprivation
BVmapdata <- MSOA2 %>% 
  filter(RegionNation!="Wales") %>% 
  mutate(IMDtert=quantcut(-IMDrank, q=3, labels=FALSE),
         vaxtert=quantcut(asrate, q=3, labels=FALSE))

#Generate key
keydata <- data.frame(IMDtert=c(1,2,3,1,2,3,1,2,3), 
                      vaxtert=c(1,1,1,2,2,2,3,3,3),
                      RGB=c("#e8e8e8", "#dfb0d6", "#be64ac", 
                            "#ace4e4", "#a5add3", "#8c62aa", 
                            "#5ac8c8", "#5698b9", "#3b4994"))


#Bring colours into main data for plotting
BVmapdata <- left_join(BVmapdata, keydata, by=c("IMDtert", "vaxtert"))

key <- ggplot(keydata)+
  geom_tile(aes(x=IMDtert, y=vaxtert, fill=RGB))+
  scale_fill_identity()+
  labs(x = expression("Greater deprivation" %->%  ""),
       y = expression("Higher vaccination rates" %->%  "")) +
  theme_classic() +
  # make font small enough
  theme(
    axis.title = element_text(size = 9),axis.line=element_blank(), 
    axis.ticks=element_blank(), axis.text=element_blank())+
  # quadratic tiles
  coord_fixed()

BVmap <-  ggplot()+
  geom_sf(data=BackgroundMSOA, aes(geometry=geom))+
  geom_sf(data=BVmapdata, 
          aes(geometry=geom, fill=RGB), colour=NA)+
  geom_sf(data=LAsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="White", size=0.1)+
  geom_sf(data=GroupsMSOA %>% filter(RegionNation!="Wales"), 
          aes(geometry=geom), fill=NA, colour="Black")+
  geom_sf_text(data=Group_labelsMSOA %>% filter(RegionNation!="Wales"), 
               aes(geometry=geom, label=Group.labe,
                   hjust=just), size=rel(2.4), colour="Black")+
  scale_fill_identity()+
  theme_void()+
  theme(plot.title=element_text(face="bold", size=rel(1.6)),
        text=element_text(family="Lato"), plot.title.position = "panel")+
  annotate("text", x=56.5, y=14, label="Higher deprivation,\nfewer vaccinations", size=3,
           fontface="bold", family="Lato")+
  geom_curve(aes(x=53, y=14, xend=48, yend=14.3), curvature=-0.15)+
  annotate("text", x=45, y=2, label="Lower deprivation,\nfewer vaccinations", size=3,
           fontface="bold", family="Lato")+
  geom_curve(aes(x=44, y=3.2, xend=42, yend=7.6), curvature=0.2)+
  annotate("text", x=51, y=35, label="Higher deprivation,\nmore vaccinations", size=3,
           fontface="bold", family="Lato")+
  geom_curve(aes(x=49, y=34, xend=45.5, yend=31.8), curvature=-0.2)+
  annotate("text", x=19, y=43, label="Lower deprivation,\nmore vaccinations", size=3,
           fontface="bold", family="Lato")+
  geom_curve(aes(x=19.5, y=41.5, xend=22.2, yend=38.1), curvature=0.1)+
  coord_sf(clip="off")+
  labs(title="Comparing deprivation with current vaccine coverage",
       subtitle="Age-standardised rates of delivery of at least one vaccine dose and area-level deprivation\nmeasured using the Index of Multiple Deprivation",       
       caption="Data from MCHLG and NHS England, cartogram from @carlbaker/House of Commons Library\nPlot by @VictimOfMaths")

library(cowplot)
agg_tiff("C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/mapa/COVIDBivariateIMDxVaxFull.tiff", units="in", width=8, height=10, res=800)
ggdraw()+
  draw_plot(BVmap, 0,0,1,1)+
  draw_plot(key, 0.66,0.66,0.30,0.30)
dev.off()


