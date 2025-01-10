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
    let sizeByDegree = false;
    let clusterByType = false;

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
            // All ingredients, greyed out
            () => {
                currentNodes = nodes;
                currentLinks = [];
                highlightedNodes = [];
                clusterByType = false;
                sizeByDegree = false;
            },
            // All ingredients, clustered into types
            () => {
                currentNodes = nodes;
                currentLinks = [];
                highlightedNodes = [];
                clusterByType = true;
                sizeByDegree = false;
            },
            // Focus on chocolate
			() => {
				currentNodes = [{id: "Chocolate", type: "Roasted"}];
                currentLinks = [];
                hiddenNodeOpacity = 0.1;
                highlightedNodes = ["Chocolate"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Show chocolate's pairings
			() => {
				currentNodes = filteredNodes;
				currentLinks = filteredLinks;
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Chocolate"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Show chocolate's pairings, highlighting cinnamon
			() => {
				currentNodes = filteredNodes;
				currentLinks = filteredLinks;
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Chocolate", "Cinnamon"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Show chocolate's pairings, highlighting cauliflower and bacon
            () => {
				currentNodes = filteredNodes;
				currentLinks = filteredLinks;
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Chocolate", "Cauliflower", "Bacon"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // All ingredients, clustered by type, sized by number of pairings
            () => {
				currentNodes = nodes;
				currentLinks = [];
                hiddenNodeOpacity = 0;
                highlightedNodes = [];
                clusterByType = false;
                sizeByDegree = true;
			},
            // All ingredients, clustered by type, sized by number of pairings
            // highlighting shellfish
            () => {
				currentNodes = nodes;
				currentLinks = [];
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Shellfish"];
                clusterByType = false;
                sizeByDegree = true;
			},
            // All ingredients, clustered by type, sized by number of pairings
            // highlighting beef and pork
            () => {
				currentNodes = nodes;
				currentLinks = [];
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Beef", "Pork"];
                clusterByType = false;
                sizeByDegree = true;
			},
            // All ingredients, clustered by type, sized by number of pairings
            // highlighting swede
            () => {
				currentNodes = nodes;
				currentLinks = [];
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Swede"];
                clusterByType = false;
                sizeByDegree = true;
			},
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
                    {sizeByDegree}
                    {clusterByType}
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
        <section>
            <div class='col-medium'>
                <p>
                    Sized by number of pairings.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Shellfish is the most popular ingredient, with 51 pairings...
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    ... closely followed by beef and pork, with 48 pairings apiece.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Swede has the fewest pairings, with just 7 other ingredients: anise, beef, carrot, lamb, nutmeg, pork, and potato
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