import { db } from '$lib/firebase';
import { collection, getDocs } from 'firebase/firestore';
import type { Member } from '$lib/models';

// FIXME: Implement SSR with Firebase
export const ssr = false;

export async function load() {
	const members: Member[] = [];
	const querySnapshot = await getDocs(collection(db, 'members'));
	querySnapshot.forEach((doc) => {
		members.push({ ...(doc.data() as Member), id: doc.id });
	});

	return {
		members
	};
}
