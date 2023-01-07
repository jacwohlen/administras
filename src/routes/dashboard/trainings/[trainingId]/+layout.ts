import type { LayoutLoad } from './$types';
import { error } from '@sveltejs/kit';
import { db } from '$lib/firebase';
import { getDoc, doc } from 'firebase/firestore';
import type { Training } from '$lib/models';

export const load = (async ({ params }) => {
  const docRef = doc(db, `trainings/${params.trainingId}`);
  const docSnap = await getDoc(docRef);
  if (!docSnap.exists()) {
    throw error(404, 'Not found');
  }

  return {
    id: docSnap.id,
    ...docSnap.data()
  } as Training;
}) satisfies LayoutLoad;
