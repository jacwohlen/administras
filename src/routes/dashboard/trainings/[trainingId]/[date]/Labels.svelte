<script lang="ts">
  export let labels: string[] = [];
</script>

{#each labels as l, i (l)}
  {#if i > 2}
    .
  {:else}
    <span class="chip sm mr-2">{l}</span>
  {/if}
{/each}
