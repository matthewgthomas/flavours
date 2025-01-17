<script>
    import { forceManyBody, forceLink, forceX, forceY, forceCollide, forceCenter } from 'd3-force';
    import { max } from 'd3-array';
    import { scaleLinear } from 'd3-scale';
    import { curveLinear } from 'd3-shape';
    import { schemeCategory10 } from 'd3-scale-chromatic';
  
    import { typeColours } from '$lib/colours.js';
    import { Chart, Circle, ForceSimulation, Link, Svg, Tooltip } from 'layerchart';
   
    export let nodes, links;
    export let currentNodes, currentLinks;
    export let index = 0;
    export let showHiddenNodes = false;
    export let highlightedNodes = [];
    export let sizeByDegree = false;
    export let clusterByType = false;

    let indexPrev = index;
    let highlightedPrev;

    // There are 16 types of ingredient, so will show the clusters in a 4x4 grid
    const typesXY_desktop = {
        "Green & Grassy": [0.3, 0.3],
        "Sulphurous": [0.4, 0.3],
        "Fresh Fruity": [0.5, 0.3],
        "Berry & Bush": [0.6, 0.3],

        "Floral Fruity": [0.3, 0.4],
        "Citrussy": [0.4, 0.4],
        "Creamy Fruity": [0.5, 0.4],
        "Earthy": [0.6, 0.4],

        "Meaty": [0.3, 0.5],
        "Woodland": [0.4, 0.5],
        "Brine & Salt": [0.5, 0.5],
        "Cheesy": [0.6, 0.5],

        "Marine": [0.3, 0.6],
        "Spicy": [0.4, 0.6],
        "Mustardy": [0.5, 0.6],
        "Roasted": [0.6, 0.6]
    };

    // Put the clusters in a 3x5 grid (with an extra row for the roasted cluster)
    // Change the order compared to desktop grid, so that the smallest clusters are down the right hand side
    const typesXY_mobile = {
        "Green & Grassy": [0.3, 0.1],
        "Brine & Salt": [0.45, 0.1],
        "Marine": [0.6, 0.1],

        "Fresh Fruity": [0.3, 0.3],
        "Berry & Bush": [0.45, 0.3],
        "Spicy": [0.6, 0.3],

        "Floral Fruity": [0.3, 0.4],
        "Citrussy": [0.45, 0.4],
        "Mustardy": [0.6, 0.4],

        "Creamy Fruity": [0.3, 0.5],
        "Earthy": [0.45, 0.5],
        "Roasted": [0.6, 0.5],

        "Meaty": [0.3, 0.6],
        "Woodland": [0.45, 0.6],
        "Sulphurous": [0.6, 0.6],

        "Cheesy": [0.5, 0.7]
    };

    function getTypeXY(type, xy = 0, width) {
        return (width < 768 ? typesXY_mobile[type][xy] : typesXY_desktop[type][xy]);
    }

    function getOrderedPosition(node, nodes, width, height) {
        // Sort nodes by size descending
        const sortedNodes = [...nodes].sort((a, b) => b.n_pairings - a.n_pairings);
        const index = sortedNodes.findIndex(n => n.id === node.id);
        
        // Calculate radius (using same scale as in visualization)
        const rScale = scaleLinear()
            .domain([0, max(nodes, d => d.n_pairings)])
            .range([3, 12]);
        const radius = rScale(node.n_pairings);
        
        // Calculate positions with padding based on radius
        const padding = 0; // Space between nodes
        //const maxPerRow = Math.floor(width / (radius * 2 + padding));
        const maxPerRow = width < 768 ? 6 : 9;
        const row = Math.floor(index / maxPerRow);
        const col = index % maxPerRow;
        
        return {
            x: (col * (35 + padding)) + 0 + padding + (width / 5),
            y: (row * (35 + padding)) + 0 + padding + (height / 5)
        };
    }
  
    const linkForce = forceLink(links).id((d) => d.id);
    const chargeForce = forceManyBody();
    const collideForce = forceCollide();
    const centerForce = forceCenter();
    const xForce = forceX();
    const yForce = forceY();

    let alpha = 1;
    const nodeStrokeWidth = 1.5;
    const nodeStrokeColour = "#fff";
    const nodeRadius = 10;

    function reheatSimulation(args = {}) {
        const _ = args;
        alpha = 1.0;
    }

    $: {
        reheatSimulation({ index });
        chargeForce.strength(currentLinks.length === 0 ? -20 : -120)
    }
