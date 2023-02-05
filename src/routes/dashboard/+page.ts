import { db } from '$lib/firebase';
import { collection, getDocs, query, where } from 'firebase/firestore';
import type { Training } from '$lib/models';

export async function load() {
  const trainings: Training[] = [];
  const q = query(collection(db, 'trainings'), where("weekday", "==", new Date().getDay()))
  const querySnapshot = await getDocs(q);
  querySnapshot.forEach((doc) => {
    trainings.push({ ...(doc.data() as Training), id: doc.id });
  });

  console.log('PARENT DATA:');
  console.log(trainings);

  return {
    trainings
  };
}
