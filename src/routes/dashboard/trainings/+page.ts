import { db } from '$lib/firebase';
import { collection, getDocs } from 'firebase/firestore';
import type { Training } from '$lib/models';
import utils from '$lib/utils';

export async function load() {
  const trainings: Training[] = [];
  const querySnapshot = await getDocs(collection(db, 'trainings'));
  querySnapshot.forEach((doc) => {
    trainings.push({ ...(doc.data() as Training), id: doc.id });
  });

  trainings.sort((a, b) => {
    const result = utils.weekdayToNumber(a.weekday) - utils.weekdayToNumber(b.weekday);
    return result != 0 ? result : parseInt(a.dateFrom.replace(':', '')) - parseInt(b.dateFrom.replace(':', ''))
  })

  return {
    trainings
  };
}
