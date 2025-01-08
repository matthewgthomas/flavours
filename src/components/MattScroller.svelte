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
    let hiddenNodeOpacity = 0;
    let highlightedNodes = [];

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
                highlightedNodes = [];
            },
            () => {
                currentNodes = nodes;
                currentLinks = [];
                highlightedNodes = [];
            },
			() => {
				currentNodes = [{id: "Chocolate", type: "Roasted"}];
                currentLinks = [];
                hiddenNodeOpacity = 0.1;
                highlightedNodes = [];
			},
			() => {
				currentNodes = filteredNodes;
				currentLinks = filteredLinks;
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Chocolate"];
			},
			() => {
				currentNodes = filteredNodes;
				currentLinks = filteredLinks;
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Chocolate", "Cinnamon"];
			},
            () => {
				currentNodes = filteredNodes;
				currentLinks = filteredLinks;
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Chocolate", "Cauliflower", "Bacon"];
			}
        ]
    ];

    $: if (index != indexPrev) {
        chartActions[0][+index]();
        indexPrev = index;
    }

    // Set <Scroller> top and bottom based on whether mobile or not
</script>

<Scroller {threshold} top="{0}" bottom="{0.8}" bind:index bind:offset bind:progress>
    <div slot="background">
        <figure>
            <div class="col-wide height-full">
                <!--<p>Section {index + 1} is currently active.</p>-->
                <ForceGraph 
                    {nodes} 
                    {currentNodes} 
                    {links} 
                    {currentLinks} 
                    {index} 
                    {hiddenNodeOpacity} 
                    {highlightedNodes}
                />
            </div>
        </figure>
    </div>
  
    <div slot="foreground">
        <section>
            <div class='col-medium'>
                <p>
                    Look at all these 99 ingredients.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    They're in 16 categories.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    This is chocolate.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Chocolate is paired with X ingredients.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Chocolate is paired with obvious things like cinnamon.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    ... but also with weird things like cauliflower or bacon.
                </p>
            </div>
        </section>
    </div>
</Scroller>

<style>
	/* Styles specific to elements within the demo */
	:global(svelte-scroller-foreground) {
		pointer-events: none !important;
	}
	:global(svelte-scroller-foreground section div) {
		pointer-events: all !important;
	}
</style>