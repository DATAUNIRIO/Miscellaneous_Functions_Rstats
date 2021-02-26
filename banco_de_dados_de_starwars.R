
remotes::install_github("gadenbuie/starwarsdb")

library(dplyr)
library(starwarsdb)
data(package = "starwarsdb")
schema

schema %>% 
  filter(endpoint == "films") %>% 
  pull(properties)


x_wing_pilots <- pilots %>% filter(vehicle == "X-wing")
x_wing_pilots


people %>% semi_join(x_wing_pilots, by = c(name = "pilot"))


#starwarsdb also includes the entire data set as a DuckDB database, appropriate for teaching and practicing remote database access with dbplyr.

con <- starwars_connect()

people_rmt <- tbl(con, "people")
pilots_rmt <- tbl(con, "pilots")
pilots_rmt

x_wing_pilots <- pilots_rmt %>% filter(vehicle == "X-wing")
x_wing_pilots
#> # Source:   lazy query [?? x 2]
#> # Database: duckdb_connection

people_rmt %>% semi_join(x_wing_pilots, by = c(name = "pilot"))
#> # Source:   lazy query [?? x 11]
#> # Database: duckdb_connection

# https://krlmlr.github.io/dm/
# devtools::install_github("krlmlr/dm")
library(dm, warn.conflicts = FALSE)

sw_dm <- starwars_dm()
sw_dm

sw_dm %>%
  dm_select_tbl(pilots, people) %>%
  dm_filter("pilots", vehicle == "X-wing") %>%
  dm_apply_filters() %>%
  dm_zoom_to("people") %>%
  semi_join(pilots)

dm_draw(sw_dm)

