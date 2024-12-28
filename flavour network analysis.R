library(tidyverse)
library(igraph)

# Set up network of flavour combinations
ingredients <- read_csv("data/ingredients.csv")
ingredients$Type_fct <- as.factor(ingredients$Type)

flavour_combos <- read_csv("data/flavour-combos.csv")

flavours <- graph_from_data_frame(flavour_combos, vertices = ingredients, directed = FALSE)

# Which ingredients are most and least paired?
flavour_degrees <- degree(flavours)
ingredients$n_pairings = flavour_degrees[ as.character(ingredients$Ingredient) ]

# Assortativity
assortativity_nominal(flavours, types = ingredients$Type_fct)
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
