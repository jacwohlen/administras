<script lang="ts">
  import type { Athletes } from '$lib/models';
  import type { PageData } from './$types';
  import { _ } from 'svelte-i18n';
  import TopList from './TopList.svelte';

  export let data: PageData;

  $: topAthletes = data.topAthletes as { [key: string]: Athletes[] };
</script>

<h3>{$_('page.stats.topAthletes')}</h3>
<div class="gap-4 justify-start flex flex-col md:flex-row">
  {#each Object.keys(topAthletes) as section}
    <TopList {section} athletes={topAthletes} />
  {/each}
</div>
