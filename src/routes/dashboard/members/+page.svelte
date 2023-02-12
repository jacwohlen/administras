<script lang="ts">
  import type { PageData } from './$types';
  import Fa from 'svelte-fa';
  import { faGripLines } from '@fortawesome/free-solid-svg-icons';

  export let data: PageData;
</script>

<h1>Members</h1>

<ul class="list">
  {#each data.members as m (m.id)}
    <li>
      <span class="flex-auto">
        <dt class="font-bold">
          {m.lastname}
          {m.firstname}
        </dt>
        <dd class="text-xs">
          {#if m.labels}
            {#each m.labels as l (l)}
              <span class="badge variant-filled h-4">{l}</span>
            {/each}
          {/if}
        </dd>
      </span>
      <span>
        <a class="btn btn-sm variant-filled-primary" href="#">
          <Fa icon={faGripLines} />
          <span>View</span>
        </a>
      </span>
    </li>
  {/each}
</ul>
