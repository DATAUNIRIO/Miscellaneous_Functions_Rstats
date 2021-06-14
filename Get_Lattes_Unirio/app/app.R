library(GetLattesData)
# get files from pkg (you can download from other researchers in lattes website)
# Demostracao
f.in <- c('C:/Users/Hp/Downloads/2970110332151340.zip', # Steven
          'C:/Users/Hp/Downloads/9421155244718142.zip', # Borba
          'C:/Users/Hp/Downloads/6225554673074879.zip', # Luciana Veiga
          'C:/Users/Hp/Downloads/6305743866339870.zip') # Vinicius
#'C:/Users/Hp/Downloads/4763659817918925.zip', # Fabio Simas
#'C:/Users/Hp/Downloads/7637282964789451.zip', # Acir
#'C:/Users/Hp/Downloads/6725560105680636.zip',  # Gladson
#'C:/Users/Hp/Downloads/2637672868100554.zip', # Cal Neto
#'C:/Users/Hp/Downloads/1619536438180209.zip') # Alexandre

#field.qualis = 'ADMINISTRAÇÃO PÚBLICA E DE EMPRESAS, CIÊNCIAS CONTÁBEIS E TURISMO'
field.qualis = 'CIÊNCIA POLÍTICA E RELAÇÕES INTERNACIONAIS' 
#field.qualis = c('CIÊNCIA POLÍTICA E RELAÇÕES INTERNACIONAIS','ECONOMIA')
#field.qualis = c("MATEMÁTICA / PROBABILIDADE E ESTATÍSTICA")

#all_field.qualis = c("ADMINISTRAÇÃO PÚBLICA E DE EMPRESAS, CIÊNCIAS CONTÁBEIS E TURISMO", "ANTROPOLOGIA / ARQUEOLOGIA", "ARQUITETURA, URBANISMO E DESIGN", "ARTES", "ASTRONOMIA / FÍSICA", "BIODIVERSIDADE", "BIOTECNOLOGIA", "CIÊNCIA DA COMPUTAÇÃO", "CIÊNCIA DE ALIMENTOS", "CIÊNCIA POLÍTICA E RELAÇÕES INTERNACIONAIS", "CIÊNCIAS AGRÁRIAS I", "CIÊNCIAS AMBIENTAIS", "CIÊNCIAS BIOLÓGICAS I", "CIÊNCIAS BIOLÓGICAS II", "CIÊNCIAS BIOLÓGICAS III", "CIÊNCIAS DA RELIGIÃO E TEOLOGIA", "COMUNICAÇÃO E INFORMAÇÃO", "DIREITO", "ECONOMIA", "EDUCAÇÃO", "EDUCAÇÃO FÍSICA", "ENFERMAGEM", "ENGENHARIAS I", "ENGENHARIAS II", "ENGENHARIAS III", "ENGENHARIAS IV", "ENSINO", "FARMÁCIA", "FILOSOFIA", "GEOCIÊNCIAS", "GEOGRAFIA", "HISTÓRIA", "INTERDISCIPLINAR", "LINGUÍSTICA E LITERATURA", "MATEMÁTICA / PROBABILIDADE E ESTATÍSTICA", "MATERIAIS", "MEDICINA I", "MEDICINA II", "MEDICINA III", "MEDICINA VETERINÁRIA", "NUTRIÇÃO", "ODONTOLOGIA", "PLANEJAMENTO URBANO E REGIONAL / DEMOGRAFIA", "PSICOLOGIA", "QUÍMICA", "SAÚDE COLETIVA", "SERVIÇO SOCIAL", "SOCIOLOGIA", "ZOOTECNIA / RECURSOS PESQUEIROS")

# get data
l.out <- gld_get_lattes_data_from_zip(f.in, field.qualis = field.qualis)

names(l.out)
dplyr::glimpse(l.out$tpublic.published)

tpublic.published <- l.out$tpublic.published

#.libPaths("/home/steven/R/x86_64-pc-linux-gnu-library/3.4")
#library(shiny, lib.loc="/home/steven/R/x86_64-pc-linux-gnu-library/3.4")
#library(magrittr, lib.loc="/home/steven/R/x86_64-pc-linux-gnu-library/3.4")
#library(shinyWidgets, lib.loc="/home/steven/R/x86_64-pc-linux-gnu-library/3.4")

library(shiny)
library(magrittr)
library(shinyWidgets)
ui <- fluidPage(#theme = "estilo.css",
  setBackgroundColor("#a7e5c2"),
  titlePanel("Painel de avaliação"),
  tags$h1("com base no lattes"),
  br(),
  
    mainPanel(
      prettyCheckbox(
        inputId = "pretty_1", label = "Borba", icon = icon("check")
      ),
      plotOutput("plot_lattes"))
  )

server <- function(input, output) {
  x<-reactive({input$pretty_1})
  
  output$plot_lattes<-renderPlot({
    if (x()==TRUE) {
        ggplot(tpublic.published, aes(x = qualis,fill=name)) +
          geom_bar(position = 'identity')+
          facet_wrap(~name) +
          scale_fill_manual(values = c("orange","blue","red","darkgreen"))+ 
          labs(x = paste0('Qualis'))
      } else {
      tpublic.published<-tpublic.published[tpublic.published$name!='Felipe de Moraes Borba',]
        ggplot(tpublic.published, aes(x = qualis,fill=name)) +
          geom_bar(position = 'identity')+
          facet_wrap(~name) +
          scale_fill_manual(values = c("orange","blue","red","darkgreen"))+ 
          labs(x = paste0('Qualis'))
        }
  })
}
shinyApp(ui = ui, server = server)


