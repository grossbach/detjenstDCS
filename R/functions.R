get_patient_code <- function(path) {
  relevant_dirs <- list.dirs(path = path,
                             full.names = TRUE,
                             recursive = TRUE)
  patient_codes <- gsub(path,
                        "",
                        relevant_dirs)
  patient_codes <- gsub(paste0(.Platform$file.sep, "Februar"),
                        "",
                        patient_codes[-1])
  return(patient_codes)
}
get_day_numbers <- function(filenames) {
  numbers <- sort(unique(as.numeric(gsub("d",
                                         "",
                                         x = stringr::str_extract(basename(filenames),
                                                                  pattern = "d\\d{1,2}")))))
}
get_correct_fnames <- function(all_fnames, p_code, day, time_, stat) {
  fnames <- NULL
  base_names <- basename(all_fnames)
  p_code <- paste0(p_code, "_")
  # day <- paste0("d", day, "_")
  time_ <- paste0(time_, "_")
  for (p in p_code) {
    for (d in day) {
      for (t in time_) {
        for (s in stat) {
          # if (nchar(s) == 0) {
          #   ss <- ""
          # } else {
          #   ss <- s
          # }
          if (d < 43) {
            test_fname <- paste0(p, paste0("d", d, "_"),
                                 t, s, ".xlsx")
          } else {
            test_fname <- paste0(p, paste0("d", d, "_"),
                                 s, ".xlsx") # there is no pre or post at d43
          }
          if (any(grepl(test_fname, base_names, fixed = TRUE))) {
            fnames <- c(fnames,
                        test_fname)
            break
          }
        }
      }
    }
  }
  return(fnames)
}
