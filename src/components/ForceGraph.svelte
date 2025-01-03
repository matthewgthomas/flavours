<script>
    import { forceManyBody, forceLink, forceX, forceY, forceCollide, forceCenter } from 'd3-force';
    import { curveLinear } from 'd3-shape';
    import { scaleBand, scaleOrdinal } from 'd3-scale';
    import { schemeCategory10 } from 'd3-scale-chromatic';
  
    import { Chart, Circle, ForceSimulation, Link, Svg } from 'layerchart';
   
    // let { data } = $props();

    let { nodes, links } = $props();
  
    const colorScale = scaleOrdinal(schemeCategory10);
  
    const linkForce = forceLink(links).id((d) => d.id);
    const chargeForce = forceManyBody().strength(3);
    const collideForce = forceCollide();
    const centerForce = forceCenter();
    const xForce = forceX().strength(0.1);
    const yForce = forceY();

    let alpha = 1;
    const nodeStrokeWidth = 1
    let groupBy = true;
    $effect(() => reheatSimulation({ groupBy }));

    function reheatSimulation(args = {}) {
        const _ = args;
        alpha = 1.0;
    }
</script>

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
    <Svg center>
        <ForceSimulation
            forces={{
                link: linkForce,
                charge: chargeForce,
                y: yForce,
                x: xForce.x((d) => (groupBy ? xGet(d) + xScale.bandwidth() / 2 : width / 2)),
                charge: chargeForce,
                center: centerForce.x(width / 2).y(height / 2),
            }}
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
            <Circle cx={node.x} cy={node.y} r={6} fill={colorScale(node.type)} />
        {/each}
        </ForceSimulation>
    </Svg>
    </Chart>
</div>
