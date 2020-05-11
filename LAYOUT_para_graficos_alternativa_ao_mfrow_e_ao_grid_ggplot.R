


x <- rnorm(1000)
jpeg("normdist.jpg")

# Para fazer gráficos 4 graficos em 3 linhas e 2 colunas
layout(mat=matrix(c(1,1,2,3,4,4),nrow=3,ncol=2,byrow=T))
boxplot(x, horizontal=T)
hist(x)
plot(density(x))
plot(x)
dev.off()


# desenvolver função despois