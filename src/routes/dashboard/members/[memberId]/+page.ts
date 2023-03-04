import type { PageLoad } from './$types';
import { error as err } from '@sveltejs/kit';
import type { Member } from '$lib/models';
import { supabaseClient } from '$lib/supabase';

export const load = (async ({ params }) => {
  const { error, data } = await supabaseClient
    .from('members')
    .select()
    .eq('id', params.memberId)
    .single<Member>();
  if (error) {
    throw err(404, error);
  }
  return data;
}) satisfies PageLoad;
