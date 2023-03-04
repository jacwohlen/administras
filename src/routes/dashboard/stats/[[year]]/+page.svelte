<script lang="ts">
  import Fa from 'svelte-fa';
  import { faArrowRight, faArrowLeft } from '@fortawesome/free-solid-svg-icons';
  import { goto } from '$app/navigation';
  import { to_number } from 'svelte/internal';
  import type { PageData } from '../$types';
  import TopParticipantsStats from './TopParticipantsStats.svelte';

  export let data: PageData;

  let year: number = to_number(data.year);

  async function previousYear() {
    year = year - 1;
    // FIXME: How to this more elegantly (not needing to put base path?
    goto(`/dashboard/stats/${year.toString()}`);
  }

  async function nextYear() {
    year = year + 1;
    goto(`/dashboard/stats/${year.toString()}`);
  }

  $: topAthletes = data.topAthletes;
  let currentItem = 10;
</script>

<div class="flex justify-between items-center m-2">
  <div>
    <button class="btn" on:click={previousYear}>
      <Fa icon={faArrowLeft} /><span>Year</span>
    </button>
  </div>
  <div>
    <h1>{year}</h1>
  </div>
  <div>
    <button class="btn" on:click={nextYear}>
      <span>Year</span><Fa icon={faArrowRight} />
    </button>
  </div>
</div>

<div class="card p-4">
  {#await topAthletes.slice(0, currentItem) then items}
    <h3>Top Athletes</h3>
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
        Load More
      </button>
    {/if}
  {/await}
</div>

<div class="card p-4">
  <h3>Top Participants</h3>
  <TopParticipantsStats {year} />
</div>
