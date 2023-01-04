<script lang="ts">
  import { db } from '$lib/firebase';
  import type { Log } from '$lib/models';
  import { getDocs, collection } from 'firebase/firestore';
  import { Row, Col, ListGroup, ListGroupItem, Button, Icon } from 'sveltestrap';

  export let trainingId: String;

  async function getLog() {
    const logs: Log[] = [];
    const docRef = collection(db, `trainings/${trainingId}/log`);
    const querySnap = await getDocs(docRef);
    querySnap.forEach((doc) => {
      logs.push({ ...(doc.data() as Log), id: doc.id });
    });
    return logs;
  }
</script>

{#await getLog() then logs}
  <ListGroup>
    {#each logs as i (i.id)}
      <ListGroupItem>
        <Row>
          <Col>
            {i.id}
          </Col>
          <Col>
            {i.members.length}
          </Col>
          <Col>
            <Button size="sm" href="/dashboard/trainings/{i.id}">
              <Icon name="text-paragraph" />
              View
            </Button>
          </Col>
        </Row>
      </ListGroupItem>
    {/each}
  </ListGroup>
{/await}
