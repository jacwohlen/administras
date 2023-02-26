<script lang="ts">
  import type { Log } from '$lib/models';
  import { error as err } from '@sveltejs/kit';
  import Fa from 'svelte-fa';
  import { faGripLines } from '@fortawesome/free-solid-svg-icons';
  import { supabaseClient } from '$lib/supabase';

  export let trainingId: String;

  async function getLogs() {
    const { error, data } = await supabaseClient
      .from('logs')
      .select(`*, members (count)`)
      .eq('trainingId', trainingId)
      .returns<Log[]>();

    console.log(data);
    if (error) {
      throw err(404, error);
    }
    return data;
  }
</script>

{#await getLogs() then logs}
  <ul class="list">
    {#each logs as i (i.id)}
      <li>
        <span>
          {i.date}
        </span>
        <span class="flex-auto">
          {i.members.count}
        </span>
        <span>
          <a
            class="btn btn-sm variant-filled-secondary"
            href="/dashboard/trainings/{trainingId}/{i.id}"
          >
            <Fa icon={faGripLines} />
            <span>View</span>
          </a>
        </span>
      </li>
    {/each}
  </ul>
{/await}
