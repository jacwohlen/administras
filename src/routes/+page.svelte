<script lang="ts">
  import LogoImage from './LogoImage.svelte';
  import { error as err } from '@sveltejs/kit';
  import { supabaseClient } from '$lib/supabase';

  async function login() {
    const config: SignInWithOAuthCredentials = {
      provider: 'google',
      options: {
        redirectTo: window.location.origin
      }
    };
    const { error } = await supabaseClient.auth.signInWithOAuth(config);
    if (error) throw err(404, error);
  }

  import type { PageData } from './$types';
  import type { SignInWithOAuthCredentials } from '@supabase/supabase-js';
  export let data: PageData;
</script>

<div class="grid grid-cols-1 place-items-center space-y-8 mt-10">
  <LogoImage />
  <h1 class="my-2">Welcome to Administra</h1>
  {#if data.session}
    <p>
      Hi <strong>{data.session.user.email}</strong>
    </p>
    <a class="btn variant-filled-primary mt-2" href="/dashboard" color="primary">Open Dashboard</a>
  {:else}
    <button class="btn variant-filled-primary" on:click={login} color="primary"> Login </button>
  {/if}
</div>
