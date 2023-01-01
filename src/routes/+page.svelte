<script lang="ts">
  import { Button } from 'sveltestrap';
  import authStore from '$lib/authStore';
</script>

<h1>Welcome to Administra</h1>
{#if $authStore}
  Hi {$authStore.email}
  <Button href="/dashboard" color="primary">Open Dashboard</Button>
{:else}
  <Button on:click={authStore.signIn} color="primary">Login</Button>
{/if}
