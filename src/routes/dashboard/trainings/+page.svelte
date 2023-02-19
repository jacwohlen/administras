<script lang="ts">
  import type { PageData } from './$types';
  import Fa from 'svelte-fa';
  import { faGripLines } from '@fortawesome/free-solid-svg-icons';

  export let data: PageData;
</script>

<h1>Trainings</h1>
<ul class="list">
  {#each data.trainings as t (t.id)}
    <li>
      <span class="flex-auto">
        <dt class="font-bold">
          {t.title}
        </dt>
        <dd class="text-sm">{t.weekday} - {t.dateFrom} | {t.section}</dd>
      </span>
      <span>
        <a class="btn btn-sm variant-filled-secondary" href="/dashboard/trainings/{t.id}">
          <Fa icon={faGripLines} />
          <span>View</span>
        </a>
      </span>
    </li>
  {/each}
</ul>
