<script lang="ts">
  import type { Athletes } from '$lib/models';
  import { faArrowRight } from '@fortawesome/free-solid-svg-icons';
  import { Avatar } from '@skeletonlabs/skeleton';
  import Fa from 'svelte-fa';

  export let year: string;
  export let category: string;
  export let section: string;
  export let athletes: { [key: string]: Athletes[] };
</script>

<div class="card bg-white p-4 pt-2 pb-4 min-w-72">
  <div class="flex justify-between">
    <h3 class="indent-2">{section}</h3>
    <a class="btn btn-sm" href={'/dashboard/stats/' + year + '/top/' + category + '/' + section}>
      <Fa icon={faArrowRight} />
    </a>
  </div>
  <div class="grid grid-cols-3 gap-4">
    <div class="text-center mt-4">
      {#if athletes[section][1] != undefined}
        <div class="relative inline-block">
          <span class="badge-icon absolute -top-0 -right-0 z-10 bg-gray-300">2</span>
          <Avatar
            class="mx-auto w-16"
            initials={athletes[section][1].firstname.charAt(0) +
              athletes[section][1].lastname.charAt(0)}
            border="border-4 border-gray-300"
          />
        </div>
        <div>
          <p class="text-center">
            {athletes[section][1].firstname}
            {athletes[section][1].lastname}
            ({athletes[section][1].count})
          </p>
        </div>
      {:else}
        <div class="w-full" />
      {/if}
    </div>
    <div class="text-center">
      {#if athletes[section][0] != undefined}
        <div class="relative inline-block">
          <span class="badge-icon absolute -top-0 -right-0 z-10 bg-yellow-500">1</span>
          <Avatar
            class="mx-auto w-20"
            initials={athletes[section][0].firstname.charAt(0) +
              athletes[section][0].lastname.charAt(0)}
            border="border-4 border-yellow-500"
          />
        </div>
        <div>
          <p class="text-center">
            {athletes[section][0].firstname}
            {athletes[section][0].lastname}
            ({athletes[section][0].count})
          </p>
        </div>
      {:else}
        <div class="w-full" />
      {/if}
    </div>
    <div class="text-center mt-4">
      {#if athletes[section][2] != undefined}
        <div class="relative inline-block">
          <span class="badge-icon absolute -top-0 -right-0 z-10 bg-amber-700">3</span>
          <Avatar
            class="mx-auto w-16"
            initials={athletes[section][2].firstname.charAt(0) +
              athletes[section][2].lastname.charAt(0)}
            border="border-4 border-amber-700"
          />
        </div>
        <div>
          <p class="text-center">
            {athletes[section][2].firstname}
            {athletes[section][2].lastname}
            ({athletes[section][2].count})
          </p>
        </div>
      {:else}
        <div class="w-full" />
      {/if}
    </div>
  </div>
  <hr class="my-2" />
  <div class="overflow-y-auto w-full mr-2">
    <ol class="list-decimal list-inside mr-2" start="4">
      {#each athletes[section].slice(3, 10) as item}
        <li>
          <span class="text-nowrap">{item.lastname} {item.firstname} ({item.count})</span>
        </li>
      {/each}
    </ol>
  </div>
</div>
