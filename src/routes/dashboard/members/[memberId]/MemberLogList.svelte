<script lang="ts">
  import { error as err } from '@sveltejs/kit';
  import Fa from 'svelte-fa';
  import { faArrowRight, faArrowLeft } from '@fortawesome/free-solid-svg-icons';
  import { faGripLines } from '@fortawesome/free-solid-svg-icons';
  import { supabaseClient } from '$lib/supabase';
  import { _ } from 'svelte-i18n';
  import dayjs, { type Dayjs } from 'dayjs';
  import SvelteHeatmap from 'svelte-heatmap';
  import { onMount } from 'svelte';

  export let memberId: String;

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

  interface HeatmapData {
    date: Date;
    value: any;
  }

  function getHeatmapData(data: LogSummary[]): HeatmapData[] {
    let dateMap = new Map<string, HeatmapData>();

    data.forEach((e: LogSummary) => {
      const dateKey = dayjs(e.date).format('YYYY-MM-DD'); // Convert date to string key
      if (dateMap.has(dateKey)) {
        // If the date already exists, increase its value
        let heatMapData = dateMap.get(dateKey)!;
        heatMapData.value += 1;
        dateMap.set(dateKey, heatMapData);
      } else {
        // If the date does not exist, add it with value 1
        dateMap.set(dateKey, { date: dayjs(e.date).toDate(), value: 1 });
      }
    });

    // Convert the map values back to an array
    return Array.from(dateMap.values());
  }

  let isWideScreen = true; // Assume a wide screen by default

  function checkViewportWidth() {
    // This example checks for viewport width of 768 pixels
    isWideScreen = window.matchMedia('(min-width: 768px)').matches;
  }

  onMount(() => {
    checkViewportWidth(); // Check once when the component mounts

    // Listen for changes in viewport size
    window.addEventListener('resize', checkViewportWidth);

    return () => {
      // Remove the event listener when the component is destroyed
      window.removeEventListener('resize', checkViewportWidth);
    };
  });

  let currentItem = 10;
  $: year = new Date().getFullYear();
  $: l = getLogs();
</script>

{#await l then logs}
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
    {#if isWideScreen}
      <div>
        <SvelteHeatmap
          allowOverflow={false}
          data={getHeatmapData(logs)}
          endDate={dayjs().year(year).endOf('year').toDate()}
          startDate={dayjs().year(year).startOf('year').toDate()}
          view={'yearly'}
        />
      </div>
    {:else}
      <div>
        <SvelteHeatmap
          allowOverflow={false}
          data={getHeatmapData(logs)}
          endDate={dayjs().toDate()}
          startDate={dayjs().subtract(5, 'months').toDate()}
          view={'yearly'}
        />
      </div>
    {/if}
  </div>

  <div class="card p-4">
    <h3>{$_('page.members.trainingsHistory.title')}</h3>
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
      <span class="flex justify-center">
        <button
          class="btn btn-sm variant-filled-secondary"
          on:click={() => (currentItem = currentItem + 10)}
        >
          {$_('button.loadMore')}
        </button>
      </span>
    {/if}
  </div>
{/await}
