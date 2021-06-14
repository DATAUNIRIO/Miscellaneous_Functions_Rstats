library(rvest)
site<-'http://www.unirio.br/ppgcp/docentes'
dados_html <- read_html(site)

links <- dados_html %>% 
  html_nodes(".external-link")%>% 
  html_attr("href")

library(RVerbalExpressions)

# construct an expression
x <- rx_start_of_line() %>% 
  rx_find('http') %>% 
  rx_maybe('s') %>% 
  rx_find('://') %>% 
  rx_maybe('www.') %>% 
  rx_find('lattes.cnpq.br') %>% 
  rx_anything_but(' ') %>% 
  rx_end_of_line()


library(stringr)
#stringr::str_extract_all(links,x)
links<-str_extract(links,x)
links<-na.omit(links)


nomes <- dados_html %>% 
  html_nodes("p")%>% 
  html_text("strong")
nomes <-nomes[2:68]

str_extract(nomes,"Currículo Lattes:")
str_match(nomes,"Currículo Lattes:")
str_match(nomes,"")

NOMES<-c("Felipe Borba", "Cristiane Batista", "André Coelho","Andrea Lopes da Costa Vieira", 
"Celina Maria de Souza","Enara Echart","Fabio Kerche","Fabrício Pereira da Silva",                                                       
"Guilherme Simões Reis","José Paulo Martins Jr.","Luciana Fernandes Veiga",                                                        
"Marcia Ribeiro Dias","María del Carmen Villarreal Villamar","Vinicius Ferreira Baptista",                                                     
"Vinicius Pinheiro Israel","Steven Ross","Camila Gonçalves de Mario","César Sabino","Fernando Quintana")                                                              

LINKS_LATTES <- c("Currículo Lattes: http://lattes.cnpq.br/9421155244718142",                        
"Currículo Lattes: http://lattes.cnpq.br/4826542510207985","Currículo Lattes: http://lattes.cnpq.br/7370207316680307",                        
"Currículo Lattes: http://lattes.cnpq.br/4453051972658627","Currículo Lattes: http://lattes.cnpq.br/5422025168210583",                        
"Currículo Lattes: http://lattes.cnpq.br/6006436900849498","Currículo Lattes: http://lattes.cnpq.br/2915744801959590",                        
"Currículo Lattes: http://lattes.cnpq.br/9379506563230651","Currículo Lattes: http://lattes.cnpq.br/3158556788451048",                        
"Currículo Lattes: http://lattes.cnpq.br/8221994415733738","Currículo Lattes: http://lattes.cnpq.br/6225554673074879",                        
"Currículo Lattes: http://lattes.cnpq.br/5113857437482385","Currículo Lattes: http://lattes.cnpq.br/4226668185210573",                        
"Currículo Lattes: http://lattes.cnpq.br/1519850039767968","Currículo Lattes: http://lattes.cnpq.br/6305743866339870",                        
"Currículo Lattes: http://lattes.cnpq.br/2970110332151340","Currículo Lattes: http://lattes.cnpq.br/4353113348878044",                        
"Currículo Lattes: http://lattes.cnpq.br/8881781036067177","Currículo Lattes: http://lattes.cnpq.br/8036250105251321")

PPGCP <-data.frame(NOMES,LINKS_LATTES)
remove(NOMES,LINKS_LATTES)

library(GetLattesData)

# get files from pkg (you can download from other researchers in lattes website)
# Demostracao
f.in <- c('C:/Users/Hp/Downloads/2970110332151340.zip', # Steven
          'C:/Users/Hp/Downloads/9421155244718142.zip', # Borba
          'C:/Users/Hp/Downloads/6225554673074879.zip', # Luciana Veiga
          'C:/Users/Hp/Downloads/6305743866339870.zip') # Vinicius
          #  'C:/Users/Hp/Downloads/4763659817918925.zip', # Fabio Simas
          #'C:/Users/Hp/Downloads/7637282964789451.zip', # Acir
          #'C:/Users/Hp/Downloads/6725560105680636.zip',  # Gladson
          #'C:/Users/Hp/Downloads/2637672868100554.zip', # Cal Neto
          #'C:/Users/Hp/Downloads/1619536438180209.zip') # Alexandre

#field.qualis = 'ADMINISTRAÇÃO PÚBLICA E DE EMPRESAS, CIÊNCIAS CONTÁBEIS E TURISMO'
field.qualis = 'CIÊNCIA POLÍTICA E RELAÇÕES INTERNACIONAIS' 
field.qualis = c('CIÊNCIA POLÍTICA E RELAÇÕES INTERNACIONAIS','ECONOMIA')
field.qualis = c("MATEMÁTICA / PROBABILIDADE E ESTATÍSTICA")

