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
  export let highlight: boolean = false;

  const dispatch = createEventDispatcher();

  function change() {
    dispatch('change', { member, checked: !member.isPresent });
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
    {#if member.img}
      <Avatar src={member.img} />
    {:else}
      <Avatar initials={member.lastname.charAt(0) + member.firstname.charAt(0)} />
    {/if}
    <span class="flex-auto">
      <dt>{member.lastname} {member.firstname}</dt>
      <dd>
        <Labels labels={member.labels ? member.labels : []} />
      </dd>
    </span>
    <div class="justify-self-end relative">
      <button class="btn btn-sm" use:menu={{ menu: 'ParticipantCard' + member.id }}>
        <Fa icon={faEllipsisVertical} />
      </button>
      <nav class="card p-2 w-32 shadow-xl" data-menu={'ParticipantCard' + member.id}>
        <ul>
          <li>
            <a href={'/dashboard/members/' + member.id} class="btn option w-full"
              >{$_('button.view')}</a
            >
          </li>
          <li>
            <button class="option w-full" on:click={triggerConfirm}>{$_('button.remove')}</button>
          </li>
        </ul>
      </nav>
    </div>
  {:else}
    {$_('page.trainings.memberNotFound')}
  {/if}
</li>
