<script lang="ts">
  import { db } from '$lib/firebase';
  import type { Member } from '$lib/models';
  import { getDoc, doc } from 'firebase/firestore';
  import { Container, FormGroup, Input, Card } from 'sveltestrap';

  export let member: Member;

  // async function getMember() {
  //   const docRef = doc(db, `/members/${memberId}`);
  //   const docSnap = await getDoc(docRef);
  //   if (!docSnap.exists()) {
  //     return null;
  //   }
  //   return docSnap.data() as Member;
  // }

  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();
  function change() {
    dispatch('change', { member, checked: !member.isPresent });
  }
</script>

<Container sm>
  <Card>
    <!-- {#await getMember() then m} -->
    {#if member}
      <FormGroup>
        <Input
          type="checkbox"
          bind:checked={member.isPresent}
          on:change={change}
          label="{member.lastname} - {member.firstname}"
        />
      </FormGroup>
    {:else}
      Member not found
    {/if}
    <!-- {/await} -->
  </Card>
</Container>
