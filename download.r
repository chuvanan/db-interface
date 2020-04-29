


require(here)

nfl_links = sprintf("https://raw.githubusercontent.com/guga31bb/nflfastR-data/master/data/play_by_play_%s.csv", 2000:2019)
nfl_files = sprintf("nfl_play_by_play_%s.csv", 2000:2019)


for (i in seq_along(nfl_files)) {
    tryCatch(
        expr = download.file(url = nfl_links[i], destfile = here("data", nfl_files[i])),
        error = function(e) {
            message("[DEBUG] Error while downloading file: ", nfl_links[i])
            message(e)
        }
    )
}
