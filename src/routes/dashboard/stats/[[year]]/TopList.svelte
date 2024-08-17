<script lang="ts">
  import type { Athletes } from '$lib/models';

  export let section: string;
  export let athletes: { [key: string]: Athletes[] };
</script>

<div class="card bg-white pl-4 pt-2 pb-4 min-w-72 h-72">
  <h3 class="indent-2">{section}</h3>
  <div class="overflow-y-auto w-full h-60 mr-2">
    <ol class="list-decimal list-inside mr-2">
      {#each athletes[section] as item}
        <li>
          <span class="text-nowrap">{item.lastname} {item.firstname} ({item.count})</span>
        </li>
      {/each}
    </ol>
  </div>
</div>
