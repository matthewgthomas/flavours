import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import dsv from '@rollup/plugin-dsv';
import path from "path";

export default defineConfig({
	plugins: [sveltekit(), dsv()],
	resolve: {
		alias: {
			$components: path.resolve("./src/components"),
			$content: path.resolve("./src/content"),
			$data: path.resolve("./src/data"),
			$routes: path.resolve("./src/routes"),
			$styles: path.resolve("./src/styles")
		}
	}
});