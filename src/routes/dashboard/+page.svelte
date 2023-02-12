<script lang="ts">
  import type { PageData } from './$types';
  import { Row, Col, ListGroup, ListGroupItem, Button, Icon, Alert } from 'sveltestrap';
  export let data: PageData;
</script>

<h1>Today</h1>
{#if data.trainings.length == 0}
  <Alert color="info" fade={false}>There are no trainings happening today.</Alert>
{:else}
  <ListGroup>
    {#each data.trainings as t (t.id)}
      <ListGroupItem>
        <Row>
          <Col>
            {t.id}
            {t.title}
          </Col>
          <Col>
            <Button size="sm" href="/dashboard/trainings/{t.id}">
              <Icon name="text-paragraph" />
              View
            </Button>
          </Col>
        </Row>
      </ListGroupItem>
    {/each}
  </ListGroup>
{/if}
