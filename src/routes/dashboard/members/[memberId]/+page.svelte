<script lang="ts">
  import type { PageData } from './$types';
  import { Avatar } from '@skeletonlabs/skeleton';
  export let data: PageData;
</script>

<div class="card p-4">
  <div class="mb-4">
    {#if data.img}
      <Avatar class="mx-auto w-56" src={data.img} />
    {:else}
      <Avatar class="mx-auto w-56" initials={data.lastname.charAt(0) + data.firstname.charAt(0)} />
    {/if}
  </div>
  <div class="table-container">
    <table class="table">
      <tr>
        <td><b>Id</b></td>
        <td>{data.id}</td>
      </tr>
      <tr>
        <td><b>Lastname</b></td>
        <td>{data.lastname}</td>
      </tr>
      <tr>
        <td><b>Firstname</b></td>
        <td>{data.firstname}</td>
      </tr>
      <tr>
        <td><b>Birthday</b></td>
        <td>{data.birthday}</td>
      </tr>
      <tr>
        <td><b>Mobile</b></td>
        <td>{data.mobile}</td>
      </tr>
      <tr>
        <td><b>Labels</b></td>
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
