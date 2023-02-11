<script lang="ts">
  import { db } from '$lib/firebase';
  import type { Member } from '$lib/models';
  // import { getDoc, doc } from 'firebase/firestore';
  import AutocompleteBox from './AutocompleteBox.svelte';
  import type { Item } from './AutocompleteBox.svelte';
  import { collection, getDocs, query, waitForPendingWrites, where } from 'firebase/firestore';
  import { createEventDispatcher } from 'svelte';

  async function searchMember(text: string): Promise<Member[]> {
    const collRef = collection(db, '/members');
    const q = query(collRef, where('lastname', '>=', text), where('lastname', '<=', text + 'z'));

    const querySnap = await getDocs(q);
    console.log('got it: ', querySnap.docs);
    return querySnap.docs.map((p) => ({ id: p.id, ...p.data() } as Member));
  }

  async function getData(text: string): Promise<Item[]> {
    console.log('GetData Called with text: ', text);
    const defaultItem: Item = { name: `it highlights the match: ${text}` };

    const res = await searchMember(text);
    console.log('res', res);

    return [
      ...res.map(
        (m) => ({ name: `${m.lastname} ${m.firstname} (${m.birthday})`, data: m } as Item)
      ),
      defaultItem
    ];
  }

  const dispatch = createEventDispatcher();
  function change(event: CustomEvent) {
    console.log('selected: ', event.detail);
    if (event.detail.name === 'Create New Member') {
      createNewMember();
    } else {
      dispatch('add', { member: event.detail.data });
    }
  }

  function createNewMember() {
    console.log('Create New Member...');
  }
</script>

<AutocompleteBox
  on:change={change}
  {getData}
  placeholder="Search Members"
  defaultItemText="Create New Member"
/>
