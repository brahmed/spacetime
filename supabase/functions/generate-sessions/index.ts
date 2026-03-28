import { corsHeaders, handleCors } from "../_shared/cors.ts";
import { createAdminClient } from "../_shared/supabase-admin.ts";

interface GenerateSessionsRequest {
  course_id: string;
  /** ISO date string for the start of the generation window. Defaults to today. */
  from_date?: string;
  /** Number of weeks to generate. Defaults to 4. */
  weeks?: number;
}

interface SessionInsert {
  course_id: string;
  starts_at: string;
  ends_at: string;
  status: "scheduled";
}

/** Duration in minutes for each session — default 90 min if not specified */
const SESSION_DURATION_MINUTES = 90;

/**
 * Given a start date and recurrence config, produce all session start times
 * within [fromDate, fromDate + weeks * 7 days).
 */
function generateSessionDates(
  fromDate: Date,
  weeks: number,
  recurrenceDays: number[],
  recurrenceTime: string,
): Date[] {
  const [hours, minutes] = recurrenceTime.split(":").map(Number);
  const endDate = new Date(fromDate);
  endDate.setDate(endDate.getDate() + weeks * 7);

  const dates: Date[] = [];
  const cursor = new Date(fromDate);

  while (cursor < endDate) {
    // ISO weekday: 1=Monday … 7=Sunday, JS getDay(): 0=Sunday … 6=Saturday
    const isoWeekday = cursor.getDay() === 0 ? 7 : cursor.getDay();

    if (recurrenceDays.includes(isoWeekday)) {
      const sessionDate = new Date(cursor);
      sessionDate.setHours(hours, minutes, 0, 0);
      dates.push(sessionDate);
    }

    cursor.setDate(cursor.getDate() + 1);
  }

  return dates;
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

  let body: GenerateSessionsRequest;
  try {
    body = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON body" }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  const { course_id, from_date, weeks = 4 } = body;

  if (!course_id) {
    return new Response(JSON.stringify({ error: "course_id is required" }), {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  const supabase = createAdminClient();

  // Fetch the course
  const { data: course, error: courseError } = await supabase
    .from("courses")
    .select("id, recurrence_days, recurrence_time, recurrence_ends_at")
    .eq("id", course_id)
    .single();

  if (courseError || !course) {
    return new Response(
      JSON.stringify({ error: courseError?.message ?? "Course not found" }),
      { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  const fromDate = from_date ? new Date(from_date) : new Date();
  fromDate.setHours(0, 0, 0, 0);

  const sessionDates = generateSessionDates(
    fromDate,
    weeks,
    course.recurrence_days as number[],
    course.recurrence_time as string,
  );

  // Filter out dates beyond recurrence_ends_at
  const endsAt = course.recurrence_ends_at
    ? new Date(course.recurrence_ends_at)
    : null;

  const filteredDates = endsAt
    ? sessionDates.filter((d) => d <= endsAt)
    : sessionDates;

  if (filteredDates.length === 0) {
    return new Response(
      JSON.stringify({ inserted: 0, message: "No sessions to generate in the given window" }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  const sessionsToInsert: SessionInsert[] = filteredDates.map((start) => {
    const end = new Date(start);
    end.setMinutes(end.getMinutes() + SESSION_DURATION_MINUTES);
    return {
      course_id,
      starts_at: start.toISOString(),
      ends_at: end.toISOString(),
      status: "scheduled",
    };
  });

  const { data: inserted, error: insertError } = await supabase
    .from("sessions")
    .insert(sessionsToInsert)
    .select("id");

  if (insertError) {
    return new Response(
      JSON.stringify({ error: `Failed to insert sessions: ${insertError.message}` }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  return new Response(
    JSON.stringify({ inserted: inserted?.length ?? 0 }),
    { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
  );
});
