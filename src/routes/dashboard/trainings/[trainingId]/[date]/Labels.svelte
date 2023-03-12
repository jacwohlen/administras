<script lang="ts">
  export let labels: string[] = [];
</script>

{#each labels as l, i (l)}
  {#if i > 1}
    .
  {:else}
    <span class="chip sm mr-1 p-1 variant-ghost-secondary">{l}</span>
  {/if}
{/each}
