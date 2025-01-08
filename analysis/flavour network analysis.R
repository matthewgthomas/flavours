library(tidyverse)
library(igraph)

# ---- Set up network of flavour combinations ----
ingredients <- read_csv("data/ingredients.csv")
ingredients$type_fct <- as.factor(ingredients$type)

flavour_combos <- read_csv("data/flavour-combos.csv")

flavours <- graph_from_data_frame(flavour_combos, vertices = ingredients, directed = FALSE)

# ---- Basic stats ---
# No. ingregients
nrow(ingredients)

# No. types of ingredients
unique(ingredients$type)
length(unique(ingredients$type))

ingredients |>
  count(type, sort = TRUE)

# ---- Network stats ----
# Which ingredients are most and least paired?
flavour_degrees <- degree(flavours)
ingredients$n_pairings = flavour_degrees[ as.character(ingredients$id) ]

# Assortativity
assortativity_nominal(flavours, types = ingredients$type_fct)
#--> 0.0066, a low value meaning paired ingredients tend not to be the same type (e.g. woodland isn't often paired with woodland)

# Communities of flavour combos
# communities <- cluster_optimal(flavours)
communities <- cluster_fast_greedy(flavours)

plot(communities, flavours)

# Cliques

# Betweenness
ebs <- edge_betweenness(flavours)
as_edgelist(g)[ebs == max(ebs), ]

betweenness(flavours)

# ---- Which flavour pairings don't appear in the book? ----
all_pairs <-
  expand_grid(from = ingredients$ingredient, to = ingredients$ingredient) |>
  filter(from != to) |>
  rowwise() |>
  mutate(
    sorted_pair = list(sort(c(from, to)))  # Sort each pair
  ) |>
  ungroup() |>
  distinct(sorted_pair, .keep_all = TRUE) |>  # Keep unique sorted pairs
  select(-sorted_pair)  # Remove the helper column

# Make a bidirectional version of the actual edgelist
flavour_combos_flipped <-
  flavour_combos |>
  rename(from = to, to = from)

flavour_combos_all <-
  bind_rows(flavour_combos, flavour_combos_flipped) |>
  mutate(in_book = 1)

all_pairs |>
  left_join(flavour_combos_all) |>
  filter(is.na(in_book))
