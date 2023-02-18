<script lang="ts">
  import Fa from 'svelte-fa';
  import { faClipboardCheck, faArrowRight, faArrowLeft } from '@fortawesome/free-solid-svg-icons';
  import { db } from '$lib/firebase';
  import { collection, getDocs, query, where } from 'firebase/firestore';
  import type { Training } from '$lib/models';
  import moment from 'moment';
  import type { Moment } from 'moment';

  let date: Moment = moment();
  const dateFormat: string = 'YYYY-MM-DD';
  let trainings: Training[] = [];

  function nextDay() {
    const day = date.day();
    if (day < 6) {
      date = date.day(day + 1);
    } else {
      date = date.day(day - 6);
    }
    getTrainingsForDay();
  }

  function previousDay() {
    const day = date.day();
    if (day > 0) {
      date = date.day(day - 1);
    } else {
      date = date.day(day + 6);
    }
    getTrainingsForDay();
  }

  async function getTrainingsForDay() {
    const ret: Training[] = [];
    const q = query(collection(db, 'trainings'), where('weekday', '==', date.format('dddd')));
    const querySnapshot = await getDocs(q);
    querySnapshot.forEach((doc) => {
      ret.push({ ...(doc.data() as Training), id: doc.id });
    });
    trainings = ret;
  }
  getTrainingsForDay();
</script>

<div class="flex justify-between items-center m-2">
  <div>
    <button class="btn btn-sm variant-filled-primary" on:click={previousDay}>
      <Fa icon={faArrowLeft} /><span>Day</span>
    </button>
  </div>
  <div>
    <h1>{date.format('dddd')}</h1>
  </div>
  <div>
    <button class="btn btn-sm variant-filled-primary" on:click={nextDay}>
      <span>Day</span><Fa icon={faArrowRight} />
    </button>
  </div>
</div>

{#if trainings.length == 0}
  <div class="text-center">There are no trainings happening today!</div>
{:else}
  <ul class="list">
    {#each trainings as t (t.id)}
      <li>
        <span class="flex-auto">
          {t.title}
        </span>
        <span class="">
          <a
            class="btn btn-sm variant-filled-primary"
            href="/dashboard/trainings/{t.id}/{date.format(dateFormat)}"
          >
            <Fa icon={faClipboardCheck} />
            <span>Track attandence</span>
          </a>
        </span>
      </li>
    {/each}
  </ul>
{/if}