all_field.qualis = c("ADMINISTRAÇÃO PÚBLICA E DE EMPRESAS, CIÊNCIAS CONTÁBEIS E TURISMO", "ANTROPOLOGIA / ARQUEOLOGIA", "ARQUITETURA, URBANISMO E DESIGN", "ARTES", "ASTRONOMIA / FÍSICA", "BIODIVERSIDADE", "BIOTECNOLOGIA", "CIÊNCIA DA COMPUTAÇÃO", "CIÊNCIA DE ALIMENTOS", "CIÊNCIA POLÍTICA E RELAÇÕES INTERNACIONAIS", "CIÊNCIAS AGRÁRIAS I", "CIÊNCIAS AMBIENTAIS", "CIÊNCIAS BIOLÓGICAS I", "CIÊNCIAS BIOLÓGICAS II", "CIÊNCIAS BIOLÓGICAS III", "CIÊNCIAS DA RELIGIÃO E TEOLOGIA", "COMUNICAÇÃO E INFORMAÇÃO", "DIREITO", "ECONOMIA", "EDUCAÇÃO", "EDUCAÇÃO FÍSICA", "ENFERMAGEM", "ENGENHARIAS I", "ENGENHARIAS II", "ENGENHARIAS III", "ENGENHARIAS IV", "ENSINO", "FARMÁCIA", "FILOSOFIA", "GEOCIÊNCIAS", "GEOGRAFIA", "HISTÓRIA", "INTERDISCIPLINAR", "LINGUÍSTICA E LITERATURA", "MATEMÁTICA / PROBABILIDADE E ESTATÍSTICA", "MATERIAIS", "MEDICINA I", "MEDICINA II", "MEDICINA III", "MEDICINA VETERINÁRIA", "NUTRIÇÃO", "ODONTOLOGIA", "PLANEJAMENTO URBANO E REGIONAL / DEMOGRAFIA", "PSICOLOGIA", "QUÍMICA", "SAÚDE COLETIVA", "SERVIÇO SOCIAL", "SOCIOLOGIA", "ZOOTECNIA / RECURSOS PESQUEIROS")

# get data
l.out <- gld_get_lattes_data_from_zip(f.in, field.qualis = field.qualis)

#l.out <- gld_get_lattes_data_from_zip(f.in)

names(l.out)
tpesq<- l.out$tpesq
tpublic.published <- l.out$tpublic.published
tpublic.accepted<- l.out$tpublic.accepted
tsupervisions<-l.out$tsupervisions
tbooks<-l.out$tbooks
tconferences<-l.out$tconferences

library(ggplot2)
p <- ggplot(tpublic.published, aes(x = qualis,fill=name)) +
  geom_bar(position = 'identity')+
  facet_wrap(~name) +
  scale_fill_manual(values = c("orange","blue","red","darkgreen"))+ 
  labs(x = paste0('Qualis'))
p

q <- ggplot(tconferences, aes(x = article.year,fill=event.classification)) +
  geom_bar(position = 'identity')+
  facet_wrap(~name) 
q

l <- ggplot(tsupervisions, aes(x = year.supervision ,fill=situation)) +
  geom_bar(position = 'identity')+
  facet_wrap(~name) 
l

library(dplyr)
my.tab <- tpublic.published %>%
  group_by(name) %>%
  summarise(n.papers = n(),
            max.SJR = max(SJR, na.rm = T),
            mean.SJR = mean(SJR, na.rm = T),
            A1.qualis = sum(qualis == 'A1', na.rm = T),
            A2.qualis = sum(qualis == 'A2', na.rm = T),
            B1.qualis = sum(qualis == 'B1', na.rm = T),
            B2.qualis = sum(qualis == 'B2', na.rm = T),
            B3.qualis = sum(qualis == 'B3', na.rm = T),
            B4.qualis = sum(qualis == 'B4', na.rm = T),
            B5.qualis = sum(qualis == 'B5', na.rm = T),
            median.authorship = median(as.numeric(order.aut), na.rm = T ))

knitr::kable(my.tab)


#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------
#                 ESCOLA DE MATEMATICA
#-------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------

library(rvest)
site<-'https://matematica.uniriotec.br/departamento-de-metodos-quantitativos/'
dados_html <- read_html(site)

nomes <- dados_html %>% 
  html_nodes(".tmm_names")%>% 
  html_text("href")

links <- dados_html %>% 
  html_nodes("a")%>% 
  html_attr("href")

library(RVerbalExpressions)
# construct an expression
x <- rx_start_of_line() %>% 
  rx_maybe(' ') %>% 
  rx_find('http') %>% 
  rx_maybe('s') %>% 
  rx_find('://') %>% 
  rx_maybe('www.') %>% 
  rx_find('lattes.cnpq.br') %>% 
  rx_anything_but(' ') %>% 
  rx_end_of_line()

library(stringr)
#stringr::str_extract_all(links,x)
links<-str_extract(links,x)
links<-na.omit(links)

DMQ <- data.frame(nomes,links)
#---------------------------------------------------------------------------------


library(rvest)
site<-'https://matematica.uniriotec.br/departamento-de-matematica/'
dados_html <- read_html(site)

nomes <- dados_html %>% 
  html_nodes(".tmm_names")%>% 
  html_text("href")

links <- dados_html %>% 
  html_nodes("a")%>% 
  html_attr("href")

library(RVerbalExpressions)
# construct an expression
x <- rx_start_of_line() %>% 
  rx_maybe(' ') %>% 
  rx_find('http') %>% 
  rx_maybe('s') %>% 
  rx_find('://') %>% 
  rx_maybe('www.') %>% 
  rx_find('lattes.cnpq.br') %>% 
  rx_anything_but(' ') %>% 
  rx_end_of_line()

library(stringr)
#stringr::str_extract_all(links,x)
links<-str_extract(links,x)
links<-na.omit(links)

DM <- data.frame(nomes,links)

# save(PPGCP,DM,DMQ,file="C:/Users/Hp/Documents/GitHub/Miscellaneous_Functions_Rstats/Get_Lattes_Unirio/dados_UNIRIO_05_06_2021.RData")
