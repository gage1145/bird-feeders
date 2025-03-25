library(tidyverse)
library(quicR)



files <- list.files("raw", full.names = TRUE)
threshold <- 2
df_list <- list()

for (file in files) {
  print(file)
  meta <- organize_tables(file) %>%
    convert_tables()
  
  info <- get_meta(file)
  
  date <- info[[which(info$Meta_ID == "Date"), "Meta_info"]]
  reader <- str_extract(file, "_r\\d+") %>%
    str_replace("_", "")
  
  df_ <- get_real(file)[[1]]
  
  df_norm <- normalize_RFU(df_)
  
  analyzed <- calculate_metrics(df_norm, meta, MS_window = 4L) %>%
    mutate(
      Date = date,
      Reader = reader
    ) %>%
    relocate(c(Date, Reader), .after = Dilutions)
  
  df_list <- append(df_list, list(analyzed))
}

df_list <- bind_rows(df_list)
write.csv(df_list, "data/data.csv", row.names = FALSE)

