<script lang="ts">
  import authStore from '$lib/authStore';
  import authStore2 from '$lib/authStore2';
  import LogoImage from './LogoImage.svelte';
</script>

<div class="grid grid-cols-1 place-items-center space-y-8 mt-10">
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
  {#if $authStore2.supabaseControlled && $authStore2.user}
    <p>
      Hi <strong>{$authStore2.user.email}</strong>
    </p>
    <a class="btn variant-filled-primary mt-2" href="/dashboard" color="primary">Open Dashboard</a>
  {:else}
    <button class="btn variant-filled-primary" on:click={authStore2.signIn} color="primary">
      Login Supabase
    </button>
  {/if}
  {$authStore2.supabaseControlled}
  {$authStore2.user}
</div>
