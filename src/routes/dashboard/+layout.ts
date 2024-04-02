export const ssr = false;
import { getSupabase } from '@supabase/auth-helpers-sveltekit';
import { redirect } from '@sveltejs/kit';
import type { LayoutLoad } from './$types';

export const load: LayoutLoad = async (event) => {
  const { session } = await getSupabase(event);
  if (!session) {
    redirect(303, '/');
  }
  return {
    session
  };
};
