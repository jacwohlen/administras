<script lang="ts">
  import authStore from '$lib/authStore';
</script>

<h1>Welcome to Administra</h1>
{#if $authStore.firebaseControlled && $authStore.user}
  <p>
    Hi {$authStore.user.email}
  </p>
  <a class="btn variant-filled-primary" href="/dashboard" color="primary">Open Dashboard</a>
{:else}
  <button class="btn variant-filled-primary" on:click={authStore.signIn} color="primary">
    Login
  </button>
{/if}
