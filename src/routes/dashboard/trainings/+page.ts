import { supabaseClient } from '$lib/supabase';
import type { PageLoad } from './$types';
import { error as err } from '@sveltejs/kit';
import type { Training } from '$lib/models';
import utils from '$lib/utils';

export async function load() {
  const { error, data } = await supabaseClient.from('trainings').select('*').returns<Training[]>();
  if (error) {
    throw err(404, error);
  }

  data.sort((a, b) => {
    const result = utils.weekdayToNumber(a.weekday) - utils.weekdayToNumber(b.weekday);
    return result != 0
      ? result
      : parseInt(a.dateFrom.replace(':', '')) - parseInt(b.dateFrom.replace(':', ''));
  });

  return {
    trainings: data
  };
}
