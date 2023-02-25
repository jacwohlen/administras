<script lang="ts">
  import type { PageData } from './$types';
  export let data: PageData;
</script>

<h1>ID: {data.lastname} {data.firstname}</h1>
<table>
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
