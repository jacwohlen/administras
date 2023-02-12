<script lang="ts">
  import type { PageData } from './$types';
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
        <a class="btn btn-sm variant-filled-primary" href="/dashboard/trainings/{t.id}">
          <span class="fa-solid fa-grip-lines" />
          <span>View</span>
        </a>
      </span>
    </li>
  {/each}
</ul>
