import { db } from '$lib/firebase';
import type { PageLoad } from './$types';
import { getDoc, setDoc, doc, DocumentReference } from 'firebase/firestore';
import type { Training, Log } from '$lib/models';
import type { MMember } from './types';

export const load = (async ({ params, parent }) => {
  async function getLog() {
    const docRef = doc(db, `trainings/${params.trainingId}/log/${params.date}`);
    const docSnap = await getDoc(docRef);
    if (docSnap.exists()) {
      return { id: docRef.id, ...docSnap.data() } as Log;
    } else {
      await setDoc(docRef, { members: [] });
      return { id: docRef.id, members: [] } as Log;
    }
  }
  async function getLogParticipants(memberRefs: DocumentReference[]) {
    return Promise.all(
      memberRefs.map(async (ref) => {
        const docSnap = await getDoc(ref);
        if (docSnap.exists()) {
          return { id: ref.id, ...docSnap.data() };
        } else {
          console.log(`Error: Member not found ref: ${ref.path}`);
          return undefined;
        }
      })
    );
  }

  const log = await getLog();
  const logMembers = await getLogParticipants(log?.members as DocumentReference[]);

  const parentData = (await parent()) as Training;
  const trainingParticipants = await getLogParticipants(
    parentData.participants as DocumentReference[]
  );
  const participantsWithPresentStatus = trainingParticipants.map((p) => ({
    ...p,
    isPresent: false
  }));

  // Mark Present Members
  logMembers.forEach((pMember) => {
    const foundIndex = participantsWithPresentStatus.findIndex((p) => p.id === pMember?.id);
    if (foundIndex !== -1) {
      participantsWithPresentStatus[foundIndex].isPresent = true;
    } else {
      participantsWithPresentStatus.push({ ...pMember, isPresent: true });
    }
  });

  return {
    log,
    trainingId: params.trainingId,
    date: params.date,
    participants: participantsWithPresentStatus as MMember[]
  };
}) satisfies PageLoad;