</script>

<Chart 
    data={nodes}
    x="type"
    let:xGet
    let:width
    let:height
    let:tooltip
>
<!-- <p>Height: {height}; width: {width}</p> -->
 <!--alphaTarget={0.15}-->
<Svg>
    <ForceSimulation
        forces={{
            charge: chargeForce,
            collide: collideForce,
            center: centerForce.x(width / 2).y(height / 2),
            ...(currentLinks.length === 0 && !sizeByDegree && { 
                x: xForce.strength(0.1).x((d) => (clusterByType ? getTypeXY(d.type, 0, width) * width : width / 2)),
                y: yForce.strength(0.1).y((d) => (clusterByType ? getTypeXY(d.type, 1, width) * height : height / 2))
            }),
            ...(currentLinks.length > 0 && { link: linkForce.id((d) => d.id).links(links) })
        }}
        bind:alpha
        let:nodes
    >
    {#key nodes}
    {#if index > 1 && currentLinks.length > 0}
        {#each links as link}
            {#if currentLinks.some(currentLink => currentLink.source === link.source && currentLink.target === link.target)}
                <Link data={link} class="stroke-surface-content/50" curve={curveLinear} stroke="#e1e1e1" stroke-width=0.4 />
            {/if}
        {/each}
    {/if}
    {/key}

    {#each nodes as node}
    {#if showHiddenNodes || currentNodes.some(currentNode => currentNode.id === node.id)}
        {#if highlightedNodes.includes(node.id)}
            <Circle 
                cx={sizeByDegree && currentLinks.length == 0 ? getOrderedPosition(node, nodes, width, height).x : node.x} 
                cy={sizeByDegree && currentLinks.length == 0 ? getOrderedPosition(node, nodes, width, height).y : node.y} 
                r={sizeByDegree ? (node.n_pairings / 2.5) + 4 : nodeRadius + 4} 
                fill="#e95a85"
            />
        {/if}
        <Circle 
            cx={sizeByDegree && currentLinks.length == 0 ? getOrderedPosition(node, nodes, width, height).x : node.x} 
            cy={sizeByDegree && currentLinks.length == 0 ? getOrderedPosition(node, nodes, width, height).y : node.y} 
            r={sizeByDegree ? node.n_pairings / 2.5 : nodeRadius} 
            fill={index === 0 ? "#e0e0e0" : typeColours[node.type]}
            stroke={nodeStrokeColour}
            stroke-width={nodeStrokeWidth}
            opacity={currentNodes.some(currentNode => currentNode.id === node.id) ? 1 : 0.1}
            on:click={(e) => {if (index > 0 && currentNodes.some(currentNode => currentNode.id === node.id)) tooltip.show(e, node)}}
            on:pointermove={(e) => {if (index > 0 && currentNodes.some(currentNode => currentNode.id === node.id)) tooltip.show(e, node)}}
            on:pointerleave={tooltip.hide}
        />
    {/if}
    {/each}
    </ForceSimulation>

    <!--
        Hide any open tooltips when the reader scrolls to another section.
        This is the only way I can figure out how to hide tooltips on mobile.
    -->
    {#if index !== indexPrev || highlightedNodes[0] !== highlightedPrev}
        {tooltip.hide()}
        {indexPrev = index}
        {highlightedPrev = highlightedNodes[0]}
    {/if}
</Svg>

<Tooltip.Root let:data class="border border-book-spine bg-book-spine/80 text-white">
    <Tooltip.Header>{data.id}</Tooltip.Header>
    <Tooltip.Item>{data.type}</Tooltip.Item>
    {#if sizeByDegree && currentLinks.length == 0}
    <Tooltip.Item>{data.n_pairings} pairings</Tooltip.Item>
    {/if}
</Tooltip.Root>
</Chart>
