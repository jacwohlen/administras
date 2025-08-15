import { supabaseClient } from '$lib/supabase';
import type { PageLoad } from './$types';
import { error as err } from '@sveltejs/kit';
import type { Athletes } from '$lib/models';

export const load = (async ({ params }) => {
  let year: number;
  let yearmode: 'ALL' | 'YEAR';

  if (!params.year) {
    year = new Date().getFullYear(); // Default
    yearmode = 'YEAR';
  } else {
    if (params.year === 'ALL') {
      yearmode = 'ALL';
      year = new Date().getFullYear(); // Default
    } else {
      yearmode = 'YEAR';
      year = parseInt(params.year);
    }
  }

  async function getTopAthletes(mode: 'YEAR' | 'ALL', y: number | '') {
    if (mode === 'ALL') y = '';
    const { error, data } = await supabaseClient
      .rpc('get_top_athletes_by_section', {
        year: y
      })
      .returns<Athletes[]>();

    if (error) {
      throw err(404, error);
    }

    // Use reduce to group by 'section'
    const groupedData = data.reduce(
      (accumulator: { [key: string]: Athletes[] }, currentItem: Athletes) => {
        // If the section does not exist in the accumulator, create a new array for it
        if (!accumulator[currentItem.section]) {
          accumulator[currentItem.section] = [];
        }

        // Push the current item into the appropriate section
        accumulator[currentItem.section].push(currentItem);

        return accumulator;
      },
      {}
    );

    const orderedData = Object.keys(groupedData)
      .sort() // Sort the keys alphabetically
      .reduce((sortedAccumulator: { [key: string]: Athletes[] }, key: string) => {
        sortedAccumulator[key] = groupedData[key];
        return sortedAccumulator;
      }, {});

    return orderedData as { [key: string]: Athletes[] };
  }

  return {
    yearmode,
    year,
    topAthletes: await getTopAthletes(yearmode, year)
  };
}) satisfies PageLoad;
