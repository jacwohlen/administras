<script lang="ts">
  import Fa from 'svelte-fa';
  import { faClipboardCheck, faArrowRight, faArrowLeft } from '@fortawesome/free-solid-svg-icons';
  import { db } from '$lib/firebase';
  import { collection, getDocs, query, where } from 'firebase/firestore';
  import type { Training } from '$lib/models';
  import moment from 'moment';
  import type { Moment } from 'moment';

  let currentDate: Moment = moment();
  let trainings: Training[] = [];

  function nextDay() {
    currentDate = currentDate.add(1, 'days');
    getTrainingsForDay();
  }

  function previousDay() {
    currentDate = currentDate.subtract(1, 'days');
    getTrainingsForDay();
  }

  async function getTrainingsForDay() {
    console.log('getting data for date: ' + currentDate.format('YYYY-MM-DD'));
    const ret: Training[] = [];
    const q = query(
      collection(db, 'trainings'),
      where('weekday', '==', currentDate.format('dddd'))
    );
    const querySnapshot = await getDocs(q);
    querySnapshot.forEach((doc) => {
      ret.push({ ...(doc.data() as Training), id: doc.id });
    });
    console.log(ret);
    trainings = ret;
  }
  getTrainingsForDay();
</script>

<h1>Today</h1>
<div class="text-center p-4 .w-4/5">
  <div class="btn-group variant-filled-primary">
    <button on:click={previousDay}><Fa icon={faArrowLeft} /> </button>
    <button class="w-64">
      {currentDate.format('dddd DD.MM.YYYY')}
    </button>
    <button on:click={nextDay}><Fa icon={faArrowRight} /> </button>
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
          <a class="btn btn-sm variant-filled-primary" href="/dashboard/trainings/{t.id}">
            <Fa icon={faClipboardCheck} />
            Track attandence
          </a>
        </span>
      </li>
    {/each}
  </ul>
{/if}
