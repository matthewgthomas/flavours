<script>
    import ForceGraph from "../components/ForceGraph.svelte";
    import Scroller from "@sveltejs/svelte-scroller";

    import nodes from "$data/ingredients.csv";
    import links from "$data/flavour-combos.csv";
    import flavours from '$data/flavours.json';

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

    let currentNodes = nodes;
    let currentLinks = links;

    // CONFIG FOR SCROLLER COMPONENTS
	// Config
	const threshold = 0.65;
	// State
    let offset, progress;
	let index; // visible section ID of Scroller components
	let indexPrev; // keep track of previous IDs, to compare for changes

	// Actions for network of flavours scroller
	// This array of functions correspond to the <section/> tags within the network chart <Scroller/> component
	const chartActions = [
        [
            () => {
                currentNodes = nodes;
                currentLinks = [];
            },
            () => {
                currentNodes = nodes;
                currentLinks = [];
            },
			() => {
				currentNodes = [{id: "Chocolate", type: "Roasted"}];
                currentLinks = [];
			},
			() => {
				currentNodes = filteredNodes;
				currentLinks = filteredLinks;
			},
			() => {
				currentNodes = nodes;
				currentLinks = links;
			}
        ]
    ];

    $: if (index != indexPrev) {
        chartActions[0][+index]();
        indexPrev = index;
    }
</script>

<Scroller top="{0.2}" bottom="{0.8}" bind:index bind:offset bind:progress>
    <div slot="background">
        <p>Section {index + 1} is currently active.</p>
        <ForceGraph {nodes} {currentNodes} {links} {currentLinks} {index} />
    </div>
  
    <div slot="foreground">
      <section>Look at all these 99 ingredients.</section>
      <section>They're in 16 categories.</section>
      <section>This is chocolate.</section>
      <section>Chocolate is paired with...</section>
    </div>
</Scroller>

<style>
    section {
      height: 80vh;
    }
</style>