<script lang="ts">
  import { db } from '$lib/firebase';
  import { doc, updateDoc, arrayRemove, arrayUnion } from 'firebase/firestore';
  import type { PageData } from './$types';
  import type { MMember } from './types';
  import ParticipantCard from './ParticipantCard.svelte';
  import AddParticipantInputBox from './AddParticipantInputBox.svelte';
  import { Row, Col } from 'sveltestrap';
  export let data: PageData;

  $: presentParticipants = data.participants.filter((p) => p.isPresent);
  $: notPresentParticipants = data.participants.filter((p) => !p.isPresent);

  function changePresence(event: CustomEvent<{ member: MMember; checked: boolean }>) {
    const path = `/trainings/${data.trainingId}/log/${data.date}`;
    const ref = doc(db, path);
    if (event.detail.checked) {
      updateDoc(ref, {
        members: arrayUnion(doc(db, `/members/${event.detail.member.id}`))
      });
    } else {
      updateDoc(ref, {
        members: arrayRemove(doc(db, `/members/${event.detail.member.id}`))
      });
    }
  }

  function addParticipant() {}

  function removeParticipant() {}
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
    <AddParticipantInputBox />
  </Col>
</Row>
<Row>
  <Col>
    <h2>Participants</h2>
    {#each notPresentParticipants as p (p.id)}
      <ParticipantCard bind:member={p} on:change={changePresence} />
    {/each}
  </Col>
  <Col>
    <h2>Present</h2>
    {#each presentParticipants as p (p.id)}
      <ParticipantCard bind:member={p} on:change={changePresence} />
    {/each}
  </Col>
</Row>
