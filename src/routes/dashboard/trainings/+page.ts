import { supabaseClient } from '$lib/supabase';
import type { Training } from '$lib/models';
import utils from '$lib/utils';

export async function load() {
  const { error, data } = await supabaseClient.from('trainings').select('*').returns<Training[]>();
  if (error) {
    console.log(error);
    return;
  }
  const trainings: Training[] = data;

  trainings.sort((a, b) => {
    const result = utils.weekdayToNumber(a.weekday) - utils.weekdayToNumber(b.weekday);
    return result != 0
      ? result
      : parseInt(a.dateFrom.replace(':', '')) - parseInt(b.dateFrom.replace(':', ''));
  });

  return {
    trainings
  };
}
