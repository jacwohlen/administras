<script lang="ts">
  import { PUBLIC_MODE } from '$env/static/public';
  import { invalidateAll } from '$app/navigation';
  import { supabaseClient } from '$lib/supabase';
  import { onMount } from 'svelte';
  import 'dayjs/locale/de';
  import '../theme.postcss';
  import '@skeletonlabs/skeleton/styles/all.css';
  import '../app.postcss';

  onMount(() => {
    const {
      data: { subscription }
    } = supabaseClient.auth.onAuthStateChange(() => {
      console.log('Auth state change detected');
      invalidateAll();
    });
    return () => {
      subscription.unsubscribe();
    };
  });
  let mode = PUBLIC_MODE;
</script>

{#if mode === 'DEV'}
  <div class="relative overflow-hidden h-screen w-screen bg-white border">
    <div class="absolute left-0 top-0 h-16 w-16">
      <div
        class="absolute transform -rotate-45 bg-gray-600 text-center text-white font-semibold py-1 left-[-34px] top-[32px] w-[170px]"
      >
        main
      </div>
    </div>
    <slot />
  </div>
{:else}
  <slot />
{/if}
