<script lang="ts">
  import authStore from '$lib/authStore';
  import { db } from '$lib/firebase';
  import type { Training, Member, Log } from '$lib/models';
  import { supabaseClient } from '$lib/supabase';
  import { collection, doc, getDocs, query } from 'firebase/firestore';
  import type { PageData } from './$types';

  export let data: PageData;

  async function firebaseLog(trainingId) {
    const logs: Log[] = [];
    const q = query(collection(db, `trainings/${trainingId}/log`));
    const querySnap = await getDocs(q);
    querySnap.forEach((doc) => {
      logs.push({ ...(doc.data() as Log), id: doc.id });
    });
    return logs;
  }

  async function firebaseMembers(): Promise<Member[]> {
    const members: Member[] = [];
    const querySnapshot = await getDocs(collection(db, 'members'));
    querySnapshot.forEach((doc) => {
      members.push({ ...(doc.data() as Member), id: doc.id });
    });
    return members;
  }

  async function firebaseTrainings(): Promise<Training[]> {
    const trainings: Training[] = [];
    const querySnapshot = await getDocs(collection(db, 'trainings'));
    querySnapshot.forEach((doc) => {
      trainings.push({ ...(doc.data() as Training), firestore_id: doc.id });
    });

    return trainings;
  }

  let state = 'not started';
  async function migrateMembers() {
    state = 'Migrating Members ...';
    // Migrate Members
    const m = await firebaseMembers();
    m.forEach(async (element) => {
      const res = await supabaseClient.from('members').upsert(element);
    });
    state = 'Done';
  }

  async function migrateTrainings() {
    state = 'Migrating Trainings ...';
    const t = await firebaseTrainings();
    const res = await supabaseClient
      .from('trainings')
      .insert(
        t.map((item) => {
          return {
            title: item.title,
            dateFrom: item.dateFrom,
            dateTo: item.dateTo,
            section: item.section,
            weekday: item.weekday
          };
        })
      )
      .select();
    console.log('after indert: ', res);

    // participations
    interface Participation {
      trainingId: string;
      memberId: number;
    }
    const part: Participation[] = [];
    interface NewLog {
      date: string;
      trainingId: string;
      memberId: number;
    }
    const llll: NewLog[] = [];
    for (let i = 0; i < t.length; i++) {
      t[i].participants.forEach((docRef) => {
        if (docRef.id.length < 15) {
          // UI of firebase
          part.push({ trainingId: res.data[i].id, memberId: docRef.id });
        }
      });

      // Migreate Logs
      const logs = await firebaseLog(t[i].id);
      logs.forEach((log) => {
        const date = log.id;
        log.members.forEach((m) => {
          if (m.id.length < 15) {
            llll.push({
              date,
              trainingId: res.data[i].id,
              memberId: m.id
            });
          }
        });
      });
    }
    console.log(part);
    await supabaseClient.from('participation').insert(part);
    await supabaseClient.from('logs').insert(llll);

    state = 'Done';
  }
</script>

<h1 class="mb-4">Migrate Tools</h1>

<p>
  State: {state}
</p>

{#if data.session && $authStore.firebaseControlled && $authStore.user}
  <button class="btn variant-filled-primary" on:click={migrateMembers} color="primary">
    Migrate Members to Supabase
  </button>
  <button class="btn variant-filled-primary" on:click={migrateTrainings} color="primary">
    Migrate Trainings, Participations, Logs to Supabase
  </button>

  <div>
    <h1>Members with strange ID</h1>
    {#await firebaseMembers() then items}
      <ul>
        {#each items as item}
          {#if item.id.length > 6}
            <li>{item.id} {item.lastname} {item.firstname}</li>
          {/if}
        {/each}
      </ul>
    {/await}
  </div>
{:else}
  You must login first
{/if}
