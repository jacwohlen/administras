import { db } from '$lib/firebase';
import type { Log, Member } from '$lib/models';
import { getDoc, doc, DocumentReference } from 'firebase/firestore';

interface EMember extends Member {
  isPresent: boolean;
}

export async function load({ params, parent }) {
  let log: Log | null = null;
  {
    const docRef = doc(db, `trainings/${params.trainingId}/log/${params.date}`);
    const docSnap = await getDoc(docRef);
    if (docSnap.exists()) {
      log = docSnap.data() as Log;
    } else {
      console.log(`Error: Log not found ref: ${docRef.path}`);
      return;
    }
  }

  const parentData = await parent();
  interface a extends DocumentReference {
    isPresent: boolean;
  }
  const participantsRef: a[] = parentData.participants;

  for (let m = 0; m < log.members.length; m++) {
    const pMember = log.members[m];

    const foundIndex = participantsRef.findIndex((p) => p.id === pMember.id);
    if (foundIndex >= 0) {
      // found
      participantsRef[foundIndex].isPresent = true;
    } else {
      participantsRef.push({ ...pMember, isPresent: true });
    }
  }

  const promises = participantsRef.map(async (ref) => {
    const isPresent = ref.isPresent; // preserve state
    const docRef = doc(db, ref.path);
    const docSnap = await getDoc(docRef);
    if (docSnap.exists()) {
      return { ...docSnap.data(), id: ref.id, isPresent } as EMember; // set state
    }
    return [];
  });

  return {
    log,
    trainingId: params.trainingId,
    date: params.date,
    participants: (await Promise.all(promises)) as EMember[]
  };
}
