<script lang="ts">
  import type { PageData } from './$types';
  export let data: PageData;
</script>

<h1>Fix Attendance for {data.date}</h1>

{#if !data.log}
  MODE: New
{:else}
  MODE: Editing
{/if}
<p>{data.date}</p>
<p>{data.trainingId}</p>
<p>{data.log}</p>
