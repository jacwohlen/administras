<script lang="ts">
  import { db } from '$lib/firebase';
  // import type { Member } from '$lib/models';
  // import { getDoc, doc } from 'firebase/firestore';
  import { Container, FormGroup, Input, Card } from 'sveltestrap';
  import { Autocomplete } from 'attractions';
  import { collection, getDocs, query, waitForPendingWrites, where } from 'firebase/firestore';
  import { createEventDispatcher } from 'svelte';

  // export let memberId: string; // e.g. 1234

  async function searchMember(text: string) {
    const collRef = collection(db, '/members');
    const q = query(collRef, where('lastname', '>=', text), where('lastname', '<=', text + 'z'));

    const querySnap = await getDocs(q);
    console.log('got it: ', querySnap.docs);
    return querySnap.docs.map((p) => ({ id: p.id, ...p.data() }));
  }

  async function* getOptions(text) {
    const defaultItem = { name: `it highlights the match: ${text}` };

    const res = await searchMember(text);
    console.log('res', res);

    yield [
      ...res.map((m) => ({ name: `${m.lastname} ${m.firstname}`, details: m.birthday, ...m })),
      defaultItem
    ];
  }

  const dispatch = createEventDispatcher();
  function change(event: CustomEvent) {
    console.log('selected: ', event.detail.value[0]);
    dispatch('add', { member: event.detail.value[0] });
  }
</script>

<Autocomplete on:change={change} {getOptions} />
