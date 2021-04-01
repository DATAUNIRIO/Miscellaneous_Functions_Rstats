# https://pastebin.com/wkBm65P7

# pacotes ------------------------------------------------

library(purrr)
library(rvest)
library(magrittr)

# parâmetros ------------------------------------------------

urlbase <- 
  paste0(
    "https://www.gov.br/planalto/pt-br/acompanhe-o-planalto/",
    "agenda-do-presidente-da-republica/"
  )

datas <- 
  as.Date("2019-01-01"):as.Date("2021-03-20") %>% 
  as.Date(origin = "1970-01-01") %>% 
  as.character()

# 2a abordagem ------------------------------------------------

extrai_texto <- function(item, css){
  return(item %>% html_node(css = css) %>% html_text())
}

compromissos_itens <- function(item, data) {
  return(
    data.frame(
      data   = data, 
      evento = extrai_texto(item, ".compromisso-titulo"),
      inicio = extrai_texto(item, ".compromisso-inicio"),
      fim    = extrai_texto(item, ".compromisso-fim"),
      local  = extrai_texto(item, ".compromisso-local"),
      stringsAsFactors = FALSE
    )
  )
}

my_read_html <- purrr::insistently(read_html)

compromissos_data <- function(data, urlbase) {
  itens <- 
    data %>% 
    paste0(urlbase, .) %>% 
    my_read_html() %>% 
    html_nodes(css = ".item-compromisso")
  
  if (length(itens) == 0) return(NULL)
  
  if (
    is.na(
      itens[1] %>% 
      html_node(css = ".compromisso-titulo") %>% 
      html_text()
    )
  ) return(NULL)
  
  if (
    itens[1] %>% 
    html_node(css = ".compromisso-titulo") %>% 
    html_text() %>% 
    stringr::str_to_lower() ==
    "sem compromisso oficial"
  ) return(NULL)
  
  cat(data, "\n")
  
  return(map2_dfr(itens, data, compromissos_itens))
  
}

agenda_bozo <- 
  map_dfr(
    datas, 
    partial(
      compromissos_data, 
      urlbase = urlbase
    )
  )

write.csv2(agenda, "agenda_bozo.csv")
saveRDS(agenda, "agenda_bozo.RDS")