<script lang="ts">
  import type { Log } from '$lib/models';
  import { error as err } from '@sveltejs/kit';
  import Fa from 'svelte-fa';
  import { faGripLines } from '@fortawesome/free-solid-svg-icons';
  import { supabaseClient } from '$lib/supabase';
  import { _ } from 'svelte-i18n';

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
</script>

{#await getLogs() then logs}
  <ul class="list">
    {#each logs as i}
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
    {/each}
  </ul>
{/await}
