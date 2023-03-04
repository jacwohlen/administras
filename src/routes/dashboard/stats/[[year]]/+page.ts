import { supabaseClient } from '$lib/supabase';
import { to_number } from 'svelte/internal';
import type { PageLoad } from './$types';

export const load = (async ({ params }) => {
  let year: number = to_number(params.year);
  if (!year) year = new Date().getFullYear();

  interface Athletes {
    memberId: number;
    lastname: string;
    firstname: string;
    count: number;
  }

  async function getTopAthletes(y: number) {
    const { error, data } = await supabaseClient
      .rpc('get_top_athletes', {
        year: y
      })
      .returns<Athletes[]>();

    if (error) return [];
    return data;
  }

  return {
    year,
    topAthletes: getTopAthletes(year)
  };
}) satisfies PageLoad;
