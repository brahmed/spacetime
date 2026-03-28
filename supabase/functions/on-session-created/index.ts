import { createAdminClient } from "../_shared/supabase-admin.ts";

/**
 * DB Webhook handler — fires on sessions INSERT.
 * Creates a pending attendance row for every student enrolled in the course.
 */
Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  let payload: { record: Record<string, unknown> };
  try {
    payload = await req.json();
  } catch {
    return new Response("Invalid JSON", { status: 400 });
  }

  const session = payload.record;
  const sessionId = session.id as string;
  const courseId = session.course_id as string;
  const status = session.status as string;

  // Only create attendance rows for scheduled sessions
  if (status !== "scheduled") {
    return new Response(JSON.stringify({ skipped: true }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  }

  const supabase = createAdminClient();

  // Fetch enrolled students for this course
  const { data: enrollments, error: enrollmentsError } = await supabase
    .from("enrollments")
    .select("student_id")
    .eq("course_id", courseId);

  if (enrollmentsError) {
    console.error("Failed to fetch enrollments:", enrollmentsError.message);
    return new Response(
      JSON.stringify({ error: enrollmentsError.message }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  if (!enrollments || enrollments.length === 0) {
    return new Response(JSON.stringify({ inserted: 0 }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  }

  const attendanceRows = enrollments.map((e: { student_id: string }) => ({
    session_id: sessionId,
    student_id: e.student_id,
    status: "pending",
  }));

  const { error: insertError } = await supabase
    .from("attendance")
    .insert(attendanceRows);

  if (insertError) {
    console.error("Failed to insert attendance rows:", insertError.message);
    return new Response(
      JSON.stringify({ error: insertError.message }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  return new Response(
    JSON.stringify({ inserted: attendanceRows.length }),
    { status: 200, headers: { "Content-Type": "application/json" } },
  );
});
