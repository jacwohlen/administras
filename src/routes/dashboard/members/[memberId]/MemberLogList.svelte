<script lang="ts">
  import { error as err } from '@sveltejs/kit';
  import Fa from 'svelte-fa';
  import { faArrowRight, faArrowLeft } from '@fortawesome/free-solid-svg-icons';
  import { faGripLines } from '@fortawesome/free-solid-svg-icons';
  import { supabaseClient } from '$lib/supabase';
  import { _ } from 'svelte-i18n';

  export let memberId: String;

  $: year = new Date().getFullYear();

  interface LogSummary {
    trainingId: number;
    date: string;
    trainingsInfo: Training;
  }

  interface Training {
    id: number;
    weekDay: string;
    title: string;
    section: string;
  }
  async function getLogs() {
    // Fetch logs
    const { error: logsError, data: logsData } = await supabaseClient
      .from('logs')
      .select()
      .eq('memberId', memberId)
      .gte('date', year + '-01-01')
      .lte('date', year + '-12-31')
      .order('date', { ascending: false })
      .returns<LogSummary[]>();

    if (logsError) {
      throw err(404, logsError);
    }

    // Fetch trainings
    const { error: trainingsError, data: trainingsData } = await supabaseClient
      .from('trainings')
      .select()
      .returns<Training[]>();

    if (trainingsError) {
      throw err(404, trainingsError);
    }

    // Convert trainingsData into a map for easy lookup
    const trainingsMap = trainingsData.reduce((map: any, training: Training) => {
      map[training.id] = training;
      return map;
    }, {});

    // Assign the corresponding Trainings information to each LogSummary
    const enrichedLogs = logsData.map((log: LogSummary) => ({
      ...log,
      trainingsInfo: trainingsMap[log.trainingId] || null // Fallback to null if no matching training is found
    }));
    return enrichedLogs;
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
  let currentItem = 10;

  $: l = getLogs();
</script>

<div class="card p-4">
  <h3>{$_('page.members.trainingsHistory.title')}</h3>
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

  {#await l then logs}
    <ul class="list">
      {#each logs.slice(0, currentItem) as i}
        <li>
          <span>
            {i.date}
          </span>
          <span class="flex-auto">
            {i.trainingsInfo.title}
          </span>
          <span class="flex-right">
            {i.trainingsInfo.section}
          </span>
          <span>
            <a
              class="btn btn-sm variant-filled-secondary"
              href="/dashboard/trainings/{i.trainingId}/{i.date}"
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
      <button
        class="btn btn-sm variant-filled-secondary"
        on:click={() => (currentItem = currentItem + 10)}
      >
        {$_('button.loadMore')}
      </button>
    {/if}
  {/await}
</div>
