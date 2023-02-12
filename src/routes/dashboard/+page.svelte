<script lang="ts">
  import type { PageData } from './$types';
  export let data: PageData;
</script>

<h1>Today</h1>
{#if data.trainings.length == 0}
  <div class="text-center">There are no trainings happening today!</div>
{:else}
  <ul class="list">
    {#each data.trainings as t (t.id)}
      <li>
        <span class="flex-auto">
          {t.title}
        </span>
        <span class="">
          <a class="btn btn-sm variant-filled-primary" href="/dashboard/trainings/{t.id}">
            <i class="fa-solid fa-clipboard-check mr-2" />
            Track attandence
          </a>
        </span>
      </li>
    {/each}
  </ul>
{/if}
