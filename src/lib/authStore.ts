import { readable } from 'svelte/store';
import { auth } from './firebase';
import type { User } from 'firebase/auth';
import { PUBLIC_GOOGLE_LOGIN_DOMAIN } from '$env/static/public';

type LoginInfo = {
  user: User | null;
  firebaseControlled: boolean;
};

const authStore = readable<LoginInfo>({ user: null, firebaseControlled: false }, (set) => {
  const unsubsribe = auth.onAuthStateChanged((user) => set({ user, firebaseControlled: true }));
  return unsubsribe;
});

async function signIn() {
  // FIXME: Why import here and not at top of file? Appertly sign in with Redirect
  // does not work if import on top
  const { signInWithPopup, GoogleAuthProvider } = await import('firebase/auth');
  const provider = new GoogleAuthProvider();
  provider.setCustomParameters({ hd: PUBLIC_GOOGLE_LOGIN_DOMAIN });
  await signInWithPopup(auth, provider);
}

async function signOut() {
  await auth.signOut();
}

export default {
  subscribe: authStore.subscribe,
  signIn: signIn,
  signOut: signOut
};
