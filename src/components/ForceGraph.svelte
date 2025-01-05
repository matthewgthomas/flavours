<script>
    import { forceManyBody, forceLink, forceX, forceY, forceCollide, forceCenter } from 'd3-force';
    import { curveLinear } from 'd3-shape';
    import { scaleBand, scaleOrdinal } from 'd3-scale';
    import { schemeCategory10 } from 'd3-scale-chromatic';
  
    import { Chart, Circle, ForceSimulation, Link, Svg } from 'layerchart';
   
    // let { data } = $props();

    let { nodes, links, index = 0 } = $props();
  
    const colorScale = scaleOrdinal(schemeCategory10);
  
    const linkForce = forceLink(links).id((d) => d.id);
    // const chargeForce = forceManyBody().strength(3);
    // const collideForce = forceCollide();
    const centerForce = forceCenter(20, 5);
    // const xForce = forceX().strength(0.1);
    // const yForce = forceY();

    let alpha = $state(1);
    const nodeStrokeWidth = 1;

    const linkedForce = {
        link: linkForce,
        charge: forceManyBody().distanceMin(0).distanceMax(1000).strength(-150),
        collide: forceCollide(),
        center: centerForce,
    };

    const unlinkedForce = {
        y: forceY().strength(0.1),
        x: forceX().strength(0.1),
        charge: forceManyBody().strength(-30),
        center: centerForce,
    };

    const graphForces = [unlinkedForce, linkedForce];

    let currentForces = $derived(graphForces[index]);

    function reheatSimulation(args = {}) {
        const _ = args;
        alpha = 1.0;
    }

    $effect(() => {
        reheatSimulation({ index });
    });
</script>

<p>Alpha = {alpha}</p>
<div class="h-[680px] p-2">
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
    {console.log(`height: ${height}; width: ${width}`)}
    {console.log(currentForces)}
    <Svg center>
        <ForceSimulation
            forces={graphForces[index]}
            cloneData
            bind:alpha
            let:nodes
        >
        {#key nodes}
            {#each links as link}
                <Link data={link} class="stroke-surface-content/50" curve={curveLinear} stroke="#e1e1e1" stroke-width=0.4 />
            {/each}
        {/key}

        {#each nodes as node}
            <Circle cx={node.x} cy={node.y} r={10} fill={colorScale(node.type)} />
        {/each}
        </ForceSimulation>
    </Svg>
    </Chart>
</div>
