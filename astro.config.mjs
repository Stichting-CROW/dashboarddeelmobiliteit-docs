import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

import cloudflare from "@astrojs/cloudflare";

// https://astro.build/config
export default defineConfig({
  integrations: [starlight({
    title: 'Docs',
    customCss: [
    // Path to your custom CSS file, starting with /
    '/src/styles/custom.css'],
    social: {
      github: 'https://github.com/withastro/starlight'
    },
    sidebar: [{
      label: 'Start',
      items: [
      // Each item here is one entry in the navigation menu.
      {
        label: 'Introduction',
        link: '/start/introduction'
      }]
    }, {
      label: 'API',
      items: [
      // Each item here is one entry in the navigation menu.
      {
        label: 'Getting started',
        link: '/api_docs/getting_started'
      }, {
        label: 'Get API key',
        link: '/api_docs/get_apikey'
      }, {
        label: 'Microhubs',
        link: '/api_docs/microhubs'
      }, {
        label: 'Zone statistics',
        link: '/api_docs/zone_statistics'
      }, {
        label: 'Zone statistics example',
        link: '/api_docs/zone_statistics_example'
      }]
    }]
  })],
  // Process images with sharp: https://docs.astro.build/en/guides/assets/#using-sharp
  image: {
    service: {
      entrypoint: 'astro/assets/services/sharp'
    }
  },
});