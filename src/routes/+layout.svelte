<script lang="ts">
  import { onMount } from 'svelte';
  import '../theme.postcss';
  import '@skeletonlabs/skeleton/styles/all.css';
  import '../app.postcss';
  import authStore from '$lib/authStore2';
  import { invalidateAll } from '$app/navigation';

  onMount(() => {
    authStore.subscribe(() => {
      console.log('onMount: invalidateAll');
      invalidateAll();
    });
  });
</script>

<slot />
