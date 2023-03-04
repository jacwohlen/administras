import { error as err } from '@sveltejs/kit';
import type { Member } from '$lib/models';
import { supabaseClient } from '$lib/supabase';

export async function load() {
  const { error, data } = await supabaseClient
    .from('members')
    .select()
    .order('lastname', { ascending: true })
    .order('firstname', { ascending: true })
    .returns<Member[]>();
  if (error) throw err(404, error);
  return {
    members: data
  };
}
