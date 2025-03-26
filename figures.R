library(tidyverse)



meta <- read.csv("data/meta.csv", check.names = FALSE) %>%
  mutate_at("Sample IDs", as.character) %>%
  na.omit()

df_ <- read.csv("data/data.csv", check.names = FALSE) %>%
  mutate_at("Sample IDs", ~str_remove(., " ")) %>%
  filter(!(`Sample IDs` %in% c("N", "P"))) %>%
  left_join(meta, "Sample IDs")


df_ %>%
  separate_wider_delim(
    ID, 
    " ", 
    names = c("Feeder", "Plate"), 
    too_few = "align_start", 
    too_many = "merge"
  ) %>%
  # filter(Date != unique(Date)[1]) %>%
  ggplot(aes(Feeder, RAF, fill = Plate)) +
  geom_boxplot() +
  facet_grid(
    cols = vars(`Period in environment`), 
    rows = vars(Date), 
    space = "free_x", 
    scales = "free"
  )

# df_ %>%
#   filter(Date != unique(Date)[1]) %>%
#   ggplot(aes(`Sample IDs`, RAF, fill = Date)) +
#   geom_boxplot() +
#   facet_grid(~`ID`, space = "free_x", scales = "free")



# Plate Views -------------------------------------------------------------



multi_plate <- function(file) {
  plate_view(
    get_real(file)[[1]], 
    get_sample_locations(file)
  ) +
    ggtitle(file)
  ggsave(
    paste0(
      "figures/", 
      str_split_i(file, "/", 2) %>% str_remove(".xlsx"), 
      "_plate_view.png"
    ), 
    width = 12, 
    height = 8
  )
}

sapply(list.files("raw", full.names = TRUE), multi_plate)


