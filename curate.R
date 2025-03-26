library(tidyverse)
library(quicR)



df_list <- list()

# Curation function for vectorized operation.
curate <- function(file) {
  print(file)
  append(
    df_list,
    calculate_metrics(
      normalize_RFU(get_real(file)[[1]]),
      convert_tables(organize_tables(file))
    ) %>%
      mutate(
        Date = filter(get_meta(file), Meta_ID == "Date")[["Meta_info"]],
        Reader = str_replace(str_extract(file, "_r\\d+"), "_", "")
      ) %>%
      relocate(c(Date, Reader), .after = Dilutions) %>%
      list()
  )
}

# Vectorized iteration of all raw data files.
df_list <- sapply(list.files("raw", full.names = TRUE), curate) %>%
  bind_rows()

write.csv(df_list, "data/data.csv", row.names = FALSE)
