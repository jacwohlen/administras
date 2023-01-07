<script lang="ts">
  import { db } from '$lib/firebase';
  import type { Member } from '$lib/models';
  import { getDoc, doc } from 'firebase/firestore';
  import {
    Container,
    FormGroup,
    Input,
    Card,
    Row,
    Col,
    ListGroup,
    ListGroupItem,
    Button,
    Icon
  } from 'sveltestrap';

  export let memberId: string; // e.g. 1234

  async function getMember() {
    const docRef = doc(db, `/members/${memberId}`);
    console.log(`/members/${memberId}`);
    const docSnap = await getDoc(docRef);
    if (!docSnap.exists()) {
      return null;
    }
    return docSnap.data() as Member;
  }

  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();
  function change(event) {
    dispatch('change', { checked: !checked });
  }
  let checked: boolean = false;
</script>

<Container sm>
  <Card>
    {#await getMember() then m}
      {#if m}
        <FormGroup>
          <Input
            type="checkbox"
            bind:checked
            on:change={change}
            label="{m.lastname} - {m.firstname}"
          />
          {checked}
        </FormGroup>
      {:else}
        Member {memberId} not found
      {/if}
    {/await}
  </Card>
</Container>
