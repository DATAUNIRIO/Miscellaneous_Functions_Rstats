
require(RcmdrMisc)
Basededados <- readXL("BasesEstados.xlsx", rownames=FALSE, 
  header=TRUE, na="", sheet="dados", stringsAsFactors=TRUE)
summary(Basededados)

require(treemap)

# Estrutura Geral
#treemap(NOMEDABASEDEDADOS,index="NOMEDAVARIAVELQUALITATIVA",vSize = "NOMEDAVARIAVEL1",vColor="NOMEDAVARIAVEL2", type="value",
#        palette = "Greens", title="TITULODOGRAFICO", 
#        fontsize.title = 14)

treemap(Basededados,index="Região",vSize = "PIB", type="index",
        palette = "Greens", title="Produto Interno Bruto PIB", 
        fontsize.title = 14)

treemap(Basededados,index="Estado",vSize = "PIB", type="index",
        palette = "Blues", title="Produto Interno Bruto PIB", 
        fontsize.title = 14)

x11()
treemap(Basededados,index="Estado",vSize = "PIB",vColor="PIB", type="value",
        palette = "RdYlBu", title="Produto Interno Bruto PIB", 
        bg.labels=c("transparent"),  
        fontsize.title = 14)



# Como fazer o Treemap das despesas correntes por UF?
# 5 minutos
#treemap(NOMEDABASEDEDADOS,index="NOMEDAVARIAVELQUALITATIVA",vSize = "NOMEDAVARIAVEL1",vColor="NOMEDAVARIAVEL2", type="value",
#        palette = "Greens", title="TITULODOGRAFICO", 
#        fontsize.title = 14)




#############################################################################
x11()
treemap(Basededados,index=c("Região","Estado"),vSize = "PIB",vColor="PIB", type="value",
        palette="RdYlBu", title="Produto Interno Bruto PIB", 
        fontsize.title = 12)
#############################################################################
x11()
treemap(Basededados,index=c("Região","Estado"),vSize = "PIB",vColor="PIB", type="value",palette="RdYlBu",
    fontsize.labels=c(14,11),                # Tamanho da fonte.
    fontcolor.labels=c("skyblue","orange"),  # Cor da fonte
    fontface.labels=c(2,1),                  # 1,2,3,4 para normal, negrito, italico, negrito-italico. Nesse caso, regiao em "negrito" e Estado "normal"
    bg.labels=c("transparent"),              # Cor de fundo (background) da letra/fonte
    align.labels=list(
        c("center", "center"), 
        c("right", "bottom")
        ),                                   # Where to place labels in the rectangle?
    overlap.labels=0.5,                      # number between 0 and 1 that determines the tolerance of the overlap between labels. 0 means that labels of lower levels are not printed if higher level labels overlap, 1  means that labels are always printed. In-between values, for instance the default value .5, means that lower level labels are printed if other labels do not overlap with more than .5  times their area size.
    inflate.labels=F,                        # If true, labels are bigger when rectangle is bigger.
)

#############################################################################
# Como faze esse gráfico de forma interativa?
