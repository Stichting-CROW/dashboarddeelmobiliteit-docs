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
    sidebar: [
      {
        label: 'Start',
        items: [
          // Each item here is one entry in the navigation menu.
          {
            label: 'Introduction',
            link: '/start/introduction'
          },
          {
            label: 'How to install?',
            link: '/start/how_to_install'
          },
          {
            label: 'How to add a data feed?',
            link: '/start/how_to_add_a_feed'
          },
          {
            label: 'Architecture',
            link: '/start/architecture'
          }
        ]
      },
      {
        label: 'Offering a data feed',
        items: [
          // Each item here is one entry in the navigation menu.
          {
            label: 'For monitoring',
            link: '/data_feeds/for_monitoring'
          },
          {
            label: 'For steering',
            link: '/data_feeds/for_steering'
          }
        ]
      },
      {
        label: 'Using the API\'s',
        items: [
          // Each item here is one entry in the navigation menu.
          {
            label: 'Getting started',
            link: '/api_docs/getting_started'
          }, {
            label: 'Get API key',
            link: '/api_docs/get_apikey'
          }
        ]
      },
      {
        label: 'Service areas API',
        items: [
          {
            label: 'Service areas',
            link: '/api_docs/service_areas'
          }
        ]
      },
      {
        label: 'Microhubs API',
        items: [
          {
            label: 'Microhubs',
            link: '/api_docs/microhubs'
          }
        ]
      },
      {
        label: 'Zone statistics API',
        items: [
         {
            label: 'Zone statistics',
            link: '/api_docs/zone_statistics'
          }, {
            label: 'Zone statistics example',
            link: '/api_docs/zone_statistics_example'
          }
        ]
      },
      {
        label: 'Parkeertelling API',
        items: [
         {
            label: 'Parkeertelling',
            link: '/api_docs/parkeertelling'
          }
        ]
      }
    ]
  })],
  // Process images with sharp: https://docs.astro.build/en/guides/assets/#using-sharp
  image: {
    service: {
      entrypoint: 'astro/assets/services/sharp'
    }
  },
});