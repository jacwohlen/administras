<script lang="ts">
  import type { PageData } from './$types';
  import { Row, Col, ListGroup, ListGroupItem, Button, Icon } from 'sveltestrap';
  export let data: PageData;
</script>

<h1>Trainings</h1>
<ListGroup>
  {#each data.trainings as t (t.id)}
    <ListGroupItem>
      <Row>
        <Col>
          {t.id}
          {t.title}
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
