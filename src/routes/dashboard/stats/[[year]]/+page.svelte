<script lang="ts">
  import Fa from 'svelte-fa';
  import { faArrowRight, faArrowLeft } from '@fortawesome/free-solid-svg-icons';
  import { goto } from '$app/navigation';
  import type { PageData } from '../$types';
  import TopParticipantsStats from './TopParticipantsStats.svelte';
  import { RadioGroup, RadioItem } from '@skeletonlabs/skeleton';
  import { _ } from 'svelte-i18n';

  export let data: PageData;

  $: yearmode = data.yearmode;
  $: year = data.year;

  async function previousYear() {
    if (yearmode === 'YEAR') year = year - 1;
    // FIXME: How to this more elegantly (not needing to put base path?
    goto(`/dashboard/stats/${year.toString()}`);
  }

  async function nextYear() {
    if (yearmode === 'YEAR') year = year + 1;
    goto(`/dashboard/stats/${year.toString()}`);
  }

  $: topAthletes = data.topAthletes;
  let currentItem = 10;
</script>

<div class="flex justify-between items-center m-2">
  <div>
    <button class="btn" on:click={previousYear}>
      <Fa icon={faArrowLeft} /><span>{$_('button.year')}</span>
    </button>
  </div>
  <div>
    <RadioGroup>
      <RadioItem
        bind:group={yearmode}
        on:click={() => goto('/dashboard/stats/' + year)}
        name="yearmode"
        value="YEAR"
      >
        {year}
      </RadioItem>
      <RadioItem
        bind:group={yearmode}
        on:click={() => goto('/dashboard/stats/ALL')}
        name="yearmode"
        value="ALL">{$_('page.stats.all')}</RadioItem
      >
    </RadioGroup>
  </div>
  <div>
    <button class="btn" on:click={nextYear}>
      <span>{$_('button.year')}</span><Fa icon={faArrowRight} />
    </button>
  </div>
</div>

<div class="card p-4">
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
</div>

<div class="card p-4">
  <h3>{$_('page.stats.topParticipants')}</h3>
  <TopParticipantsStats {yearmode} {year} />
</div>
