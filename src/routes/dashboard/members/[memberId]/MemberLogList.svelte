<script lang="ts">
  import { error as err } from '@sveltejs/kit';
  import Fa from 'svelte-fa';
  import { faArrowRight, faArrowLeft } from '@fortawesome/free-solid-svg-icons';
  import { faGripLines } from '@fortawesome/free-solid-svg-icons';
  import { supabaseClient } from '$lib/supabase';
  import { _ } from 'svelte-i18n';
  import type { Log } from '$lib/models';
  import AttendanceGraph from './AttendanceGraph.svelte';

  export let memberId: String;

  async function getLogs() {
    // Fetch logs
    const { error, data } = await supabaseClient
      .from('logs')
      .select('date, trainingId ( id, title, section )')
      .eq('memberId', memberId)
      .gte('date', year + '-01-01')
      .lte('date', year + '-12-31')
      .order('date', { ascending: false })
      .returns<Log[]>();

    if (error) {
      throw err(404, error);
    }

    return data;
  }

  async function previousYear() {
    year = year - 1;
    currentItem = 10;
    l = getLogs();
  }

  async function nextYear() {
    year = year + 1;
    currentItem = 10;
    l = getLogs();
  }

  interface HeatmapData {
    date: Date;
    value: any;
  }

  let currentItem: number = 10;
  $: year = new Date().getFullYear();
  $: l = getLogs();
</script>

<div class="flex justify-between items-center m-2">
  <div>
    <button class="btn" on:click={previousYear}>
      <Fa icon={faArrowLeft} /><span>{$_('button.year')}</span>
    </button>
  </div>
  <div>
    {year}
  </div>
  <div>
    <button class="btn" on:click={nextYear}>
      <span>{$_('button.year')}</span><Fa icon={faArrowRight} />
    </button>
  </div>
</div>
<div class="card p-4">
  <AttendanceGraph logs={l} {year} />
</div>
<div class="card p-4">
  <h3>{$_('page.members.trainingsHistory.title')}</h3>
  {#await l}
    <div class="space-y-4">
      <div class="placeholder" />
      <div class="grid grid-cols-3 gap-8">
        <div class="placeholder" />
        <div class="placeholder" />
        <div class="placeholder" />
      </div>
      <div class="grid grid-cols-4 gap-4">
        <div class="placeholder" />
        <div class="placeholder" />
        <div class="placeholder" />
        <div class="placeholder" />
      </div>
    </div>
  {:then logs}
    <ul class="list">
      {#each logs.slice(0, currentItem) as i}
        <li>
          <span>
            {i.date}
          </span>
          <span class="flex-auto">
            {i.trainingId.title}
          </span>
          <span class="flex-right">
            {i.trainingId.section}
          </span>
          <span>
            <a
              class="btn btn-sm variant-filled-secondary"
              href="/dashboard/trainings/{i.trainingId.id}/{i.date}"
            >
              <Fa icon={faGripLines} />
              <span>{$_('button.view')}</span>
            </a>
          </span>
        </li>
      {:else}
        <span class="flex justify-center">
          {$_('page.members.trainingsHistory.noItems')}
        </span>
      {/each}
    </ul>
    {#if currentItem < logs.length}
      <span class="flex justify-center">
        <button
          class="btn btn-sm variant-filled-secondary"
          on:click={() => (currentItem = currentItem + 10)}
        >
          {$_('button.loadMore')}
        </button>
      </span>
    {/if}
  {:catch err}
    <div class="card p-4">err</div>
  {/await}
</div>
