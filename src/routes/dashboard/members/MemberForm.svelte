<script lang="ts">
  import { modalStore } from '@skeletonlabs/skeleton';
  import { _ } from 'svelte-i18n';
  import Fa from 'svelte-fa';
  import { faSpinner } from '@fortawesome/free-solid-svg-icons';

  export let lastname = '';
  export let firstname = '';
  export let birthday = '';
  export let mobile = '';
  export let labels: string[] = ['new'];
  export let isSubmitting = false;
  export let isEditing = false;
  export let id = '';

  let formData = {
    id,
    lastname,
    firstname,
    birthday,
    mobile,
    labels: labels || ['new']
  };

  function cancel() {
    modalStore.close();
  }

  function onFormSubmit(): void {
    if ($modalStore[0].response) $modalStore[0].response(formData);
    modalStore.close();
  }
</script>

<h3>{isEditing ? $_('dialog.editMember.title') : $_('dialog.newMember.title')}</h3>
<form class="modal-form border border-surface-500 p-4 space-y-4 rounded-container-token">
  <label class="label">
    <span>{$_('dialog.newMember.lastName')}</span>
    <input
      class="input"
      bind:value={formData.lastname}
      type="text"
      placeholder={$_('dialog.newMember.lastNamePlaceholder')}
      required
    />
  </label>
  <label class="label">
    <span>{$_('dialog.newMember.firstName')}</span>
    <input
      class="input"
      bind:value={formData.firstname}
      type="text"
      placeholder={$_('dialog.newMember.firstNamePlaceholder')}
      required
    />
  </label>
  <label class="label">
    <span>{$_('page.members.birthday')}</span>
    <input
      class="input"
      bind:value={formData.birthday}
      type="date"
      placeholder="YYYY-MM-DD"
    />
  </label>
  <label class="label">
    <span>{$_('page.members.mobile')}</span>
    <input
      class="input"
      bind:value={formData.mobile}
      type="tel"
      placeholder="+41 79 123 45 67"
    />
  </label>
</form>
<footer class="modal-footer flex justify-end space-x-2">
  <button class="btn variant-ghost-surface" on:click={cancel}>{$_('button.cancel')}</button>
  <button
    class="btn variant-filled-primary"
    disabled={!formData.firstname || !formData.lastname || isSubmitting}
    on:click={onFormSubmit}
  >
    {#if isSubmitting}
      <Fa icon={faSpinner} spin />
    {:else}
      {isEditing ? $_('button.save') : $_('button.add')}
    {/if}
  </button>
</footer>
