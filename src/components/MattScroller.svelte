<script>
    import ForceGraph from "../components/ForceGraph.svelte";
    import Span from "../components/Span.svelte";
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
                    They're in 16 categories:
                </p>
                <ul>
                    <li><Span colour='bg-green-grassy' invert>Green and grassy</Span></li>
                    <li><Span colour='bg-sulphurous'>Sulphurous</Span></li>
                    <li><Span colour='bg-fresh-fruity' invert>Fresh fruity</Span></li>
                    <li><Span colour='bg-bramble-hedge' invert>Bramble and hedge</Span></li>
                    <li><Span colour='bg-floral-fruity' invert>Floral fruity</Span></li>
                    <li><Span colour='bg-citrussy'>Citrussy</Span></li>
                    <li><Span colour='bg-creamy-fruity' >Creamy fruity</Span></li>
                    <li><Span colour='bg-earthy' invert>Earthy</Span></li>
                    <li><Span colour='bg-meaty' invert>Meaty</Span></li>
                    <li><Span colour='bg-woodland' invert>Woodland</Span></li>
                    <li><Span colour='bg-brine-salt' invert>Brine and salt</Span></li>
                    <li><Span colour='bg-cheesy'>Cheesy</Span></li>
                    <li><Span colour='bg-marine' invert>Marine</Span></li>
                    <li><Span colour='bg-spicy' invert>Spicy</Span></li>
                    <li><Span colour='bg-mustardy' invert>Mustardy</Span></li>
                    <li><Span colour='bg-roasted' invert>Roasted</Span></li>
                </ul>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    This is <Span colour='bg-roasted' invert>chocolate</Span>.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    <Span colour='bg-roasted' invert>Chocolate</Span> is paired with X ingredients.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    <Span colour='bg-roasted' invert>Chocolate</Span> is paired with obvious things like <Span colour='bg-spicy' invert>cinnamon</Span>.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    ... but also with weird things like <Span colour='bg-sulphurous'>cauliflower</Span> or <Span colour='bg-brine-salt'>bacon</Span>.
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
                    <Span colour='bg-marine' invert>Shellfish</Span> is the most popular ingredient, with 51 pairings...
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    ... closely followed by <Span colour='bg-meaty' invert>beef</Span> and <Span colour='bg-meaty' invert>pork</Span>, with 48 pairings apiece.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    <Span colour='bg-sulphurous'>Swede</Span> has the fewest pairings, with just 7 other ingredients: <Span colour="bg-green-grassy" invert>anise</Span>, <Span colour='bg-meaty' invert>beef</Span>, <Span colour='bg-woodland' invert>carrot</Span>, <Span colour='bg-meaty' invert>lamb</Span>, <Span colour='bg-spicy' invert>nutmeg</Span>, <Span colour='bg-meaty' invert>pork</Span>, and <Span colour='bg-earthy' invert>potato</Span>.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    <Span colour='bg-fresh-fruity' invert>Apple</Span> deserves a special mention.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Although <Span colour='bg-fresh-fruity' invert>apple</Span> isn't the most popular ingredient - barely squeaking into the top 20, based on number of pairings - it goes with every type of flavour, whether <Span colour='bg-sulphurous'>sulphurous</Span>, <Span colour='bg-spicy' invert>spicy</Span>, or <Span colour='bg-citrussy'>citrussy</Span>.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Some flavours are often paired with the most popular ingredients.
                </p>
                <p>
                    <Span colour="bg-green-grassy" invert>Anise</Span> is one. A  veritable - and <a href='https://www.bbcgoodfood.com/glossary/star-anise-glossary' target='_blank'>literal</a> - star among other star ingredients.
                </p>
                <p>
                    <img src='https://images.immediate.co.uk/production/volatile/sites/30/2020/02/star-anise-ff5c1d1.jpg?quality=90&webp=true&resize=750,681' alt='Star anise. Source: BBC Good Food.' /> 
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    In the book, Niki Segnit describes <Span colour="bg-green-grassy" invert>anise</Span> as a "very combinable flavour."
                </p>
                <p>
                    It appears in star and seed form, in liquorice, fennel, and herbs like tarragon and chervil. Even some varieties of basil have liquorice notes (Thai basil in particular).
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    If you're a fan of <Span colour='bg-marine' invert>oysters</Span>, you could try adding a dash of <a href='https://www.healthyseasonalrecipes.com/tarragon-vinaigrette/' target='_blank'>tarragon vinaigrette</a>.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Apparently <Span colour="bg-green-grassy" invert>anise seeds</Span> and <Span colour='bg-citrussy'>lemon</Span> play nicely together in <a href='https://italianfoodforever.com/2012/02/lemon-anise-biscotti/' target='_blank'>biscotti</a>.
                </p>
                <p>
                    The Flavour Thesaurus calls pastis - the <a href='https://en.wikipedia.org/wiki/Pastis' target='_blank'>anise-y aperitif</a> - an "odd but successful match for lemon in a sorbet."
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Even the relatively unpopular <Span colour='bg-sulphurous'>swede</Span> has a friend in <Span colour="bg-green-grassy" invert>anise</Span>.
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