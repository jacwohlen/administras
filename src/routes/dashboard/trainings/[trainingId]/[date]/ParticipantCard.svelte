<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import Fa from 'svelte-fa';
  import { faEllipsisVertical } from '@fortawesome/free-solid-svg-icons';
  import { menu, type ModalSettings } from '@skeletonlabs/skeleton';
  import { modalStore } from '@skeletonlabs/skeleton';

  import type { MMember } from './types';

  export let member: MMember;

  const dispatch = createEventDispatcher();

  function change() {
    dispatch('change', { member, checked: !member.isPresent });
  }

  function triggerConfirm(): void {
    const confirm: ModalSettings = {
      type: 'confirm',
      title: 'Please Confirm',
      body: 'Are you sure you wish to proceed?',
      // TRUE if confirm pressed, FALSE if cancel pressed
      response: (r: boolean) => r === true && dispatch('remove', { member }),
      // Optionally override the button text
      buttonTextCancel: 'Cancel',
      buttonTextConfirm: 'Confirm'
    };
    modalStore.trigger(confirm);
  }
</script>

<li>
  {#if member}
    <label class="flex items-center space-x-2 flex-auto">
      <input
        class="checkbox"
        type="checkbox"
        value={member.id}
        checked={member.isPresent}
        on:change={change}
      />
      <span class="ml">{member.lastname} - {member.firstname}</span>
    </label>
    <div class="relative">
      <button class="btn btn-sm" use:menu={{ menu: 'menu' + member.id }}>
        <Fa icon={faEllipsisVertical} />
      </button>
      <nav class="card p-2 w-32 shadow-xl" data-menu={'menu' + member.id}>
        <ul>
          <li>
            <button class="option w-full">View</button>
          </li>
          <li>
            <button class="option w-full" on:click={triggerConfirm}>Remove</button>
          </li>
        </ul>
      </nav>
    </div>
  {:else}
    Member not found
  {/if}
</li>
