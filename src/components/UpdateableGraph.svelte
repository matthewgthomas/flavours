<!-- NetworkGraph.svelte -->
<script>
    import { onMount } from 'svelte';
    import * as d3 from 'd3';
    
    // Props for configuring the graph
    export let width = 800;
    export let height = 600;
    export let networkStates = [];
    export let wholeNetwork = [];
    export let currentState = 0;
  
    let svg;
    let simulation;

    const nodeRadius = 12;
    const colorScale = d3.scaleOrdinal(d3.schemeCategory10);
    
    onMount(() => {
      // Initialize the force simulation
      simulation = d3.forceSimulation()
        .force('link', d3.forceLink().id(d => d.id))
        .force('charge', d3.forceManyBody().strength(-100))
        .force('center', d3.forceCenter(width / 2, height / 2));
        
      // Create SVG elements
      svg = d3.select('#network')
        .attr('width', width)
        .attr('height', height);
  
      // Create all nodes and links upfront
      const allNodes = new Set(wholeNetwork.nodes);
      const allLinks = new Set(wholeNetwork.links);
      
    //   wholeNetwork.forEach(state => {
    //     state.nodes.forEach(node => allNodes.add(JSON.stringify(node)));
    //     state.links.forEach(link => allLinks.add(JSON.stringify(link)));
    //   });

      //allNodes.add(wholeNetwork.nodes);
      //allLinks = [...wholeNetwork.links];
  
      // Add all nodes to the DOM
      [...allNodes].forEach(node => {
        svg.append('circle')
          .attr('class', 'node')
          .attr('r', nodeRadius)
          .attr('fill', colorScale(node.type))
          .attr('opacity', 0)  // Start hidden
          .datum(node)  // Attach data
      });
  
      // Add all links to the DOM
      [...allLinks].forEach(link => {
        svg.append('line')
          .attr('class', 'link')
          .attr('stroke', '#999')
          .attr('stroke-opacity', 0.6)
          .attr('opacity', 0)  // Start hidden
          .datum(link);  // Attach data
      });
        
      // Initialize with first state
      if (networkStates.length > 0) {
        updateNetwork(networkStates[currentState]);
      }
  
      return () => {
        // Cleanup simulation on component destroy
        simulation.stop();
      };
    });
  
    // Watch for changes in currentState
    $: if (svg && simulation && networkStates[currentState]) {
      updateNetwork(networkStates[currentState]);
    }
    
    // Function to update the network visualization
    function updateNetwork(newState) {
        console.log(newState);

      // Get current node positions before update
      const currentNodes = simulation.nodes();
      const nodePositions = new Map(
        currentNodes.map(node => [node.id, { x: node.x, y: node.y }])
      );
      
      // Update nodes
      const nodeElements = svg.selectAll('.node')
        .data(newState.nodes, d => d.id);
      
      // Enter new nodes with transition
      const nodeEnter = nodeElements.enter()
        .append('circle')
        .attr('class', 'node')
        .attr('r', nodeRadius)
        .attr('fill', d => colorScale(d.type))
        .attr('opacity', 0);
  
      // Transition new nodes to their position
      nodeEnter.transition()
        .duration(750)
        .attr('opacity', 1);
          
      // Update existing nodes
      nodeElements.transition()
        .duration(750)
        .attr('fill', d => colorScale(d.type))
        .attr('opacity', 1);
        
      // Remove old nodes
      nodeElements.exit()
        .transition()
        .duration(750)
        .attr('opacity', 0)
        .remove();
        
      // Update links similarly with fly in/out
      const linkElements = svg.selectAll('.link')
        .data(newState.links, d => `${d.source}-${d.target}`);
        
      // Enter new links
      const linkEnter = linkElements.enter()
        .append('line')
        .attr('class', 'link')
        .attr('stroke', '#999')
        .attr('stroke-opacity', 0.6)
        .attr('opacity', 0);
  
      // Transition new links to position
      linkEnter.transition()
        .duration(750)
        .attr('opacity', 1);
        
      // Remove old links
      linkElements.exit()
        .transition()
        .duration(750)
        .attr('opacity', 0)
        .remove();
        
      // Preserve positions of existing nodes
      newState.nodes.forEach(node => {
        const pos = nodePositions.get(node.id);
        if (pos) {
          // Fix position of existing nodes
          node.fx = pos.x;
          node.fy = pos.y;
        } else {
          // Only new nodes should be positioned by force simulation
          node.fx = null;
          node.fy = null;
        }
      });
  
      // Update simulation
      simulation.nodes(newState.nodes)
        .force('link').links(newState.links);
      
      // Use lower alpha for gentler transition
      simulation.alpha(0.3).restart();
      
      // Release fixed positions after transition
      setTimeout(() => {
        newState.nodes.forEach(node => {
          node.fx = null;
          node.fy = null;
        });
      }, 750);
    }
    
    // Update on simulation tick
    $: if (simulation) {
      simulation.on('tick', () => {
        svg.selectAll('.link')
          .attr('x1', d => d.source.x)
          .attr('y1', d => d.source.y)
          .attr('x2', d => d.target.x)
          .attr('y2', d => d.target.y);
          
        svg.selectAll('.node')
          .attr('cx', d => d.x)
          .attr('cy', d => d.y);
      });
    }
</script>
  
<div class="network-container">
    <svg id="network"></svg>
</div>
  
<style>
    .network-container {
      position: sticky;
      top: 0;
      z-index: 1;
    }
    
    .node {
      stroke: #fff;
      stroke-width: 1.5px;
    }
    
    .link {
      stroke-width: 1px;
    }
</style>