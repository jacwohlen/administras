<script lang="ts">
  import type { PageData } from './$types';
  import ParticipantCard from './ParticipantCard.svelte';
  import { Row, Col } from 'sveltestrap';
  export let data: PageData;

  // TODO: Continue HERE, Andreas :)
  function markPresent(m: Member) {
    m.present = true;
  }

  function markNotPresent(m: Member) {
    m.present = false;
  }
</script>

<h1>Fix Attendance for {data.date}</h1>

{#if !data.log}
  MODE: New
{:else}
  MODE: Editing
{/if}
<p>{data.date}</p>
<p>{data.trainingId}</p>
<p>{data.log}</p>

<Row>
  <Col>
    <h2>Participants</h2>
    {#each data.participants.filter((p) => !p.present) as p (p.id)}
      <ParticipantCard memberId={p.id} on:change={markPresent(p)} />
    {/each}
  </Col>
  <Col>
    <h2>Present</h2>
    {#each data.participants.filter((p) => p.present) as p (p.id)}
      <ParticipantCard memberId={p.id} on:change={markNotPresent(p)} />
    {/each}
  </Col>
</Row>
