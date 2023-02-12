<script lang="ts">
  import { db } from '$lib/firebase';
  import type { Log } from '$lib/models';
  import { getDocs, collection } from 'firebase/firestore';

  export let trainingId: String;

  async function getLog() {
    const logs: Log[] = [];
    const docRef = collection(db, `trainings/${trainingId}/log`);
    const querySnap = await getDocs(docRef);
    querySnap.forEach((doc) => {
      logs.push({ ...(doc.data() as Log), id: doc.id });
    });
    return logs;
  }
</script>

{#await getLog() then logs}
  <ul class="list">
    {#each logs as i (i.id)}
      <li>
        <span>
          {i.id}
        </span>
        <span class="flex-auto">
          {i.members.length}
        </span>
        <span>
          <a class="btn btn-sm variant-filled-secondary" href="/dashboard/trainings/{i.id}">
            <span class="fa-solid fa-grip-lines" />
            <span>View</span>
          </a>
        </span>
      </li>
    {/each}
  </ul>
{/await}
