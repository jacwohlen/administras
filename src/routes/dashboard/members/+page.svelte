<script lang="ts">
  import type { PageData } from './$types';
  import { Row, Col, ListGroup, ListGroupItem, Button, Icon } from 'sveltestrap';
  export let data: PageData;
</script>

<h1>Members</h1>

<ListGroup>
  {#each data.members as m (m.id)}
    <ListGroupItem>
      <Row>
        <Col>
          {m.id}
          {m.lastname}
          {m.firstname}
        </Col>
        <Col>
          <Button size="sm">
            <Icon name="text-paragraph" />
            View
          </Button>
        </Col>
      </Row>
    </ListGroupItem>
  {/each}
</ListGroup>
