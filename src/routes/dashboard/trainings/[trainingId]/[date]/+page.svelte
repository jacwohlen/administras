<script lang="ts">
  import { db } from '$lib/firebase';
  import { doc, updateDoc, arrayRemove, arrayUnion } from 'firebase/firestore';
  import type { PageData } from './$types';
  import type { MMember } from './types';
  import ParticipantCard from './ParticipantCard.svelte';
  import AddParticipantInputBox from './AddParticipantInputBox.svelte';
  import { Row, Col } from 'sveltestrap';
  import type { Member } from '$lib/models';
  export let data: PageData;

  $: presentParticipants = data.participants.filter((p) => p.isPresent);
  $: notPresentParticipants = data.participants.filter((p) => !p.isPresent);

  function changePresence(event: CustomEvent<{ member: MMember; checked: boolean }>) {
    console.log('changePresense triggreed', event.detail.member.id);
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
    const index = data.participants.findIndex((m) => m.id === event.detail.member.id);
    data.participants[index].isPresent = event.detail.checked;
  }

  function addParticipant(event: CustomEvent<{ member: MMember }>) {
    console.log('addParticipant triggered: ', event);
    const path = `/trainings/${data.trainingId}`;
    const ref = doc(db, path);
    updateDoc(ref, {
      participants: arrayUnion(doc(db, `/members/${event.detail.member.id}`))
    });
    data.participants.push(event.detail.member);
    data.participants = data.participants; // force reactivity
  }

  function removeParticipant(event: CustomEvent<{ member: MMember; checked: boolean }>) {
    console.log('removeParticipant triggered: ', event.detail.member.id);
    const path = `/trainings/${data.trainingId}`;
    const ref = doc(db, path);
    updateDoc(ref, {
      participants: arrayRemove(doc(db, `/members/${event.detail.member.id}`))
    });
    // TODO: Splice , would disappear if subscribed to firestore
    const index = data.participants.findIndex((p) => p.id === event.detail.member.id);
    if (index > -1) {
      data.participants.splice(index, 1);
      data.participants = data.participants; // force reactivity
    }
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
    <AddParticipantInputBox on:add={addParticipant} />
  </Col>
</Row>
<Row>
  <Col>
    <h2>Participants</h2>
    {#each notPresentParticipants as p (p.id)}
      <ParticipantCard member={p} on:change={changePresence} on:remove={removeParticipant} />
    {/each}
  </Col>
  <Col>
    <h2>Present</h2>
    {#each presentParticipants as p (p.id)}
      <ParticipantCard member={p} on:change={changePresence} on:remove={removeParticipant} />
    {/each}
  </Col>
</Row>
