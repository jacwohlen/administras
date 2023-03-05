<script lang="ts">
  import type { Member } from '$lib/models';
  import { createEventDispatcher } from 'svelte';
  import Fa from 'svelte-fa';
  import { faUserPlus } from '@fortawesome/free-solid-svg-icons';
  import { menu, type ModalComponent, type ModalSettings } from '@skeletonlabs/skeleton';
  import { supabaseClient } from '$lib/supabase';
  import { modalStore } from '@skeletonlabs/skeleton';

  let searchterm = '';

  let filteredData: Member[] = [];

  async function filterData(): Promise<Member[]> {
    const text = searchterm;
    const { error, data } = await supabaseClient
      .from('view_search_members')
      .select('id, fullname, lastname, firstname')
      .like('fullname', `%${text}%`)
      .returns<Member[]>();
    if (error) {
      console.log(error);
    }
    if (data) filteredData = data;
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

  import MemberForm from './MemberForm.svelte';
  function createNewMember() {
    const s = searchterm.split(' ');
    let lastname = '';
    let firstname = '';
    if (s.length > 1) {
      lastname = s[0];
      firstname = s.splice(1).join(' ');
    } else {
      lastname = searchterm;
    }

    const modalComponent: ModalComponent = {
      ref: MemberForm,
      props: { lastname, firstname }
    };

    const d: ModalSettings = {
      type: 'component',
      component: modalComponent,
      response: async (r) => {
        const { error, data } = await supabaseClient
          .from('members')
          .insert({ ...r, labels: ['new'] })
          .select()
          .single();
        if (error) console.log(error);
        dispatch('add', { member: data });
        clearSearch();
      }
    };
    modalStore.trigger(d);
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
          <span class="flex-auto">{p.lastname} {p.firstname}</span>
          <div class="justify-self-end relative">
            <button class="btn btn-sm variant-ringed-primary" on:click={() => add(p)}>
              <Fa icon={faUserPlus} />
              <span>Add</span>
            </button>
          </div>
        </li>
      {/each}
      <li>
        <span class="flex-auto">{searchterm}...</span>
        <div class="justify-self-end relative">
          <button class="btn btn-sm variant-filled-primary" on:click={createNewMember}>
            Create New
          </button>
        </div>
      </li>
    </ul>
  </nav>
</div>
