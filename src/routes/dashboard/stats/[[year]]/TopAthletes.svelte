<script lang="ts">
  import type { Athletes } from '$lib/models';
  import type { PageData } from './$types';
  import { _ } from 'svelte-i18n';

  export let data: PageData;

  $: topAthletes = data.topAthletes as { [key: string]: Athletes[] };
</script>

<h3>{$_('page.stats.topAthletes')}</h3>
<div class="flex flex-row overflow-x-auto snap-x gap-4">
  {#each Object.keys(topAthletes) as section}
    <div class="flex-none snap-start pl-4 pt-2 pb-4 card bg-white">
      <h3 class="indent-4">{section}</h3>
      <div class="overflow-y-auto h-60 w-60">
        <ol class="list-decimal list-outside pl-6">
          {#each topAthletes[section] as item}
            <li>
              <span class="text-nowrap">{item.lastname} {item.firstname} ({item.count})</span>
            </li>
          {/each}
        </ol>
      </div>
    </div>
  {/each}
</div>
