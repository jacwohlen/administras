<script lang="ts">
  import { db } from '$lib/firebase';
  import type { Log } from '$lib/models';
  import { getDocs, collection, query, orderBy, documentId, where } from 'firebase/firestore';
  import Fa from 'svelte-fa';
  import { faGripLines } from '@fortawesome/free-solid-svg-icons';

  export let trainingId: String;

  async function getLog() {
    const logs: Log[] = [];
    const q = query(collection(db, `trainings/${trainingId}/log`));
    const querySnap = await getDocs(q);
    querySnap.forEach((doc) => {
      logs.push({ ...(doc.data() as Log), id: doc.id });
    });
    // Sort or reverse array to display newest log on top of page
    // logs.sort((a, b) => parseInt(b.id.replace('-', '')) - parseInt(a.id.replace('-', '')));
    logs.reverse();
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
          <a
            class="btn btn-sm variant-filled-secondary"
            href="/dashboard/trainings/{trainingId}/{i.id}"
          >
            <Fa icon={faGripLines} />
            <span>View</span>
          </a>
        </span>
      </li>
    {/each}
  </ul>
{/await}
