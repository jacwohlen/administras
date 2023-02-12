<script lang="ts">
  import authStore from '$lib/authStore';
  import { goto } from '$app/navigation';
  import { TabGroup, Tab } from '@skeletonlabs/skeleton';
  import { page } from '$app/stores';
  import { Avatar, menu, AppShell, AppBar } from '@skeletonlabs/skeleton';
  import { auth } from '$lib/firebase';

  $: if ($authStore.firebaseControlled && !$authStore.user) {
    goto('/');
  }

  let tabSet: number = 0;
  if ($page.route.id == '/dashboard') {
    tabSet = 0;
  } else if ($page.route.id?.startsWith('/dashboard/trainings')) {
    tabSet = 1;
  } else if ($page.route.id?.startsWith('/dashboard/members')) {
    tabSet = 2;
  } else if ($page.route.id?.startsWith('/dashboard/statistics')) {
    tabSet = 3;
  }

  function getInitials(): string {
    if ($authStore.user?.displayName == null) {
      return '';
    }
    const arr = $authStore.user?.displayName?.split(' ');
    if (arr?.length >= 2) {
      return arr[0].charAt(0) + arr[1].charAt(0);
    } else {
      return arr[0].charAt(0);
    }
  }
</script>

{#if $authStore.firebaseControlled && $authStore.user}
  <AppShell>
    <svelte:fragment slot="header">
      <TabGroup>
        <Tab bind:group={tabSet} name="tab1" value={0} on:click={() => goto('/dashboard')}>
          <i class="fa-regular fa-calendar-check" />
          <div>Today</div>
        </Tab>
        <Tab
          bind:group={tabSet}
          name="tab2"
          value={1}
          on:click={() => goto('/dashboard/trainings')}
        >
          <i class="fa-solid fa-list" />
          <div>Trainings</div>
        </Tab>
        <Tab bind:group={tabSet} name="tab3" value={2} on:click={() => goto('/dashboard/members')}>
          <i class="fa-regular fa-user" />
          <div>Members</div>
        </Tab>

        <div class="ml-auto my-auto pr-4" use:menu={{ menu: 'example' }}>
          {#if auth.currentUser?.photoURL != null}
            <Avatar
              src={auth.currentUser?.photoURL}
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
        <nav class="list-nav card p-4 w-64 shadow-xl" data-menu="example">
          <ul>
            <li>
              <button class="option w-full" on:click={authStore.signOut}> Logout </button>
            </li>
          </ul>
        </nav>
      </TabGroup>
    </svelte:fragment>
    <slot />
  </AppShell>
{/if}
