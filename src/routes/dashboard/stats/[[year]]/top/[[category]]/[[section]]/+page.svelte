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

<h1>
  {#if data.category?.toLowerCase() == 'athletes'}
    {$_('page.stats.topAthletes')}
  {:else}
    {$_('page.stats.topTrainers')}
  {/if}
  {data.section}
</h1>
<div class="m-2">
  <input
    class="input"
    bind:value={searchTerm}
    type="text"
    placeholder={$_('page.trainings.searchMembersPlaceholder')}
  />
</div>

<ul class="list">
  {#each data.athletes as e (e.memberid)}
    {#if search(e.firstname, e.lastname)}
      <li>
        <span>
          {e.rank.toString()}.
        </span>
        <span class="flex-auto font-bold">
          {e.lastname}
          {e.firstname}
          ({e.count})
        </span>
        <span>
          <a class="btn btn-sm variant-filled-secondary" href={'/dashboard/members/' + e.memberid}>
            <Fa icon={faGripLines} />
            <span>{$_('button.view')}</span>
          </a>
        </span>
      </li>
    {/if}
  {/each}
</ul>
