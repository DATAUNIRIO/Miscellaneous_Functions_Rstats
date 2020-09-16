##================================================================================================
##                                                                                              
##    Nome: Função para criar nomes de variáveis                                           
##                                                    
##    Objetivo: remover caracteres especiais e espaços em branco para criar nomes de variáveis
##    prof. Steven Dutt-Ross                          
##    UNIRIO           
##================================================================================================

criar_nomes <-function(string){
  string<-chartr("áéíóúÁÉÍÓÚýÝàèìòùÀÈÌÒÙâêîôûÂÊÎÔÛãõÃÕñÑäëïöüÄËÏÖÜÿçÇ",
                                    "aeiouaeiouyyaeiouaeiouaeiouaeiouaoaonnaeiouaeiouycc",string)
  gsub("\\s+", "_", tolower(string))
}

exemplo<-paste0("EXEMPLO DE FUNCIONAMENTO \n
nomes<-names(df)  \n
source('https://raw.githubusercontent.com/DATAUNIRIO/Miscellaneous_Functions_Rstats/master/criar_nomes.R',encoding = 'UTF-8') \n
novos_nomes<-criar_nomes(nomes)  \n
colnames(df)<-novos_nomes")
message(exemplo)

# Teste de funcionamento
#string <- c("R package","meu teste de funcionamento","Estatística e Probabilidade","Estatística para a Educação Básica")
#criar_nomes(string)
