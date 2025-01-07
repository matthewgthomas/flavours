library(tidyverse)
library(jsonlite)
library(igraph)
library(d3r)

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
         str_replace("Eggplant", "Aubergine") |>
         str_replace("Rutabaga", "Swede") |>
         str_replace("Cilantro", "Coriander Leaf")
  ) |>

  separate_wider_delim(cols = V1, delim = " & ", names = c("source", "target")) |>
  distinct()

# Ensure each pair is in sorted order and then remove duplicates
flavour_combos_edges <-
  flavour_combos_edges |>
  rowwise() |>
  mutate(
    sorted_pair = list(sort(c(source, target)))  # Sort each pair
  ) |>
  ungroup() |>
  distinct(sorted_pair, .keep_all = TRUE) |>  # Keep unique sorted pairs
  select(-sorted_pair)  # Remove the helper column

# Save nodes and edges for network analysis
ingredients <-
  ingredients |>
  mutate(Ingredient = if_else(!is.na(`Ingredient (UK)`), `Ingredient (UK)`, Ingredient)) |>
  select(id = Ingredient, type = Type)

write_csv(ingredients, "src/data/ingredients.csv")

write_csv(flavour_combos_edges, "src/data/flavour-combos.csv")

# Save nodes and links as JSON
tibble(
  nodes = ingredients |> nest(),
  links = flavour_combos_edges |> nest()
) |>
  write_json("src/data/flavours.json")

# ---- Save as JSON using d3r ----
# Make an igraph object
# flavours <- graph_from_data_frame(flavour_combos, vertices = ingredients, directed = FALSE)

# Transform it in a JSON format for d3.js
# flavours_json <- d3_igraph(flavours)

# Save this file
# write(flavours_json, "src/data/flavours.json")
