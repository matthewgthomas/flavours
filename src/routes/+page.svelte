<script>
    import ForceGraph from "../components/ForceGraph.svelte";

    import nodes from "$data/ingredients.csv";
    import links from "$data/flavour-combos.csv";

    const data = { "nodes": nodes, "links": links };

    function filterLinks(links, filter) {
        // Convert single string to array for consistent handling
        const filters = Array.isArray(filter) ? filter : [filter];
        
        // Filter links where either source or target exactly matches any filter value
        return links.filter(link => 
            filters.includes(link.source) || filters.includes(link.target)
        );
    }

    function filterNodes(nodes, links) {
        // Get unique ingredients from links
        const linkedIngredients = new Set([
            ...links.map(link => link.source),
            ...links.map(link => link.target)
        ]);
        
        // Filter nodes to only those that appear in links
        return nodes.filter(node => linkedIngredients.has(node.id));
    }

    const filteredLinks = filterLinks(links, "Chocolate");
    const filteredNodes = filterNodes(nodes, filteredLinks);
</script>

<ForceGraph nodes={filteredNodes} links={filteredLinks} />
