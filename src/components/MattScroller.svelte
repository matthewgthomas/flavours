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

    function filterLinksToNodes(links, nodeIds) {
        return links.filter(link => 
            nodeIds.includes(link.source) && nodeIds.includes(link.target)
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

    const chocolateLinks = filterLinks(links, "Chocolate");
    const chocolateNodes = filterNodes(nodes, chocolateLinks);

    const aniseLinks = filterLinks(links, "Anise");
    const aniseNodes = filterNodes(nodes, aniseLinks);

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
				currentNodes = chocolateNodes;
				currentLinks = chocolateLinks;
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Chocolate"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Show chocolate's pairings, highlighting cinnamon
			() => {
				currentNodes = chocolateNodes;
				currentLinks = chocolateLinks;
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Chocolate", "Cinnamon"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Show chocolate's pairings, highlighting cauliflower and bacon
            () => {
				currentNodes = chocolateNodes;
				currentLinks = chocolateLinks;
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
            // All ingredients, clustered by type, sized by number of pairings
            // highlighting apple
            () => {
				currentNodes = nodes;
				currentLinks = [];
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Apple"];
                clusterByType = false;
                sizeByDegree = true;
			},
            // Same as above
            () => {
				currentNodes = nodes;
				currentLinks = [];
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Apple"];
                clusterByType = false;
                sizeByDegree = true;
			},
            // Focus on anise
			() => {
				currentNodes = [{id: "Anise", type: "Green & Grassy"}];
                currentLinks = [];
                hiddenNodeOpacity = 0.1;
                highlightedNodes = ["Anise"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Show anise's pairings
			() => {
				currentNodes = aniseNodes;
				currentLinks = aniseLinks;
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Anise"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Anise and oysters
			() => {
				currentNodes = aniseNodes;
				currentLinks = aniseLinks;
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Anise", "Oyster"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Anise and lemon
			() => {
				currentNodes = aniseNodes;
				currentLinks = aniseLinks;
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Anise", "Lemon"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Anise and swede
			() => {
				currentNodes = aniseNodes;
				currentLinks = aniseLinks;
                hiddenNodeOpacity = 0;
                highlightedNodes = ["Anise", "Swede"];
                clusterByType = false;
                sizeByDegree = false;
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
                    Swede has the fewest pairings, with just 7 other ingredients: anise, beef, carrot, lamb, nutmeg, pork, and potato.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Apple deserves a special mention.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Although apple isn't the most popular ingredient - barely squeaking into the top 20, based on number of pairings - it goes with every type of flavour, whether sulphurous, spicy, or citrussy.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Some ingredients are often paired with the most popular ingredients.
                </p>
                <p>
                    Anise is one. A  veritable - and <a href='https://www.bbcgoodfood.com/glossary/star-anise-glossary' target='_blank'>literal</a> - star among other star ingredients.
                </p>
                <p>
                    <img src='https://images.immediate.co.uk/production/volatile/sites/30/2020/02/star-anise-ff5c1d1.jpg?quality=90&webp=true&resize=750,681' alt='Star anise. Source: BBC Good Food.' /> 
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    In the book, Niki Segnit describes anise as a "very combinable flavour."
                </p>
                <p>
                    It appears in star and seed form, in liquorice, fennel, and herbs like tarragon and chervil. Even some varieties of basil have liquorice notes (Thai basil in particular).
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    If you're a fan of oysters, you can add a dash of <a href='https://www.healthyseasonalrecipes.com/tarragon-vinaigrette/' target='_blank'>tarragon vinaigrette</a>.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Apparently anise seeds and lemon play nicely together in <a href='https://italianfoodforever.com/2012/02/lemon-anise-biscotti/' target='_blank'>biscotti</a>.
                </p>
                <p>
                    The Flavour Thesaurus calls pastis - the <a href='https://en.wikipedia.org/wiki/Pastis' target='_blank'>anise-y aperitif</a> - an "odd but successful match for lemon in a sorbet."
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Even the relatively unpopular swede has a friend in anise.
                </p>
                <p>
                    The Flavour Thesaurus recommends Hugh Fearnley-Whittingstall's <a href='https://www.google.co.uk/books/edition/The_River_Cottage_Meat_Book/a-r5GwAACAAJ?hl=en#ba_cen=lat_e7:%20515331909%0Alng_e7:%204294736586%0A&ba_loc=London%20E3%202PY' target='_blank'>leftover goose pasties</a>, which sound superb even to an anise-skeptic like me.
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