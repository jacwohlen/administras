import type { PageLoad } from './$types';
import { error } from '@sveltejs/kit';
import { db } from '$lib/firebase';
import { getDoc, doc } from 'firebase/firestore';
import type { Member } from '$lib/models';

export const load = (async ({ params }) => {
  const docRef = doc(db, `members/${params.memberId}`);
  const docSnap = await getDoc(docRef);
  if (!docSnap.exists()) {
    throw error(404, 'Not found');
  }

  return {
    id: docSnap.id,
    ...docSnap.data()
  } as Member;
}) satisfies PageLoad;
