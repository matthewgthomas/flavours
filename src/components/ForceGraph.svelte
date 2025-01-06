<script>
    import { forceManyBody, forceLink, forceX, forceY, forceCollide, forceCenter } from 'd3-force';
    import { curveLinear } from 'd3-shape';
    import { scaleBand, scaleOrdinal } from 'd3-scale';
    import { schemeCategory10 } from 'd3-scale-chromatic';
  
    import { Chart, Circle, ForceSimulation, Link, Svg } from 'layerchart';
   
    // let { data } = $props();
    // let { nodes, links, index = 0 } = $props();
    export let nodes, links;
    export let currentNodes, currentLinks;
    export let index = 0;
    export let hiddenNodeOpacity = 0;
  
    const colorScale = scaleOrdinal(schemeCategory10);

    // There are 16 types of ingredient, so will show the clusters in a 4x4 grid
    const typesXY_desktop = {
        "Green & Grassy": [0.3, 0.3],
        "Sulfurous": [0.4, 0.3],
        "Fresh Fruity": [0.5, 0.3],
        "Berry & Bush": [0.6, 0.3],

        "Floral Fruity": [0.3, 0.4],
        "Citrusy": [0.4, 0.4],
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
        "Citrusy": [0.45, 0.4],
        "Mustardy": [0.6, 0.4],

        "Creamy Fruity": [0.3, 0.5],
        "Earthy": [0.45, 0.5],
        "Roasted": [0.6, 0.5],

        "Meaty": [0.3, 0.6],
        "Woodland": [0.45, 0.6],
        "Sulfurous": [0.6, 0.6],

        "Cheesy": [0.5, 0.7]
    };

    function getTypeXY(type, xy = 0, width) {
        return (width < 768 ? typesXY_mobile[type][xy] : typesXY_desktop[type][xy]);
    }
  
    const linkForce = forceLink(links).id((d) => d.id);
    const chargeForce = forceManyBody();
    const collideForce = forceCollide();
    const centerForce = forceCenter(0, 0);
    const xForce = forceX(); //.strength(0.1);
    const yForce = forceY(); //.strength(0.1);

    let alpha = 1;
    const nodeStrokeWidth = 1;

    function reheatSimulation(args = {}) {
        const _ = args;
        alpha = 1.0;
    }

    $: {
        reheatSimulation({ index });
        chargeForce.strength(index <= 2 ? -30 : -150)
    }

    let visibleNodes = nodes; 
    $: visibleNodes = nodes.filter(node => currentNodes.includes(node.id));
</script>

<p>Alpha = {alpha}</p>
<div class="h-[600px] p-4 border rounded">
    <Chart 
        data={nodes}
        x="type"
        xScale={scaleBand()}
        let:xGet
        let:xScale
        let:rGet
        let:width
        let:height
    >
    <p>Height: {height}; width: {width}</p>
    <Svg center>
        <ForceSimulation
            forces={{
                charge: chargeForce,
                collide: collideForce,
                center: centerForce,
                ...(index < 3 && { x: xForce.strength(0.1).x((d) => (index == 1 ? getTypeXY(d.type, 0, width) * width : width / 2)) }),
                ...(index < 3 && { y: yForce.strength(0.1).y((d) => (index == 1 ? getTypeXY(d.type, 1, width) * height : height / 2)) }),
                ...(index >= 3 && { link: linkForce.id((d) => d.id).links(links) })
            }}
            alphaTarget={0.15}
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

        {console.log("Current nodes = ", currentNodes)}
        {console.log("Current links = ", currentLinks)}

        {#each nodes as node}
            <Circle 
                cx={node.x} 
                cy={node.y} 
                r={10} 
                fill={index === 0 ? "#e0e0e0" : colorScale(node.type)}
                opacity={currentNodes.some(currentNode => currentNode.id === node.id) ? 1 : hiddenNodeOpacity}
            />
        {/each}
        </ForceSimulation>
    </Svg>
    </Chart>
</div>
