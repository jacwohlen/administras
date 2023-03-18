import { createClient } from '@supabase/supabase-js';

// cache session data for each user name
const sessions = {};

export default function getUserSession(env) {
  return async ({ user }) => {
    // Create a session for the user if it doesn't exist already.
    if (!sessions[user]) {
      const supabase = createClient(
        env.PUBLIC_SUPABASE_URL,
        env.PUBLIC_SUPABASE_ANON_KEY
      );

      const { data, error } = await supabase.auth.signInWithPassword(user);

      sessions[user] = data.session;
    }

    return sessions[user];
  }
}
