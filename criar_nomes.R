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

# Teste de funcionamento
#string <- c("R package","meu teste de funcionamento","Estatística e Probabilidade","Estatística para a Educação Básica")
#criar_nomes(string)
