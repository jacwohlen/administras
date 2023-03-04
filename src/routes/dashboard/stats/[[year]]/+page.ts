import { to_number } from 'svelte/internal';
import type { PageLoad } from './$types';

export const load = (async ({ params }) => {
  let year: number = to_number(params.year);
  if (!year) year = new Date().getFullYear();
  return {
    year
  };
}) satisfies PageLoad;
