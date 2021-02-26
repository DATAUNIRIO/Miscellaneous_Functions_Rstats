# https://statquest.org/video-index/

## NOTE: The data used in this demo comes from the UCI machine learning repository.
## http://archive.ics.uci.edu/ml/index.php

#url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.cleveland.data"
#data <- read.csv(url, header=FALSE)


#f <-file("http://archive.ics.uci.edu/ml/machine-learning-databases/car/car.data", open="r" ,encoding="UTF-16LE")
f <-url("http://archive.ics.uci.edu/ml/machine-learning-databases/car/car.data")
dados_carros <- try(read.table(f,sep = ","))


#Valores de classe: inaceitável, aceitável, bom, muito bom
#chance_de_revenda: muito alta, alto, médio, baixo.
#manutenção: muito alta, alta, média, baixa.
#portas: 2, 3, 4, 5 mais.
#pessoas: 2, 4 ou mais.
#espaço para bagagem: pequeno, médio, grande.
#segurança do veículo: baixa, média, alta.

#Class Values: unacc, acc, good, vgood
#buying: vhigh, high, med, low.
#maint: vhigh, high, med, low.
#doors: 2, 3, 4, 5more.
#persons: 2, 4, more.
#lug_boot: small, med, big.
#safety: low, med, high. 

nomes3<-c("classificacao","chance_de_revenda","manutencao","portas","pessoas","bagagem","seguranca")
colnames(dados_carros)<-nomes3
nomes4<-c("classificacao: classificação","chance_de_revenda: chance de revender o carro","manutencao:manutenção","portas: quantidade de portas","pessoas: quantidade de pessoas","bagagem: espaço para bagagem","seguranca: segurança do veículo")
attr(dados_carros, "variable.labels") <- nomes4
#attributes(dados_carros)
remove(f,nomes3,nomes4)

#----------------------------------------------------------------------------------------
#
# Student Performance Data Set
#
#----------------------------------------------------------------------------------------

#This data approach student achievement in secondary education of two Portuguese schools. The data attributes include student grades, demographic, social and school related features) and it was collected by using school reports and questionnaires. 
#Two datasets are provided regarding the performance in two distinct subjects: Mathematics (mat) and Portuguese language (por). In [Cortez and Silva, 2008], the two datasets were modeled under binary/five-level classification and regression tasks. 
#Important note: the target attribute G3 has a strong correlation with attributes G2 and G1. 
#This occurs because G3 is the final year grade (issued at the 3rd period), while G1 and G2 correspond to the 1st and 2nd period grades. 
#It is more difficult to predict G3 without G2 and G1, but such prediction is much more useful (see paper source for more details).

url = "http://archive.ics.uci.edu/ml/machine-learning-databases/00320/student.zip"
download.file(url, "student.zip") # download file
unzip("student.zip", exdir = "data") # unzip files

d1=read.table("data/student-mat.csv",sep=";",header=TRUE)
d2=read.table("data/student-por.csv",sep=";",header=TRUE)

