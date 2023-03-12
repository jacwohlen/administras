<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import Fa from 'svelte-fa';
  import { faEllipsisVertical } from '@fortawesome/free-solid-svg-icons';
  import { menu, type ModalSettings, Avatar } from '@skeletonlabs/skeleton';
  import { modalStore } from '@skeletonlabs/skeleton';
  import Labels from './Labels.svelte';
  import { _ } from 'svelte-i18n';

  import type { MMember } from './types';

  export let member: MMember;
  export let highlight = false;

  const dispatch = createEventDispatcher();

  function change() {
    dispatch('change', { member, checked: !member.isPresent, isMainTrainer: false });
  }

  function triggerConfirm(): void {
    const confirm: ModalSettings = {
      type: 'confirm',
      title: $_('dialog.confirm.title'),
      body: $_('dialog.confirm.body'),
      // TRUE if confirm pressed, FALSE if cancel pressed
      response: (r: boolean) => r === true && dispatch('remove', { member }),
      // Optionally override the button text
      buttonTextCancel: $_('button.cancle'),
      buttonTextConfirm: $_('button.confirm')
    };
    modalStore.trigger(confirm);
  }

  function toogleMainTrainer(): void {
    dispatch('change', { member, checked: true, isMainTrainer: !member.isMainTrainer });
  }
</script>

<li class={highlight ? 'bg-primary-50' : ''}>
  {#if member}
    <input
      class="checkbox"
      type="checkbox"
      value={member.id}
      checked={member.isPresent}
      on:change={change}
    />
    <div class="relative inline-block">
      {#if member.isMainTrainer}
        <span class="badge-icon absolute -bottom-0 -right-0 z-10">
          <img src="/judo-icon.svg" alt="judo-icon" />
        </span>
      {/if}
      {#if member.img}
        <Avatar src={member.img} />
      {:else}
        <Avatar initials={member.lastname.charAt(0) + member.firstname.charAt(0)} />
      {/if}
    </div>
    <span class="flex-auto">
      <dt>{member.lastname} {member.firstname}</dt>
      <dd>
        <Labels labels={member.labels ? member.labels : []} />
      </dd>
    </span>
    <div class="justify-self-end relative">
      <button class="btn" use:menu={{ menu: 'ParticipantCard' + member.id }}>
        <Fa icon={faEllipsisVertical} />
      </button>
      <nav class="card p-2 w-48 shadow-xl" data-menu={'ParticipantCard' + member.id}>
        <ul>
          <li>
            <a href={'/dashboard/members/' + member.id} class="btn option w-full">
              {$_('components.ParticipantCard.View')}
            </a>
          </li>
          <li>
            <button class="option w-full" on:click={toogleMainTrainer}>
              <img class="inline-block w-4" src="/judo-icon.svg" alt="judo-icon" />
              <span class="pl-1">{$_('components.ParticipantCard.ToggleTrainerFlag')}</span>
            </button>
          </li>
          <li>
            <button class="option w-full" on:click={triggerConfirm}>
              {$_('components.ParticipantCard.Remove')}
            </button>
          </li>
        </ul>
      </nav>
    </div>
  {:else}
    {$_('page.trainings.memberNotFound')}
  {/if}
</li>
