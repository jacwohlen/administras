<script lang="ts">
  import { supabaseClient } from '$lib/supabase';
  import type { LessonPlan } from '$lib/models';
  import Fa from 'svelte-fa';
  import { faEdit, faSave, faPlus, faEye } from '@fortawesome/free-solid-svg-icons';
  import { _ } from 'svelte-i18n';

  export let trainingId: string;
  export let date: string;

  let lessonPlan: LessonPlan | null = null;
  let isEditing = false;
  let isLoading = false;
  let content = '';
  let title = '';

  async function loadLessonPlan() {
    isLoading = true;
    try {
      const { data, error } = await supabaseClient
        .from('lesson_plans')
        .select('*')
        .select(
          'id, date, title, content, created_at, updated_at'
        )
        .eq('training_id', trainingId)
        .eq('date', date)
        .maybeSingle();

      if (error) {
        console.error('Error loading lesson plan:', error);
        return;
      }

      if (data) {
        lessonPlan = {
          id: data.id,
          trainingId: parseInt(trainingId),
          date: data.date,
          title: data.title || '',
          content: data.content,
          createdAt: data.created_at,
          updatedAt: data.updated_at,
          createdBy: data.created_by
        };
        content = lessonPlan.content;
        title = lessonPlan.title || '';
      } else {
        // Reset state when no lesson plan exists
        lessonPlan = null;
        content = '';
        title = '';
      }
    } finally {
      isLoading = false;
    }
  }

  async function saveLessonPlan() {
    if (!content.trim()) return;

    isLoading = true;
    try {
      if (lessonPlan) {
        // Update existing
        const { data, error } = await supabaseClient
          .from('lesson_plans')
          .update({
            title: title || null,
            content: content.trim()
          })
          .eq('id', lessonPlan.id)
          .select()
          .single();

        if (error) {
          console.error('Error updating lesson plan:', error);
          return;
        }

        lessonPlan = {
          ...lessonPlan,
          title: data.title || '',
          content: data.content,
          updatedAt: data.updated_at
        };
      } else {
        // Get current user
        const {
          data: { user }
        } = await supabaseClient.auth.getUser();

        // Create new
        const { data, error } = await supabaseClient
          .from('lesson_plans')
          .insert({
            training_id: parseInt(trainingId),
            date,
            title: title || null,
            content: content.trim(),
            created_by: user?.id
          })
          .select()
          .single();

        if (error) {
          console.error('Error creating lesson plan:', error);
          return;
        }

        lessonPlan = {
          id: data.id,
          trainingId: parseInt(trainingId),
          date: data.date,
          title: data.title || '',
          content: data.content,
          createdAt: data.created_at,
          updatedAt: data.updated_at,
          createdBy: data.created_by
        };
      }
      isEditing = false;
    } finally {
      isLoading = false;
    }
  }

  function startEditing() {
    if (!lessonPlan) {
      const template = $_('page.trainings.defaultTemplate');
      content = Array.isArray(template) ? template.join('\n') : template;
      title = '';
    }
    isEditing = true;
  }

  function cancelEditing() {
    if (lessonPlan) {
      content = lessonPlan.content;
      title = lessonPlan.title || '';
    } else {
      content = '';
      title = '';
    }
    isEditing = false;
  }

  // Load lesson plan on component mount and when props change
  $: if (trainingId && date) {
    loadLessonPlan();
  }
</script>

<div class="card p-4">
  <header class="card-header flex justify-between items-center mb-4">
    <h3 class="h3">{$_('page.trainings.lessonPlanTitle')}</h3>
    <div class="flex gap-2">
      {#if isEditing}
        <button
          class="btn btn-sm variant-filled-primary"
          on:click={saveLessonPlan}
          disabled={isLoading || !content.trim()}
        >
          <Fa icon={faSave} />
          <span>{$_('button.save')}</span>
        </button>
        <button
          class="btn btn-sm variant-outline-secondary"
          on:click={cancelEditing}
          disabled={isLoading}
        >
          {$_('button.cancel')}
        </button>
      {:else if lessonPlan}
        <button
          class="btn btn-sm variant-outline-primary"
          on:click={startEditing}
          disabled={isLoading}
        >
          <Fa icon={faEdit} />
          <span>{$_('button.edit')}</span>
        </button>
      {:else}
        <button
          class="btn btn-sm variant-filled-primary"
          on:click={startEditing}
          disabled={isLoading}
        >
          <Fa icon={faPlus} />
          <span>{$_('page.trainings.createLessonPlan')}</span>
        </button>
      {/if}
    </div>
  </header>

  <section class="card-section">
    {#if isLoading}
      <div class="placeholder animate-pulse">
        <div class="placeholder-circle w-8 h-8" />
        <div class="placeholder w-full" />
      </div>
    {:else if isEditing}
      <div class="space-y-4">
        <label class="label">
          <span>{$_('page.trainings.titleTraining')}</span>
          <input
            class="input"
            type="text"
            placeholder={$_('page.trainings.titlePlaceholder')}
            bind:value={title}
          />
        </label>
        <label class="label">
          <span>{$_('page.trainings.lessonPlanTitle')}</span>
          <textarea
            class="textarea"
            rows="20"
            placeholder={$_('page.trainings.contentPlaceholder')}
            bind:value={content}
          />
        </label>
      </div>
    {:else if lessonPlan}
      <div class="space-y-4">
        {#if lessonPlan.title}
          <h4 class="h4">{lessonPlan.title}</h4>
        {/if}
        <div class="prose max-w-none">
          {#each lessonPlan.content.split('\n') as line}
            {#if line.startsWith('# ')}
              <h1>{line.slice(2)}</h1>
            {:else if line.startsWith('## ')}
              <h2>{line.slice(3)}</h2>
            {:else if line.startsWith('### ')}
              <h3>{line.slice(4)}</h3>
            {:else if line.startsWith('- ')}
              <ul><li>{line.slice(2)}</li></ul>
            {:else}
              <p>{line}</p>
            {/if}
          {/each}
        </div>
        <footer class="text-sm opacity-60">
          {$_('page.trainings.lastEdited')}: {new Date(lessonPlan.updatedAt).toLocaleString()}
        </footer>
      </div>
    {:else}
      <div class="text-center py-8">
        <p class="opacity-60">{$_('page.trainings.noLessonPlanMessage')}</p>
      </div>
    {/if}
  </section>
</div>
