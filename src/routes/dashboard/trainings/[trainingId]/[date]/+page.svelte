<script lang="ts">
  import type { PageData } from './$types';
  import type { MMember } from './types';
  import ParticipantCard from './ParticipantCard.svelte';
  import Fa from 'svelte-fa';
  import { faArrowLeft, faArrowRight } from '@fortawesome/free-solid-svg-icons';
  import dayjs from 'dayjs';
  import { goto } from '$app/navigation';
  import AddParticipantInputBox from './AddParticipantInputBox.svelte';
  import { supabaseClient } from '$lib/supabase';
  import { _ } from 'svelte-i18n';
  import { flip } from 'svelte/animate';
  import { quintInOut } from 'svelte/easing';

  export let data: PageData;
  let searchterm = '';
  let animateList = true;

  let filteredData: MMember[] = [];
  $: presentParticipants = filteredData.filter((p) => p.isPresent);

  let hiIndex = -1;

  const filterData = async () => {
    filteredData = data.participants.filter((p) => {
      const s = searchterm.toLowerCase();
      return p.lastname.toLowerCase().startsWith(s) || p.firstname.toLowerCase().startsWith(s);
    });

    hiIndex = filteredData.length > 0 && searchterm ? 0 : -1;

    filteredData = filteredData.sort((a, b) => {
      if (a.isPresent && !b.isPresent) {
        return -1; // a comes first
      } else if (!a.isPresent && b.isPresent) {
        return 1; // b comes first
      } else {
        return 0; // no sorting needed
      }
    });
  };

  function clearSearch() {
    searchterm = '';
    hiIndex = -1;
    filterData();
  }

  filterData();

  async function changePresence(
    event: CustomEvent<{ member: MMember; checked: boolean; isMainTrainer: boolean }>
  ) {
    await _changePresence(event.detail.member, event.detail.checked, event.detail.isMainTrainer);
  }

  async function _changePresence(member: MMember, checked: boolean, isMainTrainer: boolean) {
    const index = data.participants.findIndex((m) => m.id === member.id);
    data.participants[index].isPresent = checked;
    data.participants[index].isMainTrainer = isMainTrainer;
    clearSearch();

    // Always delete any existing entry (code simplicity to the tradeoff of executing 2 api calls)
    const { error } = await supabaseClient
      .from('logs')
      .delete()
      .eq('date', data.date)
      .eq('trainingId', data.trainingId)
      .eq('memberId', member.id);
    if (error) {
      console.log(error);
    }

    if (checked) {
      const { error } = await supabaseClient.from('logs').insert({
        date: data.date,
        trainingId: data.trainingId,
        memberId: member.id,
        isMainTrainer
      });
      if (error) {
        console.log(error);
      }
    }
  }

  async function addParticipant(event: CustomEvent<{ member: MMember }>) {
    const foundIndex = filteredData.findIndex((item) => item.id === event.detail.member.id);
    if (foundIndex > -1) {
      return; // member already there
    }
    const d = await supabaseClient
      .from('participants')
      .upsert({ trainingId: data.trainingId, memberId: event.detail.member.id })
      .select('members(*)')
      .single();

    data.participants.push(d.data!.members as unknown as MMember);
    _changePresence(event.detail.member, true, false);
    filterData(); // force reactivity
  }

  async function removeParticipant(event: CustomEvent<{ member: MMember; checked: boolean }>) {
    await supabaseClient
      .from('participants')
      .delete()
      .eq('trainingId', data.trainingId)
      .eq('memberId', event.detail.member.id);
    // TODO: Splice , would disappear if subscribed to supabase
    const index = data.participants.findIndex((p) => p.id === event.detail.member.id);
    if (index > -1) {
      data.participants.splice(index, 1);
      filterData(); // force reactivity
    }
  }

  async function nextWeek() {
    let d = dayjs(data.date, 'YYYY-MM-DD');
    d = d.add(7, 'days');
    await goto(d.format('YYYY-MM-DD'));
    filterData();
  }

  async function previousWeek() {
    let d = dayjs(data.date, 'YYYY-MM-DD');
    d = d.subtract(7, 'days');
    await goto(d.format('YYYY-MM-DD'));
    filterData();
  }

  const navigateList = (e: { key: string }) => {
    if (e.key === 'ArrowDown' && hiIndex <= filteredData.length - 1) {
      hiIndex === filteredData.length - 1 ? (hiIndex = 0) : (hiIndex += 1);
    } else if (e.key === 'ArrowUp' && hiIndex !== -1) {
      hiIndex === 0 ? (hiIndex = filteredData.length - 1) : (hiIndex -= 1);
    } else if (e.key === 'Enter') {
      _changePresence(filteredData[hiIndex], !filteredData[hiIndex].isPresent, false);
      clearSearch();
    } else {
      return;
    }
  };
</script>

<h2>{data.title}</h2>
<h4>{$_('weekday.' + data.weekday)} {data.dateFrom} | {data.section}</h4>
<hr class="my-2" />
<div class="flex justify-between items-center my-2">
  <div>
    <button class="btn" on:click={previousWeek}>
      <Fa icon={faArrowLeft} /><span>{$_('button.week')}</span>
    </button>
  </div>
  <div>
    <h2>{data.date}</h2>
  </div>
  <div>
    <button class="btn" on:click={nextWeek}>
      <span>{$_('button.week')}</span><Fa icon={faArrowRight} />
    </button>
  </div>
</div>
<div>
  <div>
    <div class="flex items-center">
      <div class="mr-2">
        <span class="chip variant-filled-secondary">{presentParticipants.length}</span>
      </div>
      <div class="grow">
        <input
          class="input"
          on:keydown={navigateList}
          type="text"
          placeholder={$_('page.trainings.searchMembersPlaceholder')}
          bind:value={searchterm}
          on:input={filterData}
          on:focus={() => (animateList = false)}
          on:blur={() => (animateList = true)}
        />
      </div>
    </div>
    <ul class="list">
      {#each filteredData as p, i (p.id)}
        <div
          class="item"
          animate:flip={{ delay: 0, duration: animateList ? 400 : 0, easing: quintInOut }}
        >
          <ParticipantCard
            highlight={hiIndex === i}
            member={p}
            on:change={changePresence}
            on:remove={removeParticipant}
          />
        </div>
      {/each}
      <li>
        <aside class="alert variant-ghost-tertiary w-full justify-items-center">
          <AddParticipantInputBox on:add={addParticipant} />
        </aside>
      </li>
    </ul>
  </div>
</div>
