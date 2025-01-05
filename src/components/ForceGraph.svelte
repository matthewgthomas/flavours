<script>
    import { forceManyBody, forceLink, forceX, forceY, forceCollide, forceCenter } from 'd3-force';
    import { curveLinear } from 'd3-shape';
    import { scaleBand, scaleOrdinal } from 'd3-scale';
    import { schemeCategory10 } from 'd3-scale-chromatic';
  
    import { Chart, Circle, ForceSimulation, Link, Svg } from 'layerchart';
   
    // let { data } = $props();
    // let { nodes, links, index = 0 } = $props();
    export let nodes, links;
    export let index = 0;
  
    const colorScale = scaleOrdinal(schemeCategory10);

    // There are 16 types of ingredient, so will show the clusters in a 4x4 grid
    const typesXY = {
        "Green & Grassy": [10, 0],
        "Sulfurous": [30, 0],
        "Fresh Fruity": [50, 0],
        "Berry & Bush": [70, 0],
        "Floral Fruity": [10, 30],
        "Citrusy": [30, 30],
        "Creamy Fruity": [50, 30],
        "Earthy": [70, 30],
        "Meaty": [10, 50],
        "Woodland": [30, 50],
        "Brine & Salt": [50, 50],
        "Cheesy": [70, 50],
        "Marine": [10, 70],
        "Spicy": [30, 70],
        "Mustardy": [50, 70],
        "Roasted": [70, 70]
    };
  
    const linkForce = forceLink(links).id((d) => d.id);
    const chargeForce = forceManyBody();
    const collideForce = forceCollide();
    const centerForce = forceCenter(0, 0);
    const xForce = forceX(); //.strength(0.1);
    const yForce = forceY(); //.strength(0.1);

    let alpha = 1;
    const nodeStrokeWidth = 1;

    function reheatSimulation(args = {}) {
        console.log("Reheating sim: args = ", args)
        const _ = args;
        alpha = 1.0;
    }

    $: {
        reheatSimulation({ index });
        chargeForce.strength(index <= 1 ? -30 : -300)
    }
</script>

<p>Alpha = {alpha}</p>
<div class="h-[300px] p-4 border rounded">
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
                ...(index <= 1 && { x: xForce.strength(0.1).x((d) => (index === 1 ? typesXY[d.type][0] : width / 2)) }),
                ...(index <= 1 && { y: yForce.strength(0.1).y((d) => (index === 1 ? typesXY[d.type][1] : width / 2)) }),
                ...(index > 1 && { link: linkForce.id((d) => d.id).links(links) })
            }}
            alphaTarget={0.15}
            bind:alpha
            let:nodes
        >
        {#key nodes}
        {#if index > 1}
            {#each links as link}
                <Link data={link} class="stroke-surface-content/50" curve={curveLinear} stroke="#e1e1e1" stroke-width=0.4 />
            {/each}
        {/if}
        {/key}

        {#each nodes as node}
            <Circle 
                cx={node.x} 
                cy={node.y} 
                r={10} 
                fill={index === 0 ? "#e0e0e0" : colorScale(node.type)} 
            />
        {/each}
        </ForceSimulation>
    </Svg>
    </Chart>
</div>
