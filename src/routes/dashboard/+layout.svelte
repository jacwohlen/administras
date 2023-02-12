<script lang="ts">
  import authStore from '$lib/authStore';
  import { goto } from '$app/navigation';
  import { AppBar } from '@skeletonlabs/skeleton';
  import { TabGroup, Tab } from '@skeletonlabs/skeleton';
  import { page } from '$app/stores';

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
</script>

{#if $authStore.firebaseControlled && $authStore.user}
  <TabGroup>
    <Tab bind:group={tabSet} name="tab1" value={0} on:click={() => goto('/dashboard')}>
      <i class="fa-regular fa-calendar-check" />
      <div class="hidden sm:block">Today</div>
    </Tab>
    <Tab bind:group={tabSet} name="tab2" value={1} on:click={() => goto('/dashboard/trainings')}>
      <i class="fa-solid fa-list" />
      <div class="hidden sm:block">Trainings</div>
    </Tab>
    <Tab bind:group={tabSet} name="tab3" value={2} on:click={() => goto('/dashboard/members')}>
      <i class="fa-regular fa-user" />
      <div class="hidden sm:block">Members</div>
    </Tab>
    <button class="btn" on:click={authStore.signOut}>
      <i class="fa-solid fa-right-from-bracket" />
      <div class="hidden sm:block">Sign Out</div>
    </button>
  </TabGroup>

  <slot />
{/if}
