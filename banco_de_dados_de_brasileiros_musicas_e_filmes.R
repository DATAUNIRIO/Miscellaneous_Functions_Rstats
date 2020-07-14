


library("rvest")
url <- "https://pt.m.wikipedia.org/wiki/Lista_das_100_maiores_m%C3%BAsicas_brasileiras_pela_Rolling_Stone_Brasil"

musicas <- url %>%
  html() %>%
  html_nodes(xpath='//*[contains(concat( " ", @class, " " ), concat( " ", "sortable", " " ))]') %>%
  html_table()
musicas <- musicas[[1]]

url <- 'https://pt.m.wikipedia.org/wiki/Lista_dos_100_melhores_filmes_brasileiros_segundo_a_ABRACCINE'

filmes <- url %>%
  html() %>%
  html_nodes(xpath='//*[contains(concat( " ", @class, " " ), concat( " ", "sortable", " " ))]') %>%
  html_table()
filmes <- filmes[[1]]

#Quais são três dos maiores cineastas brasileiros?
#Qual foi o melhor ano para o cinema brasileiro?
#Quais são os generos dos melhores filmes brasileiros?
  
# meirelesff/genderBR
# devtools::install_github('meirelesff/genderBR')
library(genderBR)  
filmes$genero <- get_gender(filmes$Diretor)
musicas$genero<-get_gender(musicas$`Compositor(es)`)
  
filmes_e_musicas<-list(filmes,musicas)
writexl::write_xlsx(filmes_e_musicas,path = "filmes_e_musicas.xlsx")
