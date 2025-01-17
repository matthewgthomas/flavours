<script>
    import ForceGraph from "./ForceGraph.svelte";
    import Flavour from "./Flavour.svelte";
    import Scroller from "@sveltejs/svelte-scroller";
    import Select from "svelte-select";

    import nodes from "$data/ingredients.csv";
    import links from "$data/flavour-combos.csv";

    function getNumPairings(nodeId) {
        return nodes.filter(node => node.id === nodeId)[0].n_pairings;
    }

    function filterLinks(links, filter) {
        // Convert single string to array for consistent handling
        const filters = Array.isArray(filter) ? filter : [filter];
        
        // Filter links where either source or target exactly matches any filter value
        return links.filter(link => 
            filters.includes(typeof link.source === 'object' ? link.source.id : link.source) || 
            filters.includes(typeof link.target === 'object' ? link.target.id : link.target)
        );
    }

    function filterNodes(nodes, links) {
        // Get unique ingredients from links
        const linkedIngredients = new Set([
            ...links.map(link => typeof link.source === 'object'? link.source.id : link.source),
            ...links.map(link => typeof link.target === 'object'? link.target.id : link.target)
        ]);
        
        // Filter nodes to only those that appear in links
        return nodes.filter(node => linkedIngredients.has(node.id));
    }

    // Filter nodes and links for chocolate and anise, for the scrolly story
    const chocolateLinks = filterLinks(links, "Chocolate");
    const chocolateNodes = filterNodes(nodes, chocolateLinks);

    const aniseLinks = filterLinks(links, "Anise");
    const aniseNodes = filterNodes(nodes, aniseLinks);

    // CONFIG FOR FORCEGRAPH COMPONENT
    let currentNodes = nodes;
    let currentLinks = links;
    let showHiddenNodes = false;
    let highlightedNodes = [];
    let sizeByDegree = false;
    let clusterByType = false;

    // CONFIG FOR SELECT COMPONENT
    let selectedFlavour = {id: "Anise"};  // Start the reader off with anise, since that's the flavour they'll have just read about
    const groupBy = (item) => item.type;

    function handleSelect(e) {
        currentLinks = filterLinks(links, e.detail.id);
        //console.log("New links based on", e.detail.id, "are", currentLinks);
        
        currentNodes = filterNodes(nodes, currentLinks);
        //console.log("5. Filtered nodes:", currentNodes);
        highlightedNodes = [e.detail.id];
    }

    // CONFIG FOR SCROLLER COMPONENTS
	// Config
	const threshold = 0.65;
	// State
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
            // Continuing with all ingredients, clustered into types
            () => {
                currentNodes = nodes;
                currentLinks = [];
                highlightedNodes = [];
                showHiddenNodes = false;
                clusterByType = true;
                sizeByDegree = false;
            },
            // Focus on chocolate
			() => {
				currentNodes = [{id: "Chocolate", type: "Roasted"}];
                currentLinks = [];
                showHiddenNodes = true;
                highlightedNodes = ["Chocolate"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Show chocolate's pairings
			() => {
				currentNodes = chocolateNodes;
				currentLinks = chocolateLinks;
                showHiddenNodes = false;
                highlightedNodes = ["Chocolate"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Show chocolate's pairings, highlighting cinnamon
			() => {
				currentNodes = chocolateNodes;
				currentLinks = chocolateLinks;
                highlightedNodes = ["Chocolate", "Cinnamon"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Show chocolate's pairings, highlighting cauliflower and bacon
            () => {
				currentNodes = chocolateNodes;
				currentLinks = chocolateLinks;
                highlightedNodes = ["Chocolate", "Cauliflower", "Bacon"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Show chocolate's pairings, highlighting cauliflower
            () => {
				currentNodes = chocolateNodes;
				currentLinks = chocolateLinks;
                highlightedNodes = ["Chocolate", "Cauliflower"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // All ingredients, clustered by type, sized by number of pairings
            () => {
				currentNodes = nodes;
				currentLinks = [];
                highlightedNodes = [];
                clusterByType = false;
                sizeByDegree = true;
			},
            // All ingredients, clustered by type, sized by number of pairings
            // highlighting shellfish
            () => {
				currentNodes = nodes;
				currentLinks = [];
                highlightedNodes = ["Shellfish"];
                clusterByType = false;
                sizeByDegree = true;
			},
            // All ingredients, clustered by type, sized by number of pairings
            // highlighting beef and pork
            () => {
				currentNodes = nodes;
				currentLinks = [];
                highlightedNodes = ["Beef", "Pork"];
                clusterByType = false;
                sizeByDegree = true;
			},
            // All ingredients, clustered by type, sized by number of pairings
            // highlighting swede
            () => {
				currentNodes = nodes;
				currentLinks = [];
                highlightedNodes = ["Swede"];
                clusterByType = false;
                sizeByDegree = true;
			},
            // All ingredients, clustered by type, sized by number of pairings
            // highlighting apple
            () => {
				currentNodes = nodes;
				currentLinks = [];
                highlightedNodes = ["Apple"];
                clusterByType = false;
                sizeByDegree = true;
			},
            // Same as above
            () => {
				currentNodes = nodes;
				currentLinks = [];
                showHiddenNodes = false;
                highlightedNodes = ["Apple"];
                clusterByType = false;
                sizeByDegree = true;
			},
            // Focus on anise
			() => {
				currentNodes = [{id: "Anise", type: "Green & Grassy"}];
                currentLinks = [];
                showHiddenNodes = true;
                highlightedNodes = ["Anise"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Show anise's pairings
			() => {
				currentNodes = aniseNodes;
				currentLinks = aniseLinks;
                showHiddenNodes = false;
                highlightedNodes = ["Anise"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Anise and oysters
			() => {
				currentNodes = aniseNodes;
				currentLinks = aniseLinks;
                highlightedNodes = ["Anise", "Oyster"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Anise and lemon
			() => {
				currentNodes = aniseNodes;
				currentLinks = aniseLinks;
                highlightedNodes = ["Anise", "Lemon"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Anise and swede
			() => {
				currentNodes = aniseNodes;
				currentLinks = aniseLinks;
                highlightedNodes = ["Anise", "Swede"];
                clusterByType = false;
                sizeByDegree = false;
			},
            // Reader can explore flavour pairings
			() => {
                currentLinks = filterLinks(links, selectedFlavour.id);
                currentNodes = filterNodes(nodes, currentLinks);
                highlightedNodes = [selectedFlavour.id];
                clusterByType = false;
                sizeByDegree = false;
			},
        ]
    ];

    $: if (index != indexPrev) {
        chartActions[0][+index]();
        indexPrev = index;
    }
</script>

<header>
    <div class='col-wide pt-10'>
        <h1>EXPLORING THE <span class="text-[3.5rem] italic">flavour</span> THESAURUS</h1>
    </div>
</header>

<section>
    <div class='col-wide'>
        <p>
            <a href='https://uk.bookshop.org/p/books/the-flavour-thesaurus-niki-segnit/1209294?ean=9780747599777' target='_blank'>The Flavour Thesaurus</a> is a book by Niki Segnit that pairs up 99 ingredients in a delicious series of flavour combinations. Some pairings are all-time classics, many are creative, and a handful are in that sweet spot between intriguing and confusing.
        </p>
        <p>
            If you've ever sipped your morning coffee while pondering what to do with that extra avocado, the Flavour Thesaurus is the book for you. It suggests whizzing them together in a blender with milk and sugar for a creamy coffee shake.
        </p>
        <p>
            (If you like the sound of that, immediately book a flight to Vietnam, Indonesia and/or the Philippines, where you&rsquo;ll be in good company.)
        </p>
        <p>
            <img src="images/flavour-thesaurus.webp" alt="The Flavour Thesaurus by Niki Segnit" />
        </p>
    </div>
</section>

<section>
    <div class='col-wide'>
        <p>
            This interactive story explores the Flavour Thesaurus in a never-before-seen way. Keep scrolling to go on a visual safari through this menagerie of flavours.
        </p>
    </div>
</section>

<Scroller {threshold} top="{0}" bottom="{0.8}" bind:index>
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
                    {showHiddenNodes}
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
                    The Flavour Thesaurus offers 1,089 flavour pairings between 99 ingredients.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    There are 16 categories of ingredient:
                </p>
                <ul>
                    <li><Flavour colour='bg-green-grassy' invert>Green and grassy</Flavour></li>
                    <li><Flavour colour='bg-sulphurous'>Sulphurous</Flavour></li>
                    <li><Flavour colour='bg-fresh-fruity' invert>Fresh fruity</Flavour></li>
                    <li><Flavour colour='bg-bramble-hedge' invert>Bramble and hedge</Flavour></li>
                    <li><Flavour colour='bg-floral-fruity' invert>Floral fruity</Flavour></li>
                    <li><Flavour colour='bg-citrussy'>Citrussy</Flavour></li>
                    <li><Flavour colour='bg-creamy-fruity' >Creamy fruity</Flavour></li>
                    <li><Flavour colour='bg-earthy' invert>Earthy</Flavour></li>
                    <li><Flavour colour='bg-meaty' invert>Meaty</Flavour></li>
                    <li><Flavour colour='bg-woodland' invert>Woodland</Flavour></li>
                    <li><Flavour colour='bg-brine-salt' invert>Brine and salt</Flavour></li>
                    <li><Flavour colour='bg-cheesy'>Cheesy</Flavour></li>
                    <li><Flavour colour='bg-marine' invert>Marine</Flavour></li>
                    <li><Flavour colour='bg-spicy' invert>Spicy</Flavour></li>
                    <li><Flavour colour='bg-mustardy' invert>Mustardy</Flavour></li>
                    <li><Flavour colour='bg-roasted' invert>Roasted</Flavour></li>
                </ul>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Tap on the circles to see the names and categories of each ingredient.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Let&rsquo;s explore <Flavour colour='bg-roasted' invert>chocolate</Flavour>.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    <Flavour colour='bg-roasted' invert>Chocolate</Flavour> pairs with {getNumPairings("Chocolate")} other ingredients.
                </p>
                <p>
                    <span class="lg:hidden">Tap</span><span class="max-lg:hidden">Hover over</span> each circle to see what they are.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    <Flavour colour='bg-roasted' invert>Chocolate</Flavour> goes well with obvious things like <Flavour colour='bg-spicy' invert>cinnamon</Flavour>.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    But also pairs with seemingly odd choices, such as <Flavour colour='bg-sulphurous'>cauliflower</Flavour> or <Flavour colour='bg-brine-salt' invert>bacon</Flavour>.
                </p>
                <p>
                    Heston Blumenthal&rsquo;s restaurant <a href="https://thefatduck.co.uk/" target="_blank">The Fat Duck</a> used to serve a cauliflower risotto with chocolate jelly&hellip;
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    In 2013, this dish even featured in a scientific paper called <q><a href='https://www.researchgate.net/publication/259230080_Science_and_Technology_for_New_Culinary_Techniques' target='_blank'>Science and Technology for New Culinary Techniques</a></q>:
                </p>
                <p>
                    <img src="images/cauliflower-risotto.webp" alt="Cauliflower risotto from Heston Blumenthal's Fat Duck restaurant in the UK"/>
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Some ingredients are paired more often than others.
                </p>
                <p>
                    Here are the 99 ingredients again. The size of each circle represents its number of pairings.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    <Flavour colour='bg-marine' invert>Shellfish</Flavour> is the most popular ingredient, with 51 pairings&hellip;
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    &hellip; closely followed by <Flavour colour='bg-meaty' invert>beef</Flavour> and <Flavour colour='bg-meaty' invert>pork</Flavour>, with 48 pairings apiece.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    <Flavour colour='bg-sulphurous'>Swede</Flavour> has the fewest pairings, with just 7 other ingredients: <Flavour colour="bg-green-grassy" invert>anise</Flavour>, <Flavour colour='bg-meaty' invert>beef</Flavour>, <Flavour colour='bg-woodland' invert>carrot</Flavour>, <Flavour colour='bg-meaty' invert>lamb</Flavour>, <Flavour colour='bg-spicy' invert>nutmeg</Flavour>, <Flavour colour='bg-meaty' invert>pork</Flavour>, and <Flavour colour='bg-earthy' invert>potato</Flavour>.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    <Flavour colour='bg-fresh-fruity' invert>Apple</Flavour> deserves a special mention.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Although <Flavour colour='bg-fresh-fruity' invert>apple</Flavour> isn&rsquo;t the most popular ingredient&mdash;barely squeaking into the top 20, based on number of pairings&mdash;it goes with every type of flavour, whether <Flavour colour='bg-sulphurous'>sulphurous</Flavour>, <Flavour colour='bg-spicy' invert>spicy</Flavour>, or <Flavour colour='bg-citrussy'>citrussy</Flavour>.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Some flavours are often paired with the most popular ingredients.
                </p>
                <p>
                    <Flavour colour="bg-green-grassy" invert>Anise</Flavour> is one. A  veritable&mdash;and <a href='https://www.bbcgoodfood.com/glossary/star-anise-glossary' target='_blank'>literal</a>&mdash;star among other star ingredients.
                </p>
                <p>
                    <img src='images/star-anise.webp' alt='Star anise. Source: BBC Good Food.' /> 
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    In the book, Niki Segnit describes <Flavour colour="bg-green-grassy" invert>anise</Flavour> as a <q>very combinable flavour.</q>
                </p>
                <p>
                    It appears in star and seed form, in liquorice, fennel, and herbs like tarragon and chervil. Even some varieties of basil have liquorice notes (Thai basil in particular).
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    If you&rsquo;re a fan of <Flavour colour='bg-marine' invert>oysters</Flavour>, you could try adding a dash of <a href='https://www.healthyseasonalrecipes.com/tarragon-vinaigrette/' target='_blank'>tarragon vinaigrette</a>.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Apparently <Flavour colour="bg-green-grassy" invert>anise seeds</Flavour> and <Flavour colour='bg-citrussy'>lemon</Flavour> play nicely together in <a href='https://italianfoodforever.com/2012/02/lemon-anise-biscotti/' target='_blank'>biscotti</a>.
                </p>
                <p>
                    The Flavour Thesaurus calls pastis&mdash;the <a href='https://en.wikipedia.org/wiki/Pastis' target='_blank'>anise-y aperitif</a>&mdash;an <q>odd but successful match for lemon in a sorbet.</q>
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <p>
                    Even the relatively unpopular <Flavour colour='bg-sulphurous'>swede</Flavour> has a friend in <Flavour colour="bg-green-grassy" invert>anise</Flavour>.
                </p>
                <p>
                    The Flavour Thesaurus recommends Hugh Fearnley-Whittingstall&rsquo;s <a href='https://www.google.co.uk/books/edition/The_River_Cottage_Meat_Book/a-r5GwAACAAJ?hl=en#ba_cen=lat_e7:%20515331909%0Alng_e7:%204294736586%0A&ba_loc=London%20E3%202PY' target='_blank'>leftover goose pasties</a>, which sound superb even to an anise-skeptic like me.
                </p>
            </div>
        </section>
        <section>
            <div class='col-medium'>
                <h3>Explore the flavour pairings yourself</h3>
                <p>
                    <label for="flavours-select">Use the box below to choose an ingredient. Your chosen ingredient and its flavour pairings will appear. <span class="lg:hidden">Tap</span><span class="max-lg:hidden">Hover over</span> the circles to see what they are.</label>
                </p>
                <div class="p-4">
                    <Select 
                        id="flavours-select" 
                        items={nodes} 
                        itemId="id" 
                        label="id" 
                        {groupBy}
                        showChevron={true}
                        clearable={false}
                        placeholder="Choose an ingredient&hellip;"
                        --chevron-color="#e56c8f"
                        --item-hover-bg="#e56c8f90"
                        --item-is-active-bg="#e56c8f"
                        --item-is-not-selectable-color="#e56c8f"
                        --placeholder-color="#e56c8f"
                        --border-focused="1px solid #e56c8f"
                        bind:value={selectedFlavour}
                        on:change={handleSelect}
                    />
                </div>
                <p>
                    {selectedFlavour.id} has {selectedFlavour.n_pairings} pairings
                </p>
            </div>
        </section>
    </div>
</Scroller>

<section>
    <div class='col-wide'>
        <h3>How I made this</h3>
        <p>
            The pairings of ingredients in the Flavour Thesaurus can be treated as a &lsquo;social network&rsquo;, which, gleefully, means you can analyse them statistically. After <a href="https://github.com/matthewgthomas/flavours/blob/main/analysis/extract%20flavour%20combos.R" target="_blank">extracting the flavour combinations</a> from a (legally obtained!) copy of the e-book, I ran some standard <a href="https://faculty.ucr.edu/~hanneman/nettext/" target="_blank">social network analysis</a> methods, for example calculating an ingredient&rsquo;s &lsquo;popularity&rsquo; based on its degree (the number of connections it has to other ingredients), and finding the &lsquo;star&rsquo; among star ingredients using measures of centrality such as <a href="https://www.sciencedirect.com/topics/computer-science/eigenvector-centrality" target="_blank">eigenvector centrality</a>.
        </p>
        <p>
            All the code is <a href="https://github.com/matthewgthomas/flavours" taget="_blank">on GitHub</a> and released under a <a href="https://choosealicense.com/licenses/mit/" target="_blank">permissive license</a>, should you wish to play about with it.
        </p>
        <p>
            <cite>The Flavour Thesaurus</cite> is a trademark of Niki Segnit. The choice of ingredients and their pairings are her intellectual property, and she owns the copyright to the content of the Flavour Thesaurus. This interactive story simply showcases her work&mdash;and the sheer amount of effort she would&rsquo;ve put into compiling it&mdash;in a snazzy and hopefully interesting way.
        </p>
        <p class="pb-10">
            You can find more of my nerdery at <a href="https://matthewgthomas.co.uk" target="_blank">matthewgthomas.co.uk</a>.
        </p>
    </div>
</section>

<style>
	/* Styles specific to elements within the demo */
	:global(svelte-scroller-foreground) {
		pointer-events: none !important;
	}
	:global(svelte-scroller-foreground section div) {
		pointer-events: all !important;
	}
</style>