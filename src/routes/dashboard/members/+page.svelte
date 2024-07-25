<script lang="ts">
  import type { PageData } from './$types';
  import Fa from 'svelte-fa';
  import { faGripLines } from '@fortawesome/free-solid-svg-icons';
  import { _ } from 'svelte-i18n';

  export let data: PageData;
</script>

<h1>{$_('page.members.title')}</h1>

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
              <span class="badge variant-filled-secondary font-normal h-4 mx-0.5">{l}</span>
            {/each}
          {/if}
        </dd>
      </span>
      <span>
        <a class="btn btn-sm variant-filled-secondary" href={'/dashboard/members/' + m.id}>
          <Fa icon={faGripLines} />
          <span>{$_('button.view')}</span>
        </a>
      </span>
    </li>
  {/each}
</ul>
