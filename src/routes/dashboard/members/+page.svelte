<script lang="ts">
  import type { PageData } from './$types';
  export let data: PageData;
</script>

<h1>Members</h1>

<ul class="list">
  {#each data.members as m (m.id)}
    <li>
      <span class="flex-auto">
        {m.id}
        {m.lastname}
        {m.firstname}
      </span>
      <span>
        <a class="btn btn-sm variant-filled-primary" href="#">
          <span class="fa-solid fa-grip-lines" />
          <span>View</span>
        </a>
      </span>
    </li>
  {/each}
</ul>
