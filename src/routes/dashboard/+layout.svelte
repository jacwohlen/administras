<script lang="ts">
  import { goto } from '$app/navigation';
  import { TabGroup, Tab } from '@skeletonlabs/skeleton';
  import { page } from '$app/stores';
  import { Avatar, menu, AppShell } from '@skeletonlabs/skeleton';
  import Fa from 'svelte-fa';
  import {
    faCalendarCheck,
    faChartSimple,
    faList,
    faUser
  } from '@fortawesome/free-solid-svg-icons';
  import { Modal } from '@skeletonlabs/skeleton';
  import type { SubmitFunction } from '@sveltejs/kit';
  import { supabaseClient } from '$lib/supabase';
  import { enhance } from '$app/forms';
  import type { LayoutData } from './$types';

  export let data: LayoutData;

  const submitLogout: SubmitFunction = async ({ cancel }) => {
    const { error } = await supabaseClient.auth.signOut();
    if (error) {
      console.log(error);
    }
    cancel();
  };

  let tabSet: number = 0;
  if ($page.route.id == '/dashboard') {
    tabSet = 0;
  } else if ($page.route.id?.startsWith('/dashboard/trainings')) {
    tabSet = 1;
  } else if ($page.route.id?.startsWith('/dashboard/members')) {
    tabSet = 2;
  } else if ($page.route.id?.startsWith('/dashboard/stats')) {
    tabSet = 3;
  }

  function getInitials(): string {
    let fullname = data.session.user.user_metadata.full_name;
    if (fullname === null || fullname.length === 0) {
      return '';
    }
    const arr = fullname.split(' ');
    if (arr?.length >= 2) {
      return arr[0].charAt(0) + arr[1].charAt(0);
    } else {
      return arr[0].charAt(0);
    }
  }
</script>

<AppShell>
  <svelte:fragment slot="header">
    <TabGroup>
      <Tab bind:group={tabSet} name="tab1" value={0} on:click={() => goto('/dashboard')}>
        <Fa icon={faCalendarCheck} class="mx-auto" />
        <div>Today</div>
      </Tab>
      <Tab bind:group={tabSet} name="tab2" value={1} on:click={() => goto('/dashboard/trainings')}>
        <Fa icon={faList} class="mx-auto" />
        <div>Trainings</div>
      </Tab>
      <Tab bind:group={tabSet} name="tab3" value={2} on:click={() => goto('/dashboard/members')}>
        <Fa icon={faUser} class="mx-auto" />
        <div>Members</div>
      </Tab>
      <Tab bind:group={tabSet} name="tab4" value={3} on:click={() => goto('/dashboard/stats')}>
        <Fa icon={faChartSimple} class="mx-auto" />
        <div>Stats</div>
      </Tab>

      <div class="ml-auto my-auto pr-4" use:menu={{ menu: 'profilemenu' }}>
        {#if data.session.user.user_metadata.avatar_url != null}
          <Avatar
            src={data.session.user.user_metadata.avatar_url}
            border="border-4 border-surface-300-600-token hover:!border-primary-500"
            cursor="cursor-pointer"
          />
        {:else}
          <Avatar
            initials={getInitials()}
            border="border-4 border-surface-300-600-token hover:!border-primary-500"
            cursor="cursor-pointer"
          />
        {/if}
      </div>
      <nav class="list-nav card p-4 w-64 shadow-xl" data-menu="profilemenu">
        <ul>
          <li>
            <form action="/logout" method="POST" use:enhance={submitLogout}>
              <button type="submit" class="option w-full">Logout</button>
            </form>
          </li>
        </ul>
      </nav>
    </TabGroup>
  </svelte:fragment>
  <div class="container p-2 mx-auto">
    <slot />
  </div>
  <Modal />
</AppShell>
