
# Fonte original desse codigo
# https://github.com/svmiller/stevemisc/



distribuicao_normal <- function(curvecolor, fillcolor, fontfamily) {
  if(missing(fontfamily)) {
    ggplot(data.frame(x = c(-4, 4)), aes(x)) +
      stat_function(fun = dnorm,
                    xlim = c(qnorm(.05),abs(qnorm(.05))), size=0,
                    geom = "area", fill=fillcolor, alpha=0.5) +
      stat_function(fun = dnorm,
                    xlim = c(qnorm(.025),abs(qnorm(.025))), size=0,
                    geom = "area", fill=fillcolor, alpha=0.4) +
      stat_function(fun = dnorm,
                    xlim = c(qnorm(.005),abs(qnorm(.005))), size=0,
                    geom = "area", fill=fillcolor, alpha=0.3) +
      geom_segment(x=1, y=0, xend=1, yend=dnorm(1,0,1), color="white", linetype="dashed") +
      geom_segment(x=-1, y=0, xend=-1, yend=dnorm(1,0,1), color="white", linetype="dashed") +
      annotate(geom = "text", x = 0, y = 0.2,
               label = "68,26%", size =4.5, color="white") +
      geom_segment(x=-0.15, y=.2, xend=-.99, yend=.2, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      geom_segment(x=0.15, y=.2, xend=.99, yend=.2, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      annotate(geom = "text", x = 0, y = 0.1,
               label = "90%", size =4.5, color="white") +
      geom_segment(x=-0.15, y=.1, xend=-1.64, yend=.1, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      geom_segment(x=0.15, y=.1, xend=1.64, yend=.1, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      annotate(geom = "text", x = 0, y = 0.05,
               label = "95,44%", size =4.5, color="white") +
      geom_segment(x=-0.15, y=.05, xend=-1.95, yend=.05, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      geom_segment(x=0.15, y=.05, xend=1.95, yend=.05, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      annotate(geom = "text", x = 0, y = 0.01,
               label = "99,74%", size =4.5, color="white") +
      geom_segment(x=-0.15, y=.01, xend=-2.57, yend=.01, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      geom_segment(x=0.15, y=.01, xend=2.57, yend=.01, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      stat_function(fun = dnorm, color=curvecolor, size=1.5) +
      scale_x_continuous(breaks=c(-4, -2.58, -1.96, -1.645, -1, 0,
                                  1, 1.645, 1.96, 2.58, 4))  }
  else {
    ggplot(data.frame(x = c(-4, 4)), aes(x)) +
      stat_function(fun = dnorm,
                    xlim = c(qnorm(.05),abs(qnorm(.05))), size=0,
                    geom = "area", fill=fillcolor, alpha=0.5) +
      stat_function(fun = dnorm,
                    xlim = c(qnorm(.025),abs(qnorm(.025))), size=0,
                    geom = "area", fill=fillcolor, alpha=0.4) +
      stat_function(fun = dnorm,
                    xlim = c(qnorm(.005),abs(qnorm(.005))), size=0,
                    geom = "area", fill=fillcolor, alpha=0.3) +
      geom_segment(x=1, y=0, xend=1, yend=dnorm(1,0,1), color="white", linetype="dashed") +
      geom_segment(x=-1, y=0, xend=-1, yend=dnorm(1,0,1), color="white", linetype="dashed") +
      annotate(geom = "text", x = 0, y = 0.2,
               label = "68%", size =4.5, color="white", family=fontfamily) +
      geom_segment(x=-0.15, y=.2, xend=-.99, yend=.2, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      geom_segment(x=0.15, y=.2, xend=.99, yend=.2, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      annotate(geom = "text", x = 0, y = 0.1,
               label = "90%", size =4.5, color="white", family=fontfamily) +
      geom_segment(x=-0.15, y=.1, xend=-1.64, yend=.1, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      geom_segment(x=0.15, y=.1, xend=1.64, yend=.1, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      annotate(geom = "text", x = 0, y = 0.05,
               label = "95%", size =4.5, color="white", family=fontfamily) +
      geom_segment(x=-0.15, y=.05, xend=-1.95, yend=.05, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      geom_segment(x=0.15, y=.05, xend=1.95, yend=.05, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      annotate(geom = "text", x = 0, y = 0.01,
               label = "99%", size =4.5, color="white", family=fontfamily) +
      geom_segment(x=-0.15, y=.01, xend=-2.57, yend=.01, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      geom_segment(x=0.15, y=.01, xend=2.57, yend=.01, color="white",
                   arrow = arrow(length = unit(0.15, "cm"))) +
      stat_function(fun = dnorm, color=curvecolor, size=1.5) +
      scale_x_continuous(breaks=c(-4, -2.58, -1.96, -1.645, -1, 0,
                                  1, 1.645, 1.96, 2.58, 4))
  }
}





library(ggplot2)
distribuicao_normal("#522d80","#F66733", "Open Sans") + 
    theme_steven_web() + post_bg() +
  # ^ all from stevemisc
  labs(title = "A área sob uma curva com distribuição normal",
       subtitle = "As caudas se estendem até o infinito. A curva normal aproxima-se do eixo horizontal assintoticamente conforme nos afastamos da média,  \n mas 95% de todos os valores possíveis estão dentro de cerca de 1,96 desvios de distância da média.",
       y = "Densidade",
       x = "")


# print("Propriedades da distribuição Normal padrão",warning=FALSE)
# print("  ",warning=FALSE)
# print("A área total sob a curva normal é igual a 1.",warning=FALSE)
# print("A área acumulada para z = 0 é 0,500.",warning=FALSE)
# print("A maior parte da área sob a curva normal com parâmetros μ e σ se encontram entre μ−3σ e μ+3σ.",warning=FALSE)
# print("A curva é simétrica em torno do eixo vertical que passa na média μ.",warning=FALSE)
# print("A curva normal aproxima-se do eixo horizontal assintoticamente conforme nos afastamos da média em qualquer direção.",warning=FALSE)



