import { createClient } from '@supabase/supabase-js';

const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_SERVICE_ROLE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false },
});

const demoUsers = [
  { email: 'admin@demo.com',     full_name: 'Admin User',      role: 'admin' },
  { email: 'professor@demo.com', full_name: 'Professor Smith', role: 'professor' },
  { email: 'student@demo.com',   full_name: 'Student Jones',   role: 'student' },
];

for (const u of demoUsers) {
  const { data, error } = await supabase.auth.admin.createUser({
    email: u.email,
    password: 'demo1234',
    email_confirm: true,
    user_metadata: { full_name: u.full_name, role: u.role },
  });

  if (error) {
    console.error(`FAILED ${u.email}: ${error.message}`);
    continue;
  }

  const { error: profErr } = await supabase.from('profiles').upsert({
    id: data.user.id,
    email: u.email,
    full_name: u.full_name,
    role: u.role,
    status: 'active',
  }, { onConflict: 'id' });

  console.log(profErr ? `PROFILE FAILED ${u.email}: ${profErr.message}` : `OK ${u.email} -> ${u.role}`);
}
