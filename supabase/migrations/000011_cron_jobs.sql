-- ─── pg_cron: send-reminders ──────────────────────────────────────────────────
-- Runs the send-reminders Edge Function at 08:00 and 14:00 UTC every day.
-- Requires the pg_cron extension — enable it in Supabase Dashboard under
-- Database → Extensions before applying this migration.

create extension if not exists pg_cron with schema extensions;

-- 08:00 UTC daily reminder
select cron.schedule(
  'send-reminders-08h',
  '0 8 * * *',
  $$
    select net.http_post(
      url    := current_setting('app.edge_base_url') || '/send-reminders',
      headers := '{"Authorization": "Bearer ' || current_setting('app.service_role_key') || '", "Content-Type": "application/json"}'::jsonb,
      body   := '{}'::jsonb
    );
  $$
);

-- 14:00 UTC daily reminder
select cron.schedule(
  'send-reminders-14h',
  '0 14 * * *',
  $$
    select net.http_post(
      url    := current_setting('app.edge_base_url') || '/send-reminders',
      headers := '{"Authorization": "Bearer ' || current_setting('app.service_role_key') || '", "Content-Type": "application/json"}'::jsonb,
      body   := '{}'::jsonb
    );
  $$
);
