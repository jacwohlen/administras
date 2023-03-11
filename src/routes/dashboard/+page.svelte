<script lang="ts">
  import Fa from 'svelte-fa';
  import { faClipboardCheck, faArrowRight, faArrowLeft } from '@fortawesome/free-solid-svg-icons';
  import type { Training } from '$lib/models';
  import dayjs, { type Dayjs } from 'dayjs';
  import utils from '$lib/utils';
  import { supabaseClient } from '$lib/supabase';
  import { _ } from 'svelte-i18n';
  import { initialLocale } from '$lib/i18n';

  let date: Dayjs = dayjs().locale(initialLocale);
  const dateFormat = 'YYYY-MM-DD';
  let trainings: Training[] = [];

  function nextDay() {
    date = utils.getMostRecentDateByWeekday(date.day() + 1);
    getTrainingsForDay();
  }

  function previousDay() {
    date = utils.getMostRecentDateByWeekday(date.day() - 1);
    getTrainingsForDay();
  }

  async function getTrainingsForDay() {
    const { data } = await supabaseClient
      .from('trainings')
      .select()
      .eq('weekday', date.locale('en').format('dddd'))
      .returns<Training[]>();

    if (data) trainings = data;
  }
  getTrainingsForDay();
</script>

<div class="flex justify-between items-center m-2">
  <div>
    <button class="btn" on:click={previousDay}>
      <Fa icon={faArrowLeft} /><span>{$_('button.day')}</span>
    </button>
  </div>
  <div>
    <h1>{date.format('dddd')}</h1>
  </div>
  <div>
    <button class="btn" on:click={nextDay}>
      <span>{$_('button.day')}</span><Fa icon={faArrowRight} />
    </button>
  </div>
</div>

{#if trainings.length == 0}
  <div class="text-center">{$_('page.dashboard.noTrainingsToday')}</div>
{:else}
  <ul class="list">
    {#each trainings as t (t.id)}
      <li>
        <span class="flex-auto">
          {t.title}
        </span>
        <span class="">
          <a
            class="btn btn-sm variant-filled-secondary"
            href="/dashboard/trainings/{t.id}/{date.format(dateFormat)}"
          >
            <Fa icon={faClipboardCheck} />
            <span>{$_('button.trackAttendance')}</span>
          </a>
        </span>
      </li>
    {/each}
  </ul>
{/if}
