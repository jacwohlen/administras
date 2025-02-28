import { error as err } from '@sveltejs/kit';
import type { Member } from '$lib/models';
import { supabaseClient } from '$lib/supabase';

export async function load({ depends }) {
  // Set a dependency for this route to reload when member data changes
  depends('members:list');
  
  const { error, data } = await supabaseClient
    .from('members')
    .select('id, lastname, firstname, labels')
    .order('lastname', { ascending: true })
    .order('firstname', { ascending: true })
    .returns<Member[]>();
  if (error) throw err(404, error);
  return {
    members: data
  };
}
