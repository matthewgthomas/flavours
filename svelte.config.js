import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import adapterStatic from '@sveltejs/adapter-static';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		adapter: adapterStatic({ strict: false })
	},
	preprocess: [vitePreprocess()]
};

export default config;
