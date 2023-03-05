<script lang="ts">
  import { modalStore } from '@skeletonlabs/skeleton';

  export let lastname: string = '';
  export let firstname: string = '';

  let formData = {
    lastname: lastname,
    firstname: firstname
  };

  function cancel() {
    modalStore.close();
  }

  function onFormSubmit(): void {
    console.log('onFormSubmit');
    if ($modalStore[0].response) $modalStore[0].response(formData);
    modalStore.close();
  }
</script>

<h3>New Member</h3>
<slot />
<form class="modal-form border border-surface-500 p-4 space-y-4 rounded-container-token">
  <label class="label">
    <span>Lastname</span>
    <input
      class="input"
      bind:value={formData.lastname}
      type="text"
      placeholder="Enter lastname..."
    />
  </label>
  <label class="label">
    <span>Firstname</span>
    <input
      class="input"
      bind:value={formData.firstname}
      type="text"
      placeholder="Enter firstname..."
    />
  </label>
</form>
<footer class="modal-footer flex justify-end space-x-2">
  <button class="btn variant-ghost-surface" on:click={cancel}>Cancel</button>
  <button class="btn variant-filled" on:click={onFormSubmit}>Add</button>
</footer>
