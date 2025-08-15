import { error as err } from '@sveltejs/kit';
import type { Athletes } from '$lib/models';
import { supabaseClient } from '$lib/supabase';

export async function load({ params }) {
  let year: string;

  if (!params.year || params.year === 'ALL') {
    year = '';
  } else {
    year = params.year;
  }

  const category = params.category?.toLowerCase();
  switch (category) {
    case 'athletes': {
      const { error: athletesError, data: athletesData } = await supabaseClient
        .rpc('get_top_athletes_from_section', {
          sect: params.section,
          year: year
        })
        .returns<Athletes[]>();

      if (athletesError) {
        throw err(404, athletesError);
      }
      return {
        year: params.year,
        section: params.section,
        category: params.category,
        athletes: athletesData
      };
    }

    case 'trainers': {
      const { error: trainersError, data: trainersData } = await supabaseClient
        .rpc('get_top_trainers_from_section', {
          sect: params.section,
          year: year
        })
        .returns<Athletes[]>();

      if (trainersError) {
        throw err(404, trainersError);
      }

      return {
        year: params.year,
        section: params.section,
        category: params.category,
        athletes: trainersData
      };
    }

    default:
      throw err(404, 'No valid Category');
  }
}
