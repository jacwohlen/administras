<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { Container, FormGroup, Input, Card } from 'sveltestrap';
  import type { MMember } from './types';

  export let member: MMember;

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
