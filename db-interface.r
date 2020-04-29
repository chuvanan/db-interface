

require(here)
require(dbplyr)
require(dplyr)
require(tictoc) # for fun
require(ragg)   # for high quality graphics
require(ggplot2)
theme_set(theme(text = element_text(family = "Roboto Condensed", size = getOption("base_size"))))

dark2_colors = sample(palette(value = "Dark 2"), size = 2L) # R-4.0.0 color palette's so beautiful

conn = DBI::dbConnect(drv = RSQLite::SQLite(), here("data", "nfl.sqlite")) # connecting to database
nfl = tbl(conn, "nfl_2000_2019") # make a reference to table `nfl_2000_2019`


## aggregate data without 'collect' result (View?)

tic()
nfl %>%
    select(play_type, yards_gained, penalty, season) %>%
    filter(play_type %in% c("run", "pass") & penalty == 0) %>%
    group_by(season, play_type) %>%
    summarise(n = n(),
              avg_yds = mean(yards_gained, na.rm = TRUE)) %>%
    ungroup()
toc()


## aggregate data and materialise result

tic()
average_yards_gained = nfl %>%
    select(play_type, yards_gained, penalty, season) %>%
    filter(play_type %in% c("run", "pass") & penalty == 0) %>%
    group_by(season, play_type) %>%
    summarise(n = n(),
              avg_yds = mean(yards_gained, na.rm = TRUE)) %>%
    ungroup() %>%
    collect()
toc()

agg_png(filename = "average-yards-gained-all-season.png", width = 7, height = 7, units = "in", res = 280)
ggplot(average_yards_gained,
       aes(season, avg_yds, color = play_type)) +
    geom_line(size = 1.3) +
    scale_color_manual(values = dark2_colors) +
    labs(title = "How Many Yards Gained On Average?") +
    theme(legend.position = "top")
dev.off()
