import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

/**
 * Returns a Supabase client with the service role key, bypassing RLS.
 * Only use this inside Edge Functions — never expose the service role key to clients.
 */
export function createAdminClient() {
  const url = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!url || !serviceRoleKey) {
    throw new Error("SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY is not set");
  }

  return createClient(url, serviceRoleKey, {
    auth: { persistSession: false },
  });
}
