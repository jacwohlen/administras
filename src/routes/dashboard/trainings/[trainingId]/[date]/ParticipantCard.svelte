<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import { Container, FormGroup, Input, Card } from 'sveltestrap';
  import type { MMember } from './types';

  export let member: MMember;

  const dispatch = createEventDispatcher();
  function change() {
    dispatch('change', { member, checked: !member.isPresent });
  }
  function removeClicked() {
    dispatch('remove', { member });
    modalOpen = false;
  }
  let modalOpen = false;
</script>

<Container sm>
  <Card>
    {#if member}
      <label class="flex items-center space-x-2">
        <input
          class="checkbox"
          type="checkbox"
          value={member.id}
          checked={member.isPresent}
          on:change={change}
        />
        <span class="ml">{member.lastname} - {member.firstname}</span>
      </label>
      <button class="btn btn-sm" on:click={() => (modalOpen = true)}>Remove</button>
      <!-- <Modal bind:open={modalOpen} let:closeCallback>
        <Dialog title="Hello?" {closeCallback}>
          Are you sure to remove {member.lastname} - {member.firstname}?
          <Button danger small noRipple on:click={removeClicked}>Remove</Button>
        </Dialog>
      </Modal> -->
    {:else}
      Member not found
    {/if}
  </Card>
</Container>
