import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-supabase-client-platform, x-supabase-client-platform-version, x-supabase-client-runtime, x-supabase-client-runtime-version",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Não autorizado" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;

    const callerClient = createClient(supabaseUrl, anonKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const {
      data: { user: caller },
    } = await callerClient.auth.getUser();
    if (!caller) {
      return new Response(JSON.stringify({ error: "Não autorizado" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const adminClient = createClient(supabaseUrl, serviceRoleKey);
    const { data: callerRoles } = await adminClient
      .from("user_roles")
      .select("role")
      .eq("user_id", caller.id);

    const roles = callerRoles?.map((r) => r.role) ?? [];
    const isMasterAdmin = roles.includes("master_admin");
    const isCompanyAdmin = roles.includes("company_admin");

    if (!isMasterAdmin && !isCompanyAdmin) {
      return new Response(
        JSON.stringify({ error: "Sem permissão para criar colaboradores" }),
        {
          status: 403,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const { email, name, company_id, department_id, cpf, phone, role, origin } =
      await req.json();

    if (!email || !name) {
      return new Response(
        JSON.stringify({ error: "Email e nome são obrigatórios" }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const redirectTo = origin
      ? `${origin}/reset-password`
      : `${supabaseUrl}/reset-password`;

    // 1. Create user with confirmed email
    const { data: newUser, error: createError } =
      await adminClient.auth.admin.createUser({
        email,
        email_confirm: true,
        user_metadata: { name },
      });

    if (createError) {
      return new Response(JSON.stringify({ error: createError.message }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // 2. Send password reset email (recovery flow – proven to work)
    const anonClient = createClient(supabaseUrl, anonKey);
    const { error: resetError } = await anonClient.auth.resetPasswordForEmail(
      email,
      { redirectTo }
    );

    if (resetError) {
      console.warn("Password reset email failed:", resetError.message);
    }

    const userId = newUser.user.id;

    // Update profile with extra fields
    const profileUpdate: Record<string, unknown> = {};
    if (company_id) profileUpdate.company_id = company_id;
    if (department_id) profileUpdate.department_id = department_id;
    if (cpf) profileUpdate.cpf = cpf;
    if (phone) profileUpdate.phone = phone;

    if (Object.keys(profileUpdate).length > 0) {
      await adminClient
        .from("profiles")
        .update(profileUpdate)
        .eq("user_id", userId);
    }

    // Update user_role if not default 'user'
    if (role && role !== "user") {
      await adminClient
        .from("user_roles")
        .update({ role, company_id: company_id || null })
        .eq("user_id", userId);
    } else if (company_id) {
      await adminClient
        .from("user_roles")
        .update({ company_id: company_id || null })
        .eq("user_id", userId);
    }

    return new Response(
      JSON.stringify({ success: true, user_id: userId }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (err) {
    const errorMsg = err instanceof Error ? err.message : String(err);
    return new Response(JSON.stringify({ error: errorMsg }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
