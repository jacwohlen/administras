<script lang="ts">
  import { modalStore } from '@skeletonlabs/skeleton';
  import { _ } from 'svelte-i18n';

  export let lastname = '';
  export let firstname = '';

  let formData = {
    lastname: lastname,
    firstname: firstname
  };

  function cancel() {
    modalStore.close();
  }

  function onFormSubmit(): void {
    if ($modalStore[0].response) $modalStore[0].response(formData);
    modalStore.close();
  }
</script>

<h3>{$_('dialog.newMember.title')}</h3>
<form class="modal-form border border-surface-500 p-4 space-y-4 rounded-container-token">
  <label class="label">
    <span>{$_('dialog.newMember.lastName')}</span>
    <input
      class="input"
      bind:value={formData.lastname}
      type="text"
      placeholder={$_('dialog.newMember.lastNamePlaceholder')}
    />
  </label>
  <label class="label">
    <span>{$_('dialog.newMember.firstName')}</span>
    <input
      class="input"
      bind:value={formData.firstname}
      type="text"
      placeholder={$_('dialog.newMember.firstNamePlaceholder')}
    />
  </label>
</form>
<footer class="modal-footer flex justify-end space-x-2">
  <button class="btn variant-ghost-surface" on:click={cancel}>{$_('button.cancel')}</button>
  <button class="btn variant-filled" on:click={onFormSubmit}>{$_('button.add')}</button>
</footer>
