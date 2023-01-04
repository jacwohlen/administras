import { db } from '$lib/firebase';
import type { Log } from '$lib/models';
import { getDoc, doc } from 'firebase/firestore';

export async function load({ params, parent }) {
  const parentData = await parent();
  console.log(parentData); // FIXME: Parent data seems not to work, need it to access the participants array
  // then fetch the participants array from firebase
  // and return it as participants
  let log: Log | null = null;
  const docRef = doc(db, `trainings/${params.trainingId}/log/${params.date}`);
  const docSnap = await getDoc(docRef);
  if (docSnap.exists()) {
    log = docSnap.data() as Log;
  }

  return {
    log,
    trainingId: params.trainingId,
    date: params.date
  };
}