dados_estudantes=merge(d1,d2,by=c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet"))
#print(nrow(d3)) # 382 students
file.remove("student.zip") # tidy up by removing the zip file
file.remove("data/student-mat.csv") # tidy up by removing the zip file
file.remove("data/student-por.csv") # tidy up by removing the zip file
file.remove("data/student-merge.R") # tidy up by removing the zip file
file.remove("data/student.txt") # tidy up by removing the zip file
remove(d1,d2,url)

#table(dados_estudantes$traveltime.x,dados_estudantes$traveltime.y)
#table(dados_estudantes$freetime.x,dados_estudantes$freetime.y)
#table(dados_estudantes$guardian.x,dados_estudantes$guardian.y)


selecao<-c("school","sex","age","address","famsize","Pstatus",
           "Medu","Fedu", "Mjob","Fjob","reason","nursery",
           "internet","guardian.x","traveltime.x", "studytime.x", 
           "failures.x",   "schoolsup.x"  ,"famsup.x","paid.x",      
           "activities.x", "higher.x"     ,"romantic.x","famrel.x",    
           "freetime.x","goout.x","Dalc.x","Walc.x","health.x",
           "absences.x","G1.x","G2.x","G3.x","G1.y","G2.y","G3.y")        
dados_estudantes<-dados_estudantes[,selecao]

nomes<-c(
  "escola" ,           #1 school - student's school (binary: "GP" - Gabriel Pereira or "MS" - Mousinho da Silveira)
  "sexo" ,             #2 sex - student's sex (binary: "F" - female or "M" - male)
  "idade" ,            #3 age - student's age (numeric: from 15 to 22),
  "local_moradia" ,    #4 address - student's home address type (binary: "U" - urban or "R" - rural)
  "tamanho_familia" ,  #5 famsize - family size (binary: "LE3" - less or equal to 3 or "GT3" - greater than 3)
  "situacao_pais" ,    #6 Pstatus - parent's cohabitation status (binary: "T" - living together or "A" - apart)
  "escolaridade_mae", #7 Medu - mother's education (numeric: 0 - none,  1 - primary education (4th grade), 2 – 5th to 9th grade, 3 – secondary education or 4 – higher education)
  "escolaridade_pai", #8 Fedu - father's education (numeric: 0 - none,  1 - primary education (4th grade), 2 – 5th to 9th grade, 3 – secondary education or 4 – higher education)
  "emprego_mae",      #9 Mjob - mother's job (nominal: "teacher", "health" care related, civil "services" (e.g. administrative or police), "at_home" or "other")
  "emprego_pai",      #10 Fjob - father's job (nominal: "teacher", "health" care related, civil "services" (e.g. administrative or police), "at_home" or "other")
  "motivo",           #11 reason - reason to choose this school (nominal: close to "home", school "reputation", "course" preference or "other")
  
  #isso acontece por causa do uso de duas variaveis como chave para o merge
  "fez_fundamental",  #20 nursery - attended nursery school (binary: yes or no)
  "internet",         #22 internet - Internet access at home (binary: yes or no)
  
  "responsavel",      #12 guardian - student's guardian (nominal: "mother", "father" or "other")
  "tempo_casa_escola",#13 traveltime - home to school travel time (numeric: 1 - <15 min., 2 - 15 to 30 min., 3 - 30 min. to 1 hour, or 4 - >1 hour)
  "tempo_estudo",     #14 studytime - weekly study time (numeric: 1 - <2 hours, 2 - 2 to 5 hours, 3 - 5 to 10 hours, or 4 - >10 hours)
  "reprovacoes",      #15 failures - number of past class failures (numeric: n if 1<=n<3, else 4)
  "apoio_escola",     #16 schoolsup - extra educational support (binary: yes or no)
  "apoio_familia",    #17 famsup - family educational support (binary: yes or no)  
  "aula_reforco",     #18 paid - extra paid classes within the course subject (Math or Portuguese) (binary: yes or no)
  "atividade_extra",  #19 activities - extra-curricular activities (binary: yes or no)
  "graduacao",        #21 higher - wants to take higher education (binary: yes or no)
  "namorando",        #23 romantic - with a romantic relationship (binary: yes or no)
  "qual_rel_fam",     #24 famrel - quality of family relationships (numeric: from 1 - very bad to 5 - excellent)            
  "tempolivre",       #25 freetime - free time after school (numeric: from 1 - very low to 5 - very high)
  "sai_com_amigos",   #26 goout - going out with friends (numeric: from 1 - very low to 5 - very high)
  "bebe_semana",      #27 Dalc - workday alcohol consumption (numeric: from 1 - very low to 5 - very high)
  "bebe_fim_semana",  #28 Walc - weekend alcohol consumption (numeric: from 1 - very low to 5 - very high)
  "saude",            #29 health - current health status (numeric: from 1 - very bad to 5 - very good)
  "faltas",           #30 absences - number of school absences (numeric: from 0 to 93) 
  "nota_primeiro_ano_MAT",#31 G1 - first period grade (numeric: from 0 to 20)
  "nota_segundo_ano_MAT", #31 G2 - second period grade (numeric: from 0 to 20)
  "nota_terceiro_no_MAT",  #32 G3 - final grade (numeric: from 0 to 20, output target)  
  "nota_primeiro_ano_POR",#31 G1 - first period grade (numeric: from 0 to 20)
  "nota_segundo_ano_POR", #31 G2 - second period grade (numeric: from 0 to 20)
  "nota_terceiro_no_POR"  #32 G3 - final grade (numeric: from 0 to 20, output target)  
)


colnames(dados_estudantes)<-nomes
remove(selecao,nomes)

# these grades are related with the course subject, Math or Portuguese:

levels(dados_estudantes$emprego_mae) <- c('do lar','serviços de saúde', 'outros', 'policial' ,'professora')
levels(dados_estudantes$emprego_pai) <- c('do lar','serviços de saúde', 'outros', 'policial' ,'professor')
levels(dados_estudantes$motivo)<- c("preferência do curso","próximo de casa", "outro","reputação da escola")
levels(dados_estudantes$fez_fundamental)<- c("Não","Sim")
levels(dados_estudantes$internet)<- c("Não","Sim")
levels(dados_estudantes$responsavel)<-c("pai","mãe","outro")
levels(dados_estudantes$apoio_escola)<- c("Não","Sim")
levels(dados_estudantes$apoio_familia)<- c("Não","Sim")
levels(dados_estudantes$aula_reforco)<- c("Não","Sim")
levels(dados_estudantes$atividade_extra)<- c("Não","Sim")
levels(dados_estudantes$graduacao)<- c("Não","Sim")
levels(dados_estudantes$namorando)<- c("Não","Sim")

nomes2<-c(
  "escola ('GP' = Gabriel Pereira or 'MS' = Mousinho da Silveira)",
  "sexo ('F' = feminino ou 'M' = masculino)",
  "idade (de 15 até 22 anos)",
  "local_moradia ('U' = urbano ou 'R' = rural)",
  "tamanho_familia ('LE3' = três pessoas ou menos ou 'GT3' = mais de três pessoas)",
  "situacao_pais ('T'= vivendo junto ou 'A' = separados)",
  "escolaridade_mae (0 = nenhuma,  1 = fundamental 1 (até a quarta série), 2 = fundamental 2 (quinta a nona série), 3 = ensino médio ou 4 = superior)",
  "escolaridade_pai (0 = nenhuma,  1 = fundamental 1 (até a quarta série), 2 = fundamental 2 (quinta a nona série), 3 = ensino médio ou 4 = superior)",
  "emprego_mae (professora, serviços de saúde, policiais, do lar, outros)",
  "emprego_pai (professor, serviços de saúde, policiais, do lar, outros)",      
  "motivo (motivo para escolher esta escola (próximo de casa, reputação da escola, preferência do curso ou outra)",           #11 reason - reason to choose this school (nominal: close to "home", school "reputation", "course" preference or "other")
  
  #isso acontece por causa do uso de duas variaveis como chave para o merge
  "fez_fundamental (fez escola fundamental frequentada)",
  "internet (acesso à internet em casa)",       
  
  "responsavel (responsável pelo estudante: mãe, pai, outro)",
  "tempo_casa_escola (tempo de casa até a escola: 1 = < 15 min., 2 = 15 to 30 min., 3 = 30 min. to 1 hour, ou 4 = >1 hora)", 
  "tempo_estudo (1 = <2 horas, 2 = De 2 até 5 horas, 3 = De 5 até 10 horas, ou 4 = >10 horas)",     
  "reprovacoes (número de reprovações)", 
  "apoio_escola (Tem apoio educacional extra)",
  "apoio_familia (Tem apoio educacional da família)",  
  "aula_reforco (Tem aulas de reforço extras pagas)",  
  "atividade_extra (Tem  atividades extra-curricular)",
  "graduacao (estudante quer fazer ensino superior)",
  "namorando (estudante está namorando)",
  "qual_rel_fam (qualidade das relações familiares: 1 = muito ruim e 5 = excelente)",     
  "tempolivre (tempo livre depois da escola: 1 = pouco tempo, 5 = muito tempo)", 
  "sai_com_amigos (1 = pouco, 5 = muito)",  
  "bebe_semana (bebe na semana: 1 = pouco, 5 = muito)",
  "bebe_fim_semana (bebe no fim de semana: 1 = pouco, 5 = muito)",
  "saude (estado de saúde atual: 1 = péssimo, 5 =ótimo)",
  
  "faltas (número de faltas no ano)",
  "nota_primeiro_ano_MAT (Nota em Matemática no primeiro ano: de zero até vinte)",
  "nota_segundo_ano_MAT  (Nota em Matemática no segundo ano: de zero até vinte)", 
  "nota_terceiro_no_MAT  (Nota em Matemática no terceiro ano: de zero até vinte)",  #32 G3 - final grade (numeric: from 0 to 20, output target)  
  "nota_primeiro_ano_POR (Nota em Português no primeiro ano: de zero até vinte)",
  "nota_segundo_ano_POR (Nota em Português no segundo ano: de zero até vinte)", 
  "nota_terceiro_no_POR (Nota em Português no terceiro ano: de zero até vinte)")  

attr(dados_estudantes, "variable.labels") <- nomes2
remove(nomes2)

attributes(dados_carros)
attributes(dados_estudantes)

cat(paste0("Acesse o site: http://archive.ics.uci.edu/ml/datasets/Student%2BPerformance ou http://archive.ics.uci.edu/ml/datasets/Car+Evaluation para maiores informaçoes sobre os dois bancos de dados", "\n","\n"))

cat(paste0('Um exemplo de analise:' ,"\n",'boxplot(dados_estudantes$nota_terceiro_no_POR~dados_estudantes$sexo) ', '\n',"\n"))

cat('Escreva "attributes(dados_estudantes)" ou  "attributes(dados_carros)"para acessar ao dicionario de dados')