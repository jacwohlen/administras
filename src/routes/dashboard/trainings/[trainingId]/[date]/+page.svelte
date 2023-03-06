<script lang="ts">
  import type { PageData } from './$types';
  import type { MMember } from './types';
  import ParticipantCard from './ParticipantCard.svelte';
  import Fa from 'svelte-fa';
  import { faArrowLeft, faArrowRight } from '@fortawesome/free-solid-svg-icons';
  import moment from 'moment';
  import { goto } from '$app/navigation';
  import AddParticipantInputBox from './AddParticipantInputBox.svelte';
  import { supabaseClient } from '$lib/supabase';

  export let data: PageData;
  let searchterm: string = '';

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

  async function changePresence(event: CustomEvent<{ member: MMember; checked: boolean }>) {
    await _changePresence(event.detail.member, event.detail.checked);
    clearSearch();
  }
  async function _changePresence(member: MMember, checked: boolean) {
    console.log('changePresense triggreed', member.id, checked);
    if (checked) {
      const { error } = await supabaseClient
        .from('logs')
        .insert({ date: data.date, trainingId: data.trainingId, memberId: member.id });
      if (error) {
        console.log(error);
      }
    } else {
      const { error } = await supabaseClient
        .from('logs')
        .delete()
        .eq('date', data.date)
        .eq('trainingId', data.trainingId)
        .eq('memberId', member.id);
      if (error) {
        console.log(error);
      }
    }
    const index = data.participants.findIndex((m) => m.id === member.id);
    data.participants[index].isPresent = checked;
    filterData(); // force reactivity
  }

  async function addParticipant(event: CustomEvent<{ member: MMember }>) {
    console.log('addParticipant triggered: ', event);
    const foundIndex = filteredData.findIndex((item) => item.id === event.detail.member.id);
    if (foundIndex > -1) {
      return; // member already there
    }
    await supabaseClient
      .from('participants')
      .upsert({ trainingId: data.trainingId, memberId: event.detail.member.id });
    data.participants.push(event.detail.member);
    _changePresence(event.detail.member, true);
    filterData(); // force reactivity
  }

  async function removeParticipant(event: CustomEvent<{ member: MMember; checked: boolean }>) {
    console.log('removeParticipant triggered: ', event.detail.member.id);
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
    console.log('nextWeek', data.date);
    let d = moment(data.date, 'yyyy-MM-DD');
    d.add(7, 'days');
    await goto(d.format('yyyy-MM-DD'));
    filterData();
  }

  async function previousWeek() {
    console.log('previousWeek');
    let d = moment(data.date, 'yyyy-MM-DD');
    d.subtract(7, 'days');
    await goto(d.format('yyyy-MM-DD'));
    filterData();
  }

  const navigateList = (e: { key: string }) => {
    if (e.key === 'ArrowDown' && hiIndex <= filteredData.length - 1) {
      hiIndex === filteredData.length - 1 ? (hiIndex = 0) : (hiIndex += 1);
    } else if (e.key === 'ArrowUp' && hiIndex !== -1) {
      hiIndex === 0 ? (hiIndex = filteredData.length - 1) : (hiIndex -= 1);
    } else if (e.key === 'Enter') {
      _changePresence(filteredData[hiIndex], !filteredData[hiIndex].isPresent);
      clearSearch();
    } else {
      return;
    }
  };
</script>

<h2>{data.title}</h2>
<h4>{data.weekday} {data.dateFrom} | {data.section}</h4>
<hr class="my-2" />
<div class="flex justify-between items-center my-2">
  <div>
    <button class="btn btn-sm variant-filled-primary" on:click={previousWeek}>
      <Fa icon={faArrowLeft} /><span>Week</span>
    </button>
  </div>
  <div>
    <button class="btn variant-ghost-primary">{data.date}</button>
  </div>
  <div>
    <button class="btn btn-sm variant-filled-primary" on:click={nextWeek}>
      <span>Week</span><Fa icon={faArrowRight} />
    </button>
  </div>
</div>
<div>
  <div>
    <div class="flex items-center">
      <div class="mr-2">
        <span class="chip variant-filled-primary">{presentParticipants.length}</span>
      </div>
      <div class="grow">
        <input
          class="input"
          on:keydown={navigateList}
          type="text"
          placeholder="Search Member..."
          bind:value={searchterm}
          on:input={filterData}
        />
      </div>
    </div>
    <ul class="list">
      {#each filteredData as p, i (p.id)}
        <ParticipantCard
          highlight={hiIndex === i}
          member={p}
          on:change={changePresence}
          on:remove={removeParticipant}
        />
      {/each}
      <li>
        <aside class="alert variant-ghost-tertiary w-full justify-items-center">
          <AddParticipantInputBox on:add={addParticipant} />
        </aside>
      </li>
    </ul>
  </div>
</div>
