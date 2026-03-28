const FCM_URL = "https://fcm.googleapis.com/fcm/send";

export interface FcmPayload {
  title: string;
  body: string;
  data?: Record<string, string>;
}

/**
 * Send an FCM notification to one or more device tokens.
 * Uses the legacy HTTP v1 API with FCM_SERVER_KEY.
 */
export async function sendFcmNotification(
  tokens: string[],
  payload: FcmPayload,
): Promise<void> {
  if (tokens.length === 0) return;

  const serverKey = Deno.env.get("FCM_SERVER_KEY");
  if (!serverKey) {
    throw new Error("FCM_SERVER_KEY is not set");
  }

  const body = {
    registration_ids: tokens,
    notification: {
      title: payload.title,
      body: payload.body,
    },
    data: payload.data ?? {},
  };

  const res = await fetch(FCM_URL, {
    method: "POST",
    headers: {
      Authorization: `key=${serverKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`FCM request failed (${res.status}): ${text}`);
  }
}

/**
 * Fetch device tokens for a list of user IDs from the device_tokens table.
 */
export async function getTokensForUsers(
  supabase: ReturnType<typeof import("https://esm.sh/@supabase/supabase-js@2").createClient>,
  userIds: string[],
): Promise<string[]> {
  if (userIds.length === 0) return [];

  const { data, error } = await supabase
    .from("device_tokens")
    .select("token")
    .in("user_id", userIds);

  if (error) throw new Error(`Failed to fetch device tokens: ${error.message}`);

  return (data ?? []).map((row: { token: string }) => row.token);
}
