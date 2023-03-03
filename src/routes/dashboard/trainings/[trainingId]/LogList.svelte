<script lang="ts">
  import type { Log } from '$lib/models';
  import { error as err } from '@sveltejs/kit';
  import Fa from 'svelte-fa';
  import { faGripLines } from '@fortawesome/free-solid-svg-icons';
  import { supabaseClient } from '$lib/supabase';

  export let trainingId: String;

  interface LogSummary {
    trainingId: number;
    date: string;
    count: number;
  }

  async function getLogs() {
    const { error, data } = await supabaseClient
      .from('view_logs_summary')
      .select(`trainingId, date, count`)
      .eq('trainingId', trainingId)
      .returns<LogSummary[]>();

    console.log(data);
    if (error) {
      throw err(404, error);
    }
    return data;
  }
</script>

{#await getLogs() then logs}
  <ul class="list">
    {#each logs as i (i.date)}
      <li>
        <span>
          {i.date}
        </span>
        <span class="flex-auto">
          {i.count}
        </span>
        <span>
          <a
            class="btn btn-sm variant-filled-secondary"
            href="/dashboard/trainings/{trainingId}/{i.trainingId}"
          >
            <Fa icon={faGripLines} />
            <span>View</span>
          </a>
        </span>
      </li>
    {/each}
  </ul>
{/await}
