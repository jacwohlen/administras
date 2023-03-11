<script lang="ts">
  import type { PageData } from './$types';
  export let data: PageData;
  import LogList from './LogList.svelte';
  import utils from '$lib/utils';
  import { _ } from 'svelte-i18n';

  function getDateString() {
    const weekday = utils.weekdayToNumber(data.weekday);
    return utils.getMostRecentDateByWeekday(weekday).format('YYYY-MM-DD');
  }
</script>

<h1>{$_('page.trainings.id')}: {data.id}</h1>
<table>
  <tr>
    <td>{$_('page.trainings.trainingsTitle')}:</td>
    <td>{data.title}</td>
  </tr>
  <tr>
    <td>{$_('page.trainings.participants')} #:</td>
    <td>{data.participants.length}</td>
  </tr>
  <tr>
    <td>{$_('page.trainings.weekday')}:</td>
    <td>{data.weekday}</td>
  </tr>
  <tr>
    <td>{$_('page.trainings.dateFrom')}:</td>
    <td>{data.dateFrom}</td>
  </tr>
  <tr>
    <td>{$_('page.trainings.dateTo')}:</td>
    <td>{data.dateTo}</td>
  </tr>
  <tr>
    <td>{$_('page.trainings.section')}:</td>
    <td>{data.section}</td>
  </tr>
</table>

<div class="w-full grid grid-cols-2">
  <h2>{$_('page.trainings.logs')}</h2>
  <div class="text-right">
    <a
      class="btn btn-sm variant-filled-primary"
      href="/dashboard/trainings/{data.id}/{getDateString()}"
    >
      {$_('button.trackAttendance')}
    </a>
  </div>
</div>
<LogList trainingId={data.id} />
