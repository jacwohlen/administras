import { readable } from 'svelte/store';
import { PUBLIC_GOOGLE_LOGIN_DOMAIN } from '$env/static/public';

import { supabase } from './supabase';
import { invalidateAll } from '$app/navigation';
import type { SignInWithOAuthCredentials, User } from '@supabase/supabase-js';

type LoginInfo = {
  user: User | null;
  supabaseControlled: boolean;
};

const authStore = readable<LoginInfo>({ user: null, supabaseControlled: false }, (set) => {
  console.log('authStore2 initialized');
  const {
    data: { subscription }
  } = supabase.auth.onAuthStateChange((event, session) => {
    console.log('Auth state change detected: session=', session);
    const user = session ? session.user : null;
    invalidateAll();
    set({ user, supabaseControlled: true });
  });
  return subscription.unsubscribe;
});

async function signIn() {
  const config: SignInWithOAuthCredentials = {
    provider: 'google'
  };
  const { data, error } = await supabase.auth.signInWithOAuth(config);
  console.log(error);
}

async function signOut() {
  const { error } = await supabase.auth.signOut();
  if (error) {
    console.log(error);
  }
}

export default {
  subscribe: authStore.subscribe,
  signIn: signIn,
  signOut: signOut
};
