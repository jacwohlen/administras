import { db } from '$lib/firebase';
import { collection, getDocs } from 'firebase/firestore';
import type { Training } from '$lib/models';

export async function load() {
  const trainings: Training[] = [];
  const querySnapshot = await getDocs(collection(db, 'trainings'));
  querySnapshot.forEach((doc) => {
    trainings.push({ ...(doc.data() as Training), id: doc.id });
  });

  return {
    trainings
  };
}
