<script>
    import { forceManyBody, forceLink, forceX, forceY } from 'd3-force';
    import { curveLinear } from 'd3-shape';
    import { scaleOrdinal } from 'd3-scale';
    import { schemeCategory10 } from 'd3-scale-chromatic';
  
    import { Chart, Circle, ForceSimulation, Link, Svg } from 'layerchart';
   
    let { data } = $props();

    const { nodes, links } = data;
  
    const colorScale = scaleOrdinal(schemeCategory10);
  
    const linkForce = forceLink(links).id((d) => d.id);
    const chargeForce = forceManyBody().strength(-300);
    const xForce = forceX();
    const yForce = forceY();
</script>

<div class="h-[680px] p-2">
    <Chart data={nodes}>
    <Svg center>
        <ForceSimulation
            forces={{
                link: linkForce,
                charge: chargeForce,
                x: xForce,
                y: yForce,
            }}
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
