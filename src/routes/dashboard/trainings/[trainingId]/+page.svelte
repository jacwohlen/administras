<script lang="ts">
  import type { PageData } from './$types';
  export let data: PageData;
  import { Row, Col, ListGroup, ListGroupItem, Button, Icon } from 'sveltestrap';
  import LogList from './LogList.svelte';

  function getDateString() {
    return '2023-01-20';
  }
</script>

<h1>ID: {data.id}</h1>
{data.title}
{data.participants.length}
{data.weekday}
{data.dateFrom}
{data.dateTo}
{data.section}

<h2>Logs</h2>
<Button href="/dashboard/trainings/{data.id}/{getDateString()}">Track Attendance</Button>
<LogList trainingId={data.id} />
