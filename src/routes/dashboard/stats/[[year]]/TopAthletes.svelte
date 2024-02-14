<script lang="ts">
  import type { PageData } from './$types';
  import { _ } from 'svelte-i18n';

  export let data: PageData;

  $: topAthletes = data.topAthletes;
  let currentItem = 10;
</script>

{#await topAthletes.slice(0, currentItem) then items}
  <h3>{$_('page.stats.topAthletes')}</h3>
  <ol class="list-decimal py-4 px-8">
    {#each items as item}
      <li>{item.lastname} {item.firstname} ({item.count})</li>
    {/each}
  </ol>
  {#if currentItem < topAthletes.length}
    <button
      class="btn btn-sm variant-filled-secondary"
      on:click={() => (currentItem = currentItem + 10)}
    >
      {$_('button.loadMore')}
    </button>
  {/if}
{/await}
