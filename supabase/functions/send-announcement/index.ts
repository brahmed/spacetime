import { corsHeaders, handleCors } from "../_shared/cors.ts";
import { createAdminClient } from "../_shared/supabase-admin.ts";
import { getTokensForUsers, sendFcmNotification } from "../_shared/fcm.ts";

interface SendAnnouncementRequest {
  title: string;
  body: string;
  target_role: "all" | "student" | "teacher";
  sent_by: string;
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

  let body: SendAnnouncementRequest;
  try {
    body = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON body" }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  const { title, body: messageBody, target_role, sent_by } = body;

  if (!title || !messageBody || !target_role || !sent_by) {
    return new Response(
      JSON.stringify({ error: "title, body, target_role, and sent_by are required" }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  if (!["all", "student", "teacher"].includes(target_role)) {
    return new Response(
      JSON.stringify({ error: "target_role must be one of: all, student, teacher" }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  const supabase = createAdminClient();

  // Persist the announcement record
  const { data: announcement, error: announcementError } = await supabase
    .from("announcements")
    .insert({ title, body: messageBody, target_role, sent_by })
    .select("id")
    .single();

  if (announcementError || !announcement) {
    return new Response(
      JSON.stringify({ error: announcementError?.message ?? "Failed to save announcement" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  // Fetch target user IDs
  const profileQuery = supabase.from("profiles").select("id");
  if (target_role !== "all") {
    profileQuery.eq("role", target_role);
  }

  const { data: profiles, error: profilesError } = await profileQuery;

  if (profilesError || !profiles) {
    return new Response(
      JSON.stringify({ error: profilesError?.message ?? "Failed to fetch target users" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  const userIds = profiles.map((p: { id: string }) => p.id);

  // Insert in-app notification rows for each target user
  if (userIds.length > 0) {
    const notificationRows = userIds.map((userId: string) => ({
      user_id: userId,
      title,
      body: messageBody,
      type: "announcement",
    }));
    await supabase.from("notifications").insert(notificationRows);

    // Send FCM push
    const tokens = await getTokensForUsers(supabase, userIds);
    if (tokens.length > 0) {
      await sendFcmNotification(tokens, {
        title,
        body: messageBody,
        data: {
          type: "announcement",
          announcement_id: announcement.id,
        },
      });
    }
  }

  return new Response(
    JSON.stringify({
      announcement_id: announcement.id,
      recipients: userIds.length,
    }),
    { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
  );
});
