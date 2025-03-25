library(tidyverse)



df_ <- read.csv("data/data.csv", check.names = FALSE)


summary <- df_ %>%
  group_by(`Sample IDs`, Date, Reader) %>%
  summarize_at(
    vars(MPR:RAF),
    mean
  )


