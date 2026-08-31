/*
  Fix missing admin UPDATE policy on profiles.

  profiles_update_own only allowed auth.uid() = id, so admins editing another
  user's role/status in User Management were silently blocked by RLS (no error,
  zero rows affected). This is why no profile could ever be moved into
  'pending_activation' (Onboarding) or 'inactive'/'graduated'/'withdrawn'/
  'terminated' (Off-Boarding) — HR Hub's queries were correct, but the data
  they depend on could never be created.
*/

DROP POLICY IF EXISTS "profiles_update_own" ON profiles;
CREATE POLICY "profiles_update_own_or_admin" ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id OR get_my_role() = 'admin')
  WITH CHECK (auth.uid() = id OR get_my_role() = 'admin');
