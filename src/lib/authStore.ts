import { readable } from 'svelte/store';
import { auth } from './firebase';
import type { User } from 'firebase/auth';
import { PUBLIC_GOOGLE_LOGIN_DOMAIN } from '$env/static/public';

const authStore = readable<User | null>(undefined, (set) => {
	const unsubsribe = auth.onAuthStateChanged((user) => set(user));
	return unsubsribe;
});

async function signIn() {
	const { signInWithRedirect, GoogleAuthProvider } = await import('firebase/auth');
	const provider = new GoogleAuthProvider();
	provider.setCustomParameters({ hd: PUBLIC_GOOGLE_LOGIN_DOMAIN });
	await signInWithRedirect(auth, provider);
}

async function signOut() {
	await auth.signOut();
}

export default {
	subscribe: authStore.subscribe,
	signIn: signIn,
	signOut: signOut
};
