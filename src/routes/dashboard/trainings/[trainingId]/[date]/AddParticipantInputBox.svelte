<script lang="ts">
  // import { db } from '$lib/firebase';
  // import type { Member } from '$lib/models';
  // import { getDoc, doc } from 'firebase/firestore';
  import { Container, FormGroup, Input, Card } from 'sveltestrap';

  // export let memberId: string; // e.g. 1234

  // async function getMember() {
  //   const docRef = doc(db, `/members/${memberId}`);
  //   console.log(`/members/${memberId}`);
  //   const docSnap = await getDoc(docRef);
  //   if (!docSnap.exists()) {
  //     return null;
  //   }
  //   return docSnap.data() as Member;
  // }

  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();
  function change() {
    dispatch('change', { memberId: 0 });
  }
  async function* getOptions(text) {
    yield [{ name: text, details: 'Optional' }, { name: `it highlights the match: ${text}` }];
  }

  import { Autocomplete } from 'attractions';
</script>

<Input type="text" on:change={change} />
<Autocomplete {getOptions} />
