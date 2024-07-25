<script lang="ts">
  import type { PageData } from './$types';
  import Fa from 'svelte-fa';
  import { faGripLines } from '@fortawesome/free-solid-svg-icons';
  import { _ } from 'svelte-i18n';

  export let data: PageData;
  let searchTerm: string = '';

  $: search = (firstname: string, lastname: string): boolean => {
    let q = searchTerm.toLowerCase().trim();
    let firstlast = firstname.toLowerCase() + ' ' + lastname.toLowerCase();
    let lastfirst = lastname.toLowerCase() + ' ' + firstname.toLowerCase();
    return firstlast.startsWith(q) || lastfirst.startsWith(q);
  };
</script>

<h1>{$_('page.members.title')}</h1>
<div class="m-2">
  <input
    class="input"
    bind:value={searchTerm}
    type="text"
    placeholder={$_('page.trainings.searchMembersPlaceholder')}
  />
</div>

<ul class="list">
  {#each data.members as m (m.id)}
    {#if search(m.firstname, m.lastname)}
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
    {/if}
  {/each}
</ul>
