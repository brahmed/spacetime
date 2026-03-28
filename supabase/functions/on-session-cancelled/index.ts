import { createAdminClient } from "../_shared/supabase-admin.ts";
import { getTokensForUsers, sendFcmNotification } from "../_shared/fcm.ts";

/**
 * DB Webhook handler — fires on sessions UPDATE.
 * Sends FCM cancellation notifications when a session transitions to 'cancelled'.
 * Also writes a notification row to the notifications table for each affected student.
 */
Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  let payload: {
    record: Record<string, unknown>;
    old_record: Record<string, unknown>;
  };
  try {
    payload = await req.json();
  } catch {
    return new Response("Invalid JSON", { status: 400 });
  }

  const { record, old_record } = payload;

  // Only act when transitioning to cancelled
  if (record.status !== "cancelled" || old_record.status === "cancelled") {
    return new Response(JSON.stringify({ skipped: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  }

  const sessionId = record.id as string;
  const courseId = record.course_id as string;
  const startsAt = record.starts_at as string;

  const supabase = createAdminClient();

  // Fetch course name for the notification body
  const { data: course } = await supabase
    .from("courses")
    .select("name")
    .eq("id", courseId)
    .single();

  const courseName = course?.name ?? "Your class";
  const sessionDate = new Date(startsAt).toLocaleDateString("en-GB", {
    weekday: "long",
    day: "numeric",
    month: "long",
  });

  // Fetch enrolled students
  const { data: enrollments, error: enrollmentsError } = await supabase
    .from("enrollments")
    .select("student_id")
    .eq("course_id", courseId);

  if (enrollmentsError || !enrollments || enrollments.length === 0) {
    return new Response(JSON.stringify({ notified: 0 }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  }

  const studentIds = enrollments.map((e: { student_id: string }) => e.student_id);

  const title = "Session cancelled";
  const body = `${courseName} on ${sessionDate} has been cancelled.`;

  // Insert in-app notification rows
  const notificationRows = studentIds.map((userId: string) => ({
    user_id: userId,
    title,
    body,
    type: "cancellation",
  }));

  await supabase.from("notifications").insert(notificationRows);

  // Send FCM push notifications
  const tokens = await getTokensForUsers(supabase, studentIds);
  if (tokens.length > 0) {
    await sendFcmNotification(tokens, {
      title,
      body,
      data: { type: "cancellation", session_id: sessionId },
    });
  }

  return new Response(
    JSON.stringify({ notified: studentIds.length, tokens_sent: tokens.length }),
    { status: 200, headers: { "Content-Type": "application/json" } },
  );
});
