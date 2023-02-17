<script lang="ts">
  import authStore from '$lib/authStore';
  import LogoImage from './LogoImage.svelte';
</script>

<div class="grid h-screen place-items-center">
  <div>
    <LogoImage /> 
    <h1 class="my-2">Welcome to Administra</h1>
    {#if $authStore.firebaseControlled && $authStore.user}
      <p>
        Hi <strong>{$authStore.user.email}</strong>
      </p>
      <a class="btn variant-filled-primary mt-2" href="/dashboard" color="primary">Open Dashboard</a>
    {:else}
      <button class="btn variant-filled-primary" on:click={authStore.signIn} color="primary">
        Login
      </button>
    {/if}
  </div>
</div>
