/*
# Fix handle_new_user() missing schema qualification

The trigger function referenced `profiles` unqualified. SECURITY DEFINER
functions without an explicit `search_path` inherit the *caller's* search_path
at call time, not the definer's. Supabase's Auth service (GoTrue) connects
with a role whose search_path does not include `public`, so when it fired
this trigger on new user signup, `profiles` could not be resolved and every
account creation failed with "relation profiles does not exist".
*/

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, COALESCE(NEW.raw_user_meta_data->>'full_name', ''));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, auth;
