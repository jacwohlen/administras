<script lang="ts">
  import Fa from 'svelte-fa';
  import { faArrowRight, faArrowLeft } from '@fortawesome/free-solid-svg-icons';
  import { goto } from '$app/navigation';
  import { to_number } from 'svelte/internal';
  import type { PageData } from '../$types';

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
  {#await topAthletes then items}
    <h3>Top Athletes ({items.length})</h3>
    <ol class="list-decimal p-8">
      {#each items as item}
        <li>{item.lastname} {item.firstname} ({item.count})</li>
      {/each}
    </ol>
  {/await}
</div>
