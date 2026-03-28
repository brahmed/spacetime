/**
 * FCM HTTP v1 API integration.
 *
 * Required secrets:
 *   FCM_PROJECT_ID          — Firebase project ID (e.g. "spacetime-abc12")
 *   FCM_SERVICE_ACCOUNT_KEY — Full service account JSON as a single-line string
 */

export interface FcmPayload {
  title: string;
  body: string;
  data?: Record<string, string>;
}

// ─── OAuth2 token ─────────────────────────────────────────────────────────────

interface ServiceAccount {
  client_email: string;
  private_key: string;
}

/**
 * Fetch a short-lived OAuth2 access token from Google using a service account.
 * The token is valid for 1 hour — Edge Functions are stateless so we fetch
 * a fresh one on every invocation.
 */
async function getAccessToken(serviceAccount: ServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000);

  const header = { alg: "RS256", typ: "JWT" };
  const claim = {
    iss: serviceAccount.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  };

  const encode = (obj: unknown) =>
    btoa(JSON.stringify(obj))
      .replace(/\+/g, "-")
      .replace(/\//g, "_")
      .replace(/=+$/, "");

  const unsignedJwt = `${encode(header)}.${encode(claim)}`;

  // Import the RSA private key
  const pemBody = serviceAccount.private_key
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\s/g, "");

  const keyData = Uint8Array.from(atob(pemBody), (c) => c.charCodeAt(0));
  const cryptoKey = await crypto.subtle.importKey(
    "pkcs8",
    keyData,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );

  // Sign the JWT
  const encoder = new TextEncoder();
  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    cryptoKey,
    encoder.encode(unsignedJwt),
  );

  const signatureB64 = btoa(String.fromCharCode(...new Uint8Array(signature)))
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=+$/, "");

  const jwt = `${unsignedJwt}.${signatureB64}`;

  // Exchange JWT for access token
  const tokenRes = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth2:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  if (!tokenRes.ok) {
    const text = await tokenRes.text();
    throw new Error(`Failed to fetch FCM access token: ${text}`);
  }

  const { access_token } = await tokenRes.json();
  return access_token as string;
}

// ─── Send notification ────────────────────────────────────────────────────────

/**
 * Send an FCM notification to one or more device tokens using the v1 API.
 * The v1 API requires one request per token — requests are sent in parallel.
 */
export async function sendFcmNotification(
  tokens: string[],
  payload: FcmPayload,
): Promise<void> {
  if (tokens.length === 0) return;

  const projectId = Deno.env.get("FCM_PROJECT_ID");
  const serviceAccountRaw = Deno.env.get("FCM_SERVICE_ACCOUNT_KEY");

  if (!projectId) throw new Error("FCM_PROJECT_ID is not set");
  if (!serviceAccountRaw) throw new Error("FCM_SERVICE_ACCOUNT_KEY is not set");

  const serviceAccount: ServiceAccount = JSON.parse(serviceAccountRaw);
  const accessToken = await getAccessToken(serviceAccount);

  const url = `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`;

  await Promise.all(
    tokens.map((token) => {
      const body = {
        message: {
          token,
          notification: {
            title: payload.title,
            body: payload.body,
          },
          data: payload.data ?? {},
        },
      };

      return fetch(url, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(body),
      }).then(async (res) => {
        if (!res.ok) {
          const text = await res.text();
          // Log but don't throw — a single bad token shouldn't fail the batch
          console.error(`FCM send failed for token ${token.slice(0, 10)}…: ${text}`);
        }
      });
    }),
  );
}

// ─── Fetch device tokens ──────────────────────────────────────────────────────

/**
 * Fetch FCM device tokens for a list of user IDs from the device_tokens table.
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
