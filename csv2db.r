

require(here)
require(DBI)
dir_ls = fs::dir_ls
fread = data.table::fread
rbindlist = data.table::rbindlist

## grab csv files
nfl_files = dir_ls(here(), regexp = "nfl.*\\.csv$")

## read them one by one
nfl_list = vector(mode = "list", NROW(nfl_files))

for (i in seq_along(nfl_list)) {
    nfl_list[[i]] = tryCatch(
        expr = fread(nfl_files[i], sep = ","),
        error = function(e) {
            message("Error while reading file: ", nfl_files[i])
            message(e)
            return(NULL)
        }
    )
}

## combine them all
nfl_all = rbindlist(nfl_list)

## now, write it to `.sqlite`
nfl_db = DBI::dbConnect(drv = RSQLite::SQLite(), here("nfl.sqlite"))
DBI::dbWriteTable(conn = nfl_db, name = "nfl_2000_2019", nfl_all)
