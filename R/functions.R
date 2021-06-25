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
