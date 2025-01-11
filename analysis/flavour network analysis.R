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
(n_categories <- length(unique(ingredients$type)))

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

communities <- cluster_walktrap(flavours)
communities

plot(communities, flavours)

# Cliques
largest_cliques(flavours)

# Betweenness
ebs <- edge_betweenness(flavours)
as_edgelist(g)[ebs == max(ebs), ]

flavour_betweenness <- betweenness(flavours)
ingredients$betweenness = flavour_betweenness[ as.character(ingredients$id) ]

flavour_eigen <- eigen_centrality(flavours)
ingredients$eigen = flavour_eigen$vector[ as.character(ingredients$id) ]

flavour_closeness <- closeness(flavours)
ingredients$closeness = flavour_closeness[ as.character(ingredients$id) ]

# ---- Which ingredients are paired with the greatest range of other ingredients? ----
# Count the types/categories each *source* ingredient is paired with
pair_types_1 <-
  flavour_combos |>
  left_join(ingredients, join_by(target == id)) |>
  count(id = source, type)

# Count the types/categories each *target* ingredient is paired with
pair_types_2 <-
  flavour_combos |>
  left_join(ingredients, join_by(source == id)) |>
  count(id = target, type)

pair_types <-
  rbind(pair_types_1, pair_types_2) |>
  group_by(id, type) |>
  summarise(n = sum(n)) |>
  ungroup()

# Check that the sum of these counts is the same as the degree for each node
pair_types |>
  group_by(id) |>
  summarise(total = sum(n)) |>
  ungroup() |>
  left_join(ingredients) |>
  mutate(check = total == n_pairings) |>
  count(check)

# Which ingredients are paired with the greatest range of types/categories
pair_types |>
  count(id, sort = TRUE) |>
  mutate(prop = n / n_categories)

ingredients$rank_pairings <- nrow(ingredients) - rank(ingredients$n_pairings, ties.method = "first") + 1

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
