import { supabaseClient } from '$lib/supabase';
import { to_number } from 'svelte/internal';
import type { PageLoad } from './$types';

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
      year = to_number(params.year);
    }
  }

  interface Athletes {
    memberId: number;
    lastname: string;
    firstname: string;
    count: number;
  }

  async function getTopAthletes(mode: 'YEAR' | 'ALL', y: number) {
    if (mode === 'ALL') y = '';
    const { error, data } = await supabaseClient
      .rpc('get_top_athletes', {
        year: y
      })
      .returns<Athletes[]>();

    if (error) return [];
    return data;
  }

  return {
    yearmode,
    year,
    topAthletes: getTopAthletes(yearmode, year)
  };
}) satisfies PageLoad;
