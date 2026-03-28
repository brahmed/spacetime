import { corsHeaders, handleCors } from "../_shared/cors.ts";
import { createAdminClient } from "../_shared/supabase-admin.ts";

interface CreateUserRequest {
  email: string;
  password: string;
  full_name: string;
  role: "student" | "teacher" | "admin";
}

Deno.serve(async (req) => {
  const corsResponse = handleCors(req);
  if (corsResponse) return corsResponse;

  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  let body: CreateUserRequest;
  try {
    body = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON body" }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  const { email, password, full_name, role } = body;

  if (!email || !password || !full_name || !role) {
    return new Response(
      JSON.stringify({ error: "email, password, full_name, and role are required" }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  if (!["student", "teacher", "admin"].includes(role)) {
    return new Response(
      JSON.stringify({ error: "role must be one of: student, teacher, admin" }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  const supabase = createAdminClient();

  // Create the auth user
  const { data: authData, error: authError } = await supabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  });

  if (authError || !authData.user) {
    return new Response(
      JSON.stringify({ error: authError?.message ?? "Failed to create auth user" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  const userId = authData.user.id;

  // Create the profile row
  const { error: profileError } = await supabase
    .from("profiles")
    .insert({ id: userId, full_name, role });

  if (profileError) {
    // Roll back the auth user on profile insert failure
    await supabase.auth.admin.deleteUser(userId);
    return new Response(
      JSON.stringify({ error: `Failed to create profile: ${profileError.message}` }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  return new Response(
    JSON.stringify({ id: userId, email, full_name, role }),
    { status: 201, headers: { ...corsHeaders, "Content-Type": "application/json" } },
  );
});
