# Fonte original desse codigo
# https://github.com/svmiller/stevemisc/



theme_steven_web <- function() {
  get_os <- function(){
    sysinf <- Sys.info()
    if (!is.null(sysinf)){
      os <- sysinf['sysname']
      if (os == 'Darwin')
        os <- "osx"
    } else { ## mystery machine
      os <- .Platform$OS.type
      if (grepl("^darwin", R.version$os))
        os <- "osx"
      if (grepl("linux-gnu", R.version$os))
        os <- "linux"
    }
    tolower(os)
  }
  if(get_os() == "osx") {
    theme_bw() +
      theme(panel.border = element_blank(),
            plot.margin = margin(15, 15, 15, 15),
            plot.caption=element_text(hjust=1, size=9,
                                      margin=margin(t=10),
                                      face="italic"),
            plot.title=element_text(hjust=0, size=18,
                                    margin=margin(b=10),
                                    face="bold", family='Titillium Web'),
            plot.subtitle=element_text(hjust=0,
                                       margin=margin(b=10),
                                       family='Open Sans'),
            axis.title.y=element_text(size=10,hjust=1,
                                      face="italic", family="Open Sans"),
            axis.title.x=element_text(hjust=1, size=10, face="italic", family="Open Sans",
                                      margin = margin(t = 10)), # , margin = margin(t = 10)
            legend.position = "bottom",
            legend.title = element_text(face="bold", family="Titillium Web"),
            text=element_text(family="Open Sans")) +
      theme(legend.spacing.x = unit(.1, 'cm'),
            panel.spacing = grid::unit(1.5, "lines"))
  }
  else {
    theme_bw() +
      theme(panel.border = element_blank(),
            plot.margin=margin(15, 15, 15, 15),
            plot.caption=element_text(hjust=1, size=9,
                                      margin=margin(t=10),
                                      face="italic"),
            plot.title=element_text(hjust=0, size=18,
                                    margin=margin(b=10),
                                    face="bold", family='Titillium Web'),
            plot.subtitle=element_text(hjust=0,
                                       margin=margin(b=10),
                                       family='Open Sans'),
            axis.title.y=element_text(size=10,hjust=1,
                                      face="italic", family="Open Sans"),
            axis.title.x=element_text(hjust=1, size=10, face="italic", family="Open Sans",
                                      margin = margin(t = 10)), # , margin = margin(t = 10)
            legend.position = "bottom",
            legend.title = element_text(face="bold", family="Titillium Web"),
            text=element_text(family="Open Sans")) +
      theme(legend.spacing.x = unit(.1, 'cm'),
            panel.spacing = grid::unit(1.5, "lines"))
  }
}

theme_steven_web2 <- function() {
  theme_steven_web() +
    theme(legend.title = element_text(family="Titillium WebBold"),
          plot.title=element_text(family='Titillium WebBold'))
}

post_bg <- function() {
  theme(plot.background = element_rect(fill = "#fdfdfd"),
        panel.background = element_rect(fill = "#fdfdfd"),
        legend.key = element_rect(fill = "#fdfdfd"),
        legend.background = element_rect(fill = "#fdfdfd"))
}