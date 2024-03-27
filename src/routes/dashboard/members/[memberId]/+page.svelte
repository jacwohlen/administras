<script lang="ts">
  import type { PageData } from './$types';
  import { Avatar } from '@skeletonlabs/skeleton';
  import { _ } from 'svelte-i18n';
  import MemberLogs from './MemberLogs.svelte';
  import { faCamera, faTrash, faUpload } from '@fortawesome/free-solid-svg-icons';
  import { supabaseClient } from '$lib/supabase';
  import { error as err } from '@sveltejs/kit';
  import Fa from 'svelte-fa';

  export let data: PageData;

  async function handlePhotoChange(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      const file: File = input.files[0];
      await updateSupabaseMember(file);
    }
  }

  async function updateSupabaseMember(file: File) {
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = async function () {
      const { data: member, error } = await supabaseClient
        .from('members')
        .update({ img: reader.result })
        .eq('id', data.id)
        .select();
      if (error) {
        throw err(404, error);
      }
      data.img = member[0]['img'];
    };
    reader.onerror = function (error) {
      console.log('Error: ', error);
    };
  }

  async function resetImage() {
    const { data: member, error } = await supabaseClient
      .from('members')
      .update({ img: null })
      .eq('id', data.id)
      .select();
    if (error) {
      throw err(404, error);
    }
    data.img = undefined;
  }

  function selectFiles() {
    document.getElementById('selectFiles')?.click();
  }
  function takePhoto() {
    document.getElementById('takePhoto')?.click();
  }
</script>

<div class="space-y-4">
  <div class="card p-4">
    <div class="mb-4">
      {#if data.img}
        <Avatar class="mx-auto w-56" src={data.img} />
      {:else}
        <Avatar
          class="mx-auto w-56"
          initials={data.lastname.charAt(0) + data.firstname.charAt(0)}
        />
      {/if}
      <div class="flex flex-auto justify-center pt-2">
        <div class="btn-group variant-filled-secondary">
          <div>
            <input
              type="file"
              id="selectFiles"
              style="display: none;"
              accept="image/*"
              on:change={handlePhotoChange}
            />
            <button class="" on:click={selectFiles}><Fa icon={faUpload} /></button>
          </div>
          <div>
            <input
              type="file"
              id="takePhoto"
              style="display: none;"
              accept="image/*"
              on:change={handlePhotoChange}
              capture="user"
            />
            <button class="" on:click={takePhoto}><Fa icon={faCamera} /></button>
          </div>
          <div>
            <button class="" on:click={resetImage}><Fa icon={faTrash} /></button>
          </div>
        </div>
      </div>
    </div>
    <div class="table-container">
      <table class="table">
        <tr>
          <td><b>{$_('page.members.id')}</b></td>
          <td>{data.id}</td>
        </tr>
        <tr>
          <td><b>{$_('page.members.lastName')}</b></td>
          <td>{data.lastname}</td>
        </tr>
        <tr>
          <td><b>{$_('page.members.firstName')}</b></td>
          <td>{data.firstname}</td>
        </tr>
        <tr>
          <td><b>{$_('page.members.birthday')}</b></td>
          <td>{data.birthday}</td>
        </tr>
        <tr>
          <td><b>{$_('page.members.mobile')}</b></td>
          <td>{data.mobile}</td>
        </tr>
        <tr>
          <td><b>{$_('page.members.labels')}</b></td>
          <td>
            {#if data.labels}
              {#each data.labels as l}
                <span class="chip mr-2">{l}</span>
              {/each}
            {/if}
          </td>
        </tr>
      </table>
    </div>
  </div>
  <MemberLogs memberId={data.id} />
</div>
