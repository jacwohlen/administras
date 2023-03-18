import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

const envVars = dotenv.config();
  if (envVars.error) {
  throw envVars.error;
}

const SUPABASE_URL = envVars.parsed.PUBLIC_SUPABASE_URL;
const SUPABASE_SERVICE_KEY = envVars.parsed.SUPABASE_SERVICE_KEY;

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);


async function seedUser() {
  const email = 'info@jacwohlen.ch';
  const password = '12345678';

  const { user, error } = await supabase.auth.signUp({
    email,
    password,
  });

  if (error) {
    console.error('Error seeding user:', error.message);
  } else {
    console.log('User seeded successfully:', user);
  }
}

seedUser();
