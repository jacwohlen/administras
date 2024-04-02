<script lang="ts">
  import { error as err } from '@sveltejs/kit';
  import Fa from 'svelte-fa';
  import { faGripLines } from '@fortawesome/free-solid-svg-icons';
  import { supabaseClient } from '$lib/supabase';
  import { _ } from 'svelte-i18n';

  export let trainingId: string;

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
      .order('date', { ascending: false })
      .returns<LogSummary[]>();

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
            href="/dashboard/trainings/{trainingId}/{i.date}"
          >
            <Fa icon={faGripLines} />
            <span>{$_('button.view')}</span>
          </a>
        </span>
      </li>
    {/each}
  </ul>
{/await}
