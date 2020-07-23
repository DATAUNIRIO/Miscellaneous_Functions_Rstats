

# Pacote R com dados de pesquisas eleitorais compiladas pelo site Poder360 
# devtools::install_github("DATAUNIRIO/pollingBR")
# https://github.com/sergiospagnuolo/pollingBR/blob/master/vignettes/Introducao_pollingBR.md

# Extract data from all polls for president in 2018
library(pollingBR)
president_2018 <- president(2018)
# Extract data from first round polls for governor of Sao Paulo in 2014
governor_sp_2014 <- governor(2014, state = "SP", round = 1)
# Get data from spontaneous responses to polls for a senate seat in Minas Gerais in 2018
senator_mg_2018 <- senator(2018, state = "MG", type = 1)
#Besides those four basic functions, get_cities() 
#returns a data.frame containing the complete list for cities
#in which there are polls for mayoral elections in Brazil and 
#the corresponding years for which they are available.
cidades <- get_cities()
head(cidades)

# Extrai dados de todas as pesquisas de abrangencia nacional para presidente em 2014
presidente_br_2014 <- president(2014, state = "BR")
# Obtem dados de todas as pesquisas para senador nos estados do sul do pais em 2010
senador_sul_2010 <- senator(2010, state = c("RS", "SC", "PR"))
# Obtem dados de respostas espontaneas e estimuladas para pesquisas para o senado em SP no ano de 2006
senado_sp_2006 <- senator(2006, state = "SP", type = c(1, 2))
# Extrai dados de respostas de rejeicao em pesquisas nacionais para presidente em 2018
presidente_rejeicao_2018 <- president(2018, state = "BR", type = 3)
#Por fim, o argumento round registra se o banco de dados traz informações de pesquisas para o primeiro ou segundo turno das eleições (o padrão das funções retorna os dados para os dois turnos). Como as eleições para senador são de turno único, a função senator() não contém esse argumento.
# Extrai os dados de todas as respostas estimuladas de pesquisas para o primeiro turno de eleicoes para prefeito em 2012
prefeito_2012_1t <- mayor(2012, type = 2, round = 1)

#Outras funções
#A função get_cities() retorna um data.frame com os registros de todas as cidades com pesquisas eleitorais para prefeitos encontradas no repositório de dados do Poder360, com os respectivos anos para os quais estão disponíveis. Dessa forma, o usuário tem acesso fácil a quais pesquisas municipais ele tem à sua disposição no repositório.
