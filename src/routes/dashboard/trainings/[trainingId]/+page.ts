export async function load({ parent }) {
  const parentData = await parent();
  // FIXME: Could load data here directly and not put it into layout.ts if sveltekit would allow
  return parentData;
}
