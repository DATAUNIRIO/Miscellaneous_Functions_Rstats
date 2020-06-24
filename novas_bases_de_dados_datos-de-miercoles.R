#https://github.com/cienciadedatos/datos-de-miercoles/

tempo_de_tela<- readr::read_csv("https://raw.githubusercontent.com/cienciadedatos/datos-de-miercoles/master/datos/2019/2019-04-17/tiempo_pantalla.csv")
mudancas_aliancas <- readr::read_csv("https://raw.githubusercontent.com/cienciadedatos/datos-de-miercoles/master/datos/2019/2019-04-17/cambio_lealtades.csv")
personagens_livro <- readr::read_csv("https://raw.githubusercontent.com/cienciadedatos/datos-de-miercoles/master/datos/2019/2019-04-17/personajes_libro.csv")

#traducao dos nomes
colnames(tempo_de_tela)<-c("nome","minutos","episodios")
dicionario_dados<-c("nome do personagem","Número de minutos na tela (temporadas 1 a 6)",
"Número de episódios em que apareceu (temporadas 1 a 6)")

# traducao do dicionario
attr(tempo_de_tela, "variable.labels") <- dicionario_dados
attributes(tempo_de_tela)
#----------------------------------------------------------------------

colnames(mudancas_aliancas)<-c("nome","origem","Lealdade1","Lealdade1",
                               "Lealdade2","Lealdade3","Lealdade4",
                               "Lealdade5","Lealdade6","Lealdade7",
                               "episodios")

attr(mudancas_aliancas, "variable.labels") <- c("nome do personagem","casa de origem do personagem",
"Lealdade do personagem no final da 1ª temporada",
"Lealdade do personagem no final da 2ª temporada",
"Lealdade do personagem no final da 3ª temporada",
"Lealdade do personagem no final da 4ª temporada",
"Lealdade do personagem no final da 5ª temporada",
"Lealdade do personagem no final da 6ª temporada",
"Lealdade do personagem no final da 7ª temporada",
"Número de episódios em que apareceu (temporadas 1 a 7)")

attributes(mudancas_aliancas)

names(personagens_livro)<-c("nome","lealdade","sexo","nobre","Guerra_dos_Tronos",
"Furia_dos_Reis","Tormenta_de_Espadas","Festim_dos_Corvos",
"Danca_dos_Dragoes","capitulo_apresentacao","ano_morte",
"livro inteiro da morte", "capitulo_morte")

attr(personagens_livro, "variable.labels")<-c("nome do personagem","qual casa ele é leal","gênero do personagem",
"nobre (1 = nobre; 0 = não)",
"Se aparece ou não neste livro da saga (1 = sim; 0 = não)",
"Se aparece ou não neste livro da saga (1 = sim; 0 = não)",
"Se aparece ou não neste livro da saga (1 = sim; 0 = não)",
"Se aparece ou não neste livro da saga (1 = sim; 0 = não)",
"Se aparece ou não neste livro da saga (1 = sim; 0 = não)",
"Se aparece ou não neste livro da saga (1 = sim; 0 = não)",
"Ano em que ele morreu (apenas para alguns personagens)",
"Livro da saga em que ele morre (1 = Game of Thrones, 2 = Clash of Kings, etc.)",
"Em que capítulo desse livro ele morre")

attributes(personagens_livro)

attr(personagens_livro, "variable.labels")
