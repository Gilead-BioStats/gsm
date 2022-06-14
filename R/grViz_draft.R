library(DiagrammeR)

myStudy <- Study_Assess()

study <- myStudy$importantpd

node.inputs <- map_df(study$workflow, ~tibble(inputs = .x[['inputs']], step = .x[['name']])) %>%
  mutate(grp_id = dense_rank(desc(step)),
         from = row_number(),
         to = lead(from)) %>%
  group_by(step) %>%
  mutate(to = max(to)) %>%
  ungroup()

node.length <- nrow(node.inputs)

node_df <- create_node_df(
  n = node.length,
  type = "a",
  label = node.inputs$inputs,
  value = node.inputs$step,
  style = "filled",
  color = "aqua",
  shape = "rectangle"
)

edge_df <- data.frame(
  from = head(node_df$id, n = nrow(node_df) - 1),
  to = na.omit(node.inputs$to)
)

create_graph(
  nodes_df = node_df,
  edges_df = edge_df,
  attr_theme = "lr") %>%
  render_graph()

edge.names <- map_chr(study$workflow, ~.x[['name']])


