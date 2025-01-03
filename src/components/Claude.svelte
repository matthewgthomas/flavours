  <!-- App.svelte -->
<script>
    import { onMount } from 'svelte';
    import Scroller from "@sveltejs/svelte-scroller";
    import UpdateableGraph from './UpdateableGraph.svelte';
    import { interpolateString } from 'd3';

    import allNodes from "$data/ingredients.csv";
    import allLinks from "$data/flavour-combos.csv";

    const wholeNetwork = { nodes: allNodes, links: allLinks };

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

    const filteredLinks = filterLinks(allLinks, "Chocolate");
    const filteredNodes = filterNodes(allNodes, filteredLinks);
    
    // Define scroll sections
    const sections = [
        {
            id: 'intro',
            text: 'Here are all the ingredients...',
            state: {
                nodes: allNodes,
                links: []
            }
        },
        {
            id: 'chocolate-only',
            text: 'This is chocolate...',
            state: {
                nodes: [
                    { id: 'Chocolate', type: 'Roasted' }
                ],
                links: []
            }
        },
        {
            id: 'chocolate-pairings',
            text: 'Chocolate is paired with...',
            state: {
                nodes: filteredNodes,
                links: filteredLinks
            }
        }
    ];
    
    let index = 0;
</script>

<Scroller top="{0.2}" bottom="{0.8}" bind:index>
    <div slot="background">
        <p>Section {index + 1} is currently active.</p>
        <UpdateableGraph 
            {wholeNetwork}
            networkStates={sections.map(s => s.state)}
            currentState={index}
        />
    </div>
  
    <div slot="foreground">
        {#each sections as section}
            <section id={section.id}>
                <div class="content">
                    {section.text}
                </div>
            </section>
        {/each}
    </div>
</Scroller>

<style>
    .container {
      position: relative;
    }
    
    .sticky-container {
      position: sticky;
      top: 0;
      height: 100vh;
      width: 50%;
      float: left;
    }
    
    .scroll-sections {
      width: 50%;
      float: right;
    }
    
    .section {
      height: 80vh;
      display: flex;
      align-items: center;
      padding: 2rem;
    }

    section {
      height: 100vh;
      background: #efefef30;
    }
    
    .content {
      background: rgba(255, 255, 255, 0.9);
      padding: 2rem;
      border-radius: 8px;
    }
</style>