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
read_midi_data <- function(filenames, path2files) {
  ## Read in as follows:
  ## ID   Day Time  MIDInote  Ascend  IOI   Fname
  ## ---  --- ----  --------  ------  ----  --------------------------
  ## P03  1   pre   62        1       107   P03_d1_pre_bearbeitet.xlsx
  ##
  midi_data <- data.frame(ID = character(0),
                          Day = character(0),
                          Time = character(0),
                          Scale = integer(0),
                          MIDInote = character(0),
                          Ascend = integer(0),
                          IOI = numeric(0),
                          Fname = character(0))
  n_fnames <- length(filenames)
  for (fn in 1:n_fnames) {
    tab <- readxl::read_xlsx(list.files(path = path_to_files,
                                        pattern = filenames[fn],
                                        full.names = TRUE, recursive = TRUE),
                             sheet = "ID added")
    tab_names <- names(tab)
    approx_col_names <- c("note_actual",
                          "1=ascend",
                          "scale number",
                          "IOI")

    col_idx <- mgrep(approx_col_names, tab_names)
    col_names <- tab_names[col_idx]
    extract <- tab[ , col_names]
    names(extract) <- c("MIDInote", "Ascend", "Scale", "IOI")
    extract <- dplyr::mutate(extract,
                             ID = stringr::str_extract(filenames[fn], "^P0\\d{1}"),
                             Day = stringr::str_extract(filenames[fn], "d\\d{1,2}"),
                             Time = stringr::str_extract(filenames[fn], "(pre|post)"),
                             Fname = filenames[fn])
    extract <- dplyr::relocate(extract,
                               c("ID", "Day", "Time", "Scale", "MIDInote", "Ascend", "IOI", "Fname"))
    midi_data <- rbind(midi_data,
                       extract)
  }
  return(midi_data)
}
mgrep <- function(pattern, x) {
  stopifnot(is.character(pattern),
            is.character(x))
  matches <- NULL
  pattern_len <- length(pattern)
  for (p_n in 1:pattern_len) {
      matches <- c(matches,
                   grep(pattern = pattern[p_n],
                        x = x,
                        ignore.case = TRUE,
                        perl = TRUE))
  }
  return(matches)
}
mgrepl <- function(pattern, x) {
  return(as.logical(mgrep(pattern, x)))
}
