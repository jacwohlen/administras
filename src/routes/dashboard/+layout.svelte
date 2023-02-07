<script lang="ts">
  import { Button, Row, Col } from 'sveltestrap';
  import authStore from '$lib/authStore';
  import { goto } from '$app/navigation';

  $: if ($authStore.firebaseControlled && !$authStore.user) {
    goto('/');
  }
</script>

{#if $authStore.firebaseControlled && $authStore.user}
  <Row>
    <Col>
      <Button href="/dashboard" color="primary">Today</Button>
    </Col>
    <Col>
      <Button href="/dashboard/trainings" color="primary">Trainings</Button>
    </Col>
    <Col>
      <Button href="/dashboard/members" color="primary">Members</Button>
    </Col>
    <Col>
      <Button on:click={authStore.signOut}>Sign Out</Button>
    </Col>
  </Row>
  <slot />
{/if}
