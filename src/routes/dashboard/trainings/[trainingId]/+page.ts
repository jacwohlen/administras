import { error } from '@sveltejs/kit';
import { db } from '$lib/firebase';
import type { Training } from '$lib/models';
import { getDoc, doc } from 'firebase/firestore';

export async function load({ params }) {
  const docRef = doc(db, `trainings/${params.trainingId}`);
  const docSnap = await getDoc(docRef);
  if (!docSnap.exists()) {
    throw error(404, 'Not found');
  }

  return {
    ...(docSnap.data() as Training)
  };
}
