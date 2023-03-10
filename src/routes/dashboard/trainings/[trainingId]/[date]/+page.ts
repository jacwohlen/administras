import type { PageLoad } from './$types';
import type { MMember } from './types';
import { supabaseClient } from '$lib/supabase';
import { error as err } from '@sveltejs/kit';

export const load = (async ({ params }) => {
  async function getMembersWithPresentStatus(): Promise<MMember[]> {
    const { error, data } = await supabaseClient
      .rpc('get_checklist_members', {
        d: params.date,
        tid: params.trainingId
      })
      .order('lastname', { ascending: true })
      .order('firstname', { ascending: true });

    if (error) {
      throw err(404, error);
    }
    return data.map(
      (item: any) =>
        ({
          id: item.memberid,
          firstname: item.firstname,
          lastname: item.lastname,
          labels: item.labels,
          img: item.img,
          isPresent: item.date ? true : false,
          isMainTrainer: item.ismaintrainer
        } as MMember)
    );
  }

  return {
    trainingId: params.trainingId,
    date: params.date,
    participants: await getMembersWithPresentStatus()
  };
}) satisfies PageLoad;
