<script lang="ts">
  import type { PageData } from './$types';
  export let data: PageData;
  import LogList from './LogList.svelte';

  function getDateString() {
    return '2023-01-20';
  }
</script>

<h1>ID: {data.id}</h1>
<table>
  <tr>
    <td>title:</td>
    <td>{data.title}</td>
  </tr>
  <tr>
    <td>participants #:</td>
    <td>{data.participants.length}</td>
  </tr>
  <tr>
    <td>weekday:</td>
    <td>{data.weekday}</td>
  </tr>
  <tr>
    <td>dateFrom:</td>
    <td>{data.dateFrom}</td>
  </tr>
  <tr>
    <td>dateTo:</td>
    <td>{data.dateTo}</td>
  </tr>
  <tr>
    <td>section:</td>
    <td>{data.section}</td>
  </tr>
</table>

<div class="w-full grid grid-cols-2">
  <h2>Logs</h2>
  <div class="text-right">
    <a
      class="btn btn-sm variant-filled-primary"
      href="/dashboard/trainings/{data.id}/{getDateString()}"
    >
      Track Attendance
    </a>
  </div>
</div>
<LogList trainingId={data.id} />
