<script>
    import ForceGraph from "../components/ForceGraph.svelte";

    import nodes from "$data/ingredients.csv";
    import links from "$data/flavour-combos.csv";

    const data = { "nodes": nodes, "links": links };
</script>

<ForceGraph {data} />
