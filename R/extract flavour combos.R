library(tidyverse)

# Load book as plain text
flavour_txt <- read_file("data/book/The Flavor Thesaurus_ A Compendium of Pair - Segnit, Niki.txt")

# Load manually extracted list of ingredients from the book's contents
ingredients <- read_csv("https://docs.google.com/spreadsheets/d/12dxPZQAGA0UlaKsnqIu9vLWUIejjjtIuHLoMHTw4-f8/export?gid=1099796692&format=csv")

# Make a regular expression to identify all flavour combinations
# e.g. "Chicken & Almond" or "Oily Fish & Horseradish"
ingredients_list <- str_flatten(ingredients$Ingredient, collapse = "|")
ingredients_regex <- str_glue("({ingredients_list}) & ({ingredients_list})\\b")

# Extract flavour combinations
flavour_combos <- str_extract_all(flavour_txt, ingredients_regex, simplify = TRUE)

# Convert to an edge list
flavour_combos_edges <-
  flavour_combos |>
  t() |>
  as_tibble() |>

  # Use British English names for selected ingredients
  mutate(
    V1 = str_replace(V1, "Beet", "Beetroot") |>
         str_replace("Black Currant", "Blackcurrant") |>
         str_replace("Rutabaga", "Swede") |>
         str_replace("Cilantro", "Coriander Leaf")
  ) |>

  separate_wider_delim(cols = V1, delim = " & ", names = c("from", "to")) |>
  distinct()

# Ensure each pair is in sorted order and then remove duplicates
flavour_combos_edges <-
  flavour_combos_edges |>
  rowwise() |>
  mutate(
    sorted_pair = list(sort(c(from, to)))  # Sort each pair
  ) |>
  ungroup() |>
  distinct(sorted_pair, .keep_all = TRUE) |>  # Keep unique sorted pairs
  select(-sorted_pair)  # Remove the helper column

# Save nodes and edges for network analysis
ingredients |>
  mutate(Ingredient = if_else(!is.na(`Ingredient (UK)`), `Ingredient (UK)`, Ingredient)) |>
  select(-`Ingredient (UK)`) |>
  write_csv("data/ingredients.csv")

write_csv(flavour_combos_edges, "data/flavour-combos.csv")
