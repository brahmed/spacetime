import { createAdminClient } from "../_shared/supabase-admin.ts";
import { getTokensForUsers, sendFcmNotification } from "../_shared/fcm.ts";

/**
 * Cron-triggered function — runs at 08:00 and 14:00 UTC daily.
 *
 * For each scheduled session today that has not had reminders sent:
 * 1. Find students with pending attendance for that session.
 * 2. Send FCM push + write notification row.
 * 3. Flip reminder_sent = true on the session.
 */
Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  const supabase = createAdminClient();

  // Sessions today that haven't sent reminders yet
  const todayStart = new Date();
  todayStart.setHours(0, 0, 0, 0);
  const todayEnd = new Date();
  todayEnd.setHours(23, 59, 59, 999);

  const { data: sessions, error: sessionsError } = await supabase
    .from("sessions")
    .select("id, course_id, starts_at, courses(name)")
    .eq("status", "scheduled")
    .eq("reminder_sent", false)
    .gte("starts_at", todayStart.toISOString())
    .lte("starts_at", todayEnd.toISOString());

  if (sessionsError) {
    console.error("Failed to fetch sessions:", sessionsError.message);
    return new Response(
      JSON.stringify({ error: sessionsError.message }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  if (!sessions || sessions.length === 0) {
    return new Response(
      JSON.stringify({ processed: 0, message: "No sessions to remind" }),
      { status: 200, headers: { "Content-Type": "application/json" } },
    );
  }

  let totalNotified = 0;

  for (const session of sessions) {
    const courseId = session.course_id as string;
    const sessionId = session.id as string;
    const courseName = (session.courses as { name: string } | null)?.name ?? "Your class";
    const startsAt = new Date(session.starts_at as string);
    const timeStr = startsAt.toLocaleTimeString("en-GB", {
      hour: "2-digit",
      minute: "2-digit",
    });

    // Students with pending attendance for this session
    const { data: attendance, error: attendanceError } = await supabase
      .from("attendance")
      .select("student_id")
      .eq("session_id", sessionId)
      .eq("status", "pending");

    if (attendanceError || !attendance || attendance.length === 0) continue;

    const studentIds = attendance.map((a: { student_id: string }) => a.student_id);

    const title = "Class reminder";
    const body = `${courseName} starts at ${timeStr} today.`;

    // Insert in-app notifications
    const notificationRows = studentIds.map((userId: string) => ({
      user_id: userId,
      title,
      body,
      type: "reminder",
    }));
    await supabase.from("notifications").insert(notificationRows);

    // Send FCM push
    const tokens = await getTokensForUsers(supabase, studentIds);
    if (tokens.length > 0) {
      await sendFcmNotification(tokens, {
        title,
        body,
        data: { type: "reminder", session_id: sessionId },
      });
    }

    // Mark reminder as sent
    await supabase
      .from("sessions")
      .update({ reminder_sent: true })
      .eq("id", sessionId);

    totalNotified += studentIds.length;
  }

  return new Response(
    JSON.stringify({ processed: sessions.length, notified: totalNotified }),
    { status: 200, headers: { "Content-Type": "application/json" } },
  );
});
