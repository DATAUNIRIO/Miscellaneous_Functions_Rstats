#Merry Christmas 2020 from Zak & Jenna Neal
set.seed(1225)

#### Import data ####
data <- matrix(c(0,1,1,0,0,0,0,1,0,0,0,0,1,0,0,0,1,0,1,1,0,0,1,0,0,1,1,0,1,1,0,0,
                 1,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1,1,1,1,0,0,0,0,0,1,0,1,1,0,0,0,
                 0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,1,1,0,
                 0,1,1,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,1,
                 0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0,1,1,0,1,0,0,
                 1,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,
                 0,0,1,1,0,0,0,0,1,0,0,0,1,0,0,0,1,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,
                 0,0,1,1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,
                 1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,
                 1,0,1,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,
                 0,0,0,0,0,0,1,0,0,0,0,0,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,
                 0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,1,0,0,
                 0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,
                 0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,0,0,0,1,0,0,0,0,0,0,
                 0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,
                 0,0,1,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,
                 0,1,1,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,
                 0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,
                 1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,
                 0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,
                 1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1,0,0,0,0,0,0,
                 0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,
                 0,0,0,1,0,0,1,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,
                 0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,
                 1,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,
                 0,1,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,
                 0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,1,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,
                 0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,
                 0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,
                 0,0,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0), 
               nrow = 38, ncol = 32, byrow = TRUE)
rownames(data) <- c("Elf (2003)","Fred Claus (2007)","A Christmas Movie Christmas (2019)",
                    "A Snow Globe Christmas (2013)","National Lampoon's Christmas Vacation (1989)",
                    "It's a Wonderful Life (1946)","Scrooged (1988)","The Family Man (2000)",
                    "Christmas a la Mode (2019)","Christmas on the Vine (2020)","Frosty the Snowman (1969)",
                    "Happiest Season (2020)","Love Actually (2013)","The Knight Before Christmas (2019)",
                    "A Christmas Prince (2017)","A Sugar and Spice Holiday (2020)",
                    "Christmas Unwrapped (2020)","Nestor, the Long-Eared Christmas Donkey (1977)",
                    "Poinsettias for Christmas (2018)","Rudolph the Red-Nosed Reindeer (1964)",
                    "The Christmas Edition (2020)","The Polar Express (2004)",
                    "The Year Without a Santa Claus (1974)","A Very Nutty Christmas (2018)",
                    "Christmas Cupcakes (2018)","Feliz NaviDAD (2020)","Holiday in Handcuffs (2007)",
                    "The Princess Switch (2018)","Twas the Night Before Christmas (1974)",
                    "A Charlie Brown Christmas (1965)","A Christmas Story (1983)",
                    "A Very Charming Christmas Town (2020)","Home Alone (1990)",
                    "How the Grinch Stole Christmas (1966)","The Man Who Invented Christmas (2017)",
                    "A Taste of Christmas (2020)","Four Christmases (2008)","Planes, Trains, and Automobiles (1987)")
colnames(data) <- c("Failing farm/business","Dead parent","Workaholic","Supernatural",
                    "Turns out to be santa","Return to small town","Unexplained climate",
                    "Difficult relatives","Rekindle old flame","Kidnapping","Pageant",
                    "Baking competition","Adult regains belief","Child loses belief",
                    "Inanimate object comes to life","Magical clothing","Harrowing travel",
                    "Santa's wayward family","Christmas is cancelled/saved","Evil businessperson",
                    "Alone at the holidays","Infidelity","Fanciful department store",
                    "Escape to a new place","Prince/princess of a fake country",
                    "Christmas Eve Deadline","Over the Top Decoration","Watching Xmas Movie",
                    "Magical Animals","Tree Mishap","Soldier Comes Home","How it could've been")

#### Extract the backbone of the co-trope bipartite projection ####
library(backbone)
backbone <- fdsm(data, trials = 2500, progress = TRUE)
backbone <- backbone.extract(backbone, alpha = .5, signed = FALSE)
# ^ This is a ridiculously liberal alpha, but cut Santa some slack...

#### Prepare the network ####
library(igraph)
network <- graph_from_adjacency_matrix(backbone, mode = "undirected")  #Convert to igraph object
network <- delete.vertices(network, which(degree(network)==0))  #Remove isolates

library(stringr)
V(network)$name <- str_replace_all(V(network)$name, " ", "\n")  #Make labels look nice
V(network)$name <- str_replace_all(V(network)$name, "A\n", "A ")
V(network)$name <- str_replace_all(V(network)$name, "\na\n", "\na ")
V(network)$name <- str_replace_all(V(network)$name, "The\n", " The ")
V(network)$name <- str_replace_all(V(network)$name, "\nthe\n", " the\n")
V(network)$name <- str_replace_all(V(network)$name, "\nand\n", " &\n")
V(network)$name <- str_replace_all(V(network)$name, "\nin\n", " in\n")
V(network)$name <- str_replace_all(V(network)$name, "\nof\n", " of\n")

community <- spinglass.community(network, spins = 4)  #Find communities
V(network)$color <- community$membership              #and make them Christmasy colors
V(network)[V(network)$color == 1]$color <- rgb(.77,.26,.27,.5)
V(network)[V(network)$color == 2]$color <- rgb(0,.53,.24,.5)
V(network)[V(network)$color == 3]$color <- rgb(.83,.68,.21,.5)
V(network)[V(network)$color == 4]$color <- rgb(.75,.75,.75,.5)

weights <- ifelse(crossing(community, network), .6, .4)  #Create a layout to
layout <- layout_with_kk(network, weights = weights)     #highlight communities

#### Plot the network ####
par(mar=c(0,0,0,0))
plot(network, layout = layout,
     vertex.label.cex = .5, vertex.label.color = "black", vertex.label.font = 2, vertex.label.family = "sans",
     vertex.frame.color = NA, vertex.size = 20)