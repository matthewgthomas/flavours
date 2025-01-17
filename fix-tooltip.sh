#!/bin/bash
# Remove (replaces with an empty string) all instances of the text touch-none from the file node_modules/layerchart/dist/components/tooltip/TooltipContext.svelte, creating a backup file with the .bak extension before modifying the original file.
sed -i.bak 's/touch-none//g' node_modules/layerchart/dist/components/tooltip/TooltipContext.svelte
