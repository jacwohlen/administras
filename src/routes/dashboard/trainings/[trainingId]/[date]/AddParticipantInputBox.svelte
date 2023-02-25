<script lang="ts">
  import { db } from '$lib/firebase';
  import type { Member } from '$lib/models';
  import { collection, getDocs, query, where } from 'firebase/firestore';
  import { createEventDispatcher } from 'svelte';
  import Fa from 'svelte-fa';
  import { faUserPlus } from '@fortawesome/free-solid-svg-icons';
  import { menu } from '@skeletonlabs/skeleton';

  let searchterm = '';

  let filteredData: Member[] = [];
  export let skip: Member[] = [];

  async function filterData(): Promise<Member[]> {
    const text = searchterm;
    const collRef = collection(db, '/members');
    const q = query(collRef, where('lastname', '>=', text), where('lastname', '<=', text + 'z'));

    const querySnap = await getDocs(q);
    filteredData = querySnap.docs.map((p) => ({ id: p.id, ...p.data() } as Member));

    filteredData = filteredData.filter(
      (item) => !skip.some((otherItem) => item.id === otherItem.id)
    );
    return filteredData;
  }

  function clearSearch() {
    searchterm = '';
  }

  const dispatch = createEventDispatcher();
  function add(member: Member) {
    dispatch('add', { member: member });
    clearSearch();
  }

  function createNewMember() {
    console.log('Create New Member...');
  }
</script>

<div class="relative w-full">
  <div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
    <div class="input-group-shim">
      <Fa icon={faUserPlus} />
    </div>
    <input
      class="input"
      type="text"
      placeholder="Add Member..."
      bind:value={searchterm}
      on:input={filterData}
      use:menu={{ menu: 'menu1' }}
    />
  </div>
  <nav class="card p-2 shadow-xl" data-menu={'menu1'}>
    <ul class="nav-list">
      {#each filteredData as p, i (p.id)}
        <li>
          <span>{p.lastname} {p.firstname}</span>
          <div class="justify-self-end relative">
            <button class="btn btn-sm variant-ringed-primary" on:click={() => add(p)}>
              <Fa icon={faUserPlus} />
              <span>Add</span>
            </button>
          </div>
        </li>
      {/each}
      <li>
        <strong>{searchterm}</strong>...
        <button class="btn btn-sm variant-filled-primary" on:click={createNewMember}>
          Create New
        </button>
      </li>
    </ul>
  </nav>
</div>
