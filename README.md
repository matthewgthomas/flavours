# Exploring Niki Segnit's The Flavour Thesaurus

## Developing

Once you've cloned/degit'd this repo, install dependencies with `npm install` (or `pnpm install` or `yarn`).

You'll then need to run `./fix-tooltip.sh` to patch [`TooltipContext.svelte`](https://www.layerchart.com/docs/components/TooltipContext) in the [LayerChart library](https://www.layerchart.com/)
to [enable touch scrolling on mobile](https://github.com/techniq/layerchart/issues/255).

To start a development server:

```bash
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building

To create a production version:

```bash
npm run build
```

You can preview the production build with `npm run preview`.

> To deploy your app, you may need to install an [adapter](https://svelte.dev/docs/kit/adapters) for your target environment.
