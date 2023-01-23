<script lang="ts">
  import { Modal, Dialog, Checkbox, Button } from 'attractions';
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
      <Checkbox value={member.id} checked={member.isPresent} on:change={change}>
        <span class="ml">{member.lastname} - {member.firstname}</span>
      </Checkbox>
      <Button danger small noRipple on:click={() => (modalOpen = true)}>Remove</Button>
      <Modal bind:open={modalOpen} let:closeCallback>
        <Dialog title="Hello?" {closeCallback}>
          Are you sure to remove {member.lastname} - {member.firstname}?
          <Button danger small noRipple on:click={removeClicked}>Remove</Button>
        </Dialog>
      </Modal>
    {:else}
      Member not found
    {/if}
  </Card>
</Container>
