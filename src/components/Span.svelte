<script>
    let { colour, invert = false, children } = $props();
</script>

<span class={`${colour} ${invert ? 'text-white' : 'text-current'} pt-1 pl-1 pr-1 rounded`}>{@render children()}</span>