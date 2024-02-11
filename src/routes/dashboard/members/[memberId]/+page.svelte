<script lang="ts">
  import type { PageData } from './$types';
  import { Avatar } from '@skeletonlabs/skeleton';
  import MemberLogs from './MemberLogList.svelte';
  import { _ } from 'svelte-i18n';

  export let data: PageData;
</script>

<div class="space-y-4">
  <div class="card p-4">
    <div class="mb-4">
      {#if data.img}
        <Avatar class="mx-auto w-56" src={data.img} />
      {:else}
        <Avatar
          class="mx-auto w-56"
          initials={data.lastname.charAt(0) + data.firstname.charAt(0)}
        />
      {/if}
    </div>
    <div class="table-container">
      <table class="table">
        <tr>
          <td><b>{$_('page.members.id')}</b></td>
          <td>{data.id}</td>
        </tr>
        <tr>
          <td><b>{$_('page.members.lastName')}</b></td>
          <td>{data.lastname}</td>
        </tr>
        <tr>
          <td><b>{$_('page.members.firstName')}</b></td>
          <td>{data.firstname}</td>
        </tr>
        <tr>
          <td><b>{$_('page.members.birthday')}</b></td>
          <td>{data.birthday}</td>
        </tr>
        <tr>
          <td><b>{$_('page.members.mobile')}</b></td>
          <td>{data.mobile}</td>
        </tr>
        <tr>
          <td><b>{$_('page.members.labels')}</b></td>
          <td>
            {#if data.labels}
              {#each data.labels as l}
                <span class="chip mr-2">{l}</span>
              {/each}
            {/if}
          </td>
        </tr>
      </table>
    </div>
  </div>
  <MemberLogs memberId={data.id} />
</div>
