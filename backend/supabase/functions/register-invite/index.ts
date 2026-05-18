import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { token, name, email, password, phone } = await req.json();

    if (!token || !name || !email || !password || !phone) {
      return new Response(JSON.stringify({ error: "Campos obrigatórios: token, nome, email, senha e telefone" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // Atomic claim: validates + increments used_count in a single query
    const { data: claimed, error: claimErr } = await supabaseAdmin
      .rpc("claim_invitation", { token_param: token });

    if (claimErr) {
      console.error("claim_invitation error:", claimErr);
      return new Response(JSON.stringify({ error: "Erro ao validar convite" }), {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    if (!claimed || claimed.length === 0) {
      return new Response(JSON.stringify({ error: "Convite inválido, expirado ou esgotado" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const invitation = claimed[0];

    // Create user
    const { data: authData, error: authErr } = await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { name },
    });

    if (authErr) {
      // Rollback: decrement used_count since user creation failed
      await supabaseAdmin
        .from("test_invitations")
        .update({ used_count: Math.max(0, (invitation.used_count || 1) - 1) })
        .eq("id", invitation.id);

      const errorMsg = authErr.message.toLowerCase();
      if (errorMsg.includes("already") || errorMsg.includes("existe") || errorMsg.includes("registered")) {
        return new Response(JSON.stringify({ error: "Este email já está cadastrado. Faça login.", code: "EMAIL_EXISTS" }), {
          status: 409,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      return new Response(JSON.stringify({ error: authErr.message }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const userId = authData.user.id;

    // Update profile with company/department and phone
    await supabaseAdmin
      .from("profiles")
      .update({
        company_id: invitation.company_id,
        department_id: invitation.department_id,
        phone: phone,
      })
      .eq("user_id", userId);

    // Update role company_id
    await supabaseAdmin
      .from("user_roles")
      .update({ company_id: invitation.company_id })
      .eq("user_id", userId);

    return new Response(JSON.stringify({ success: true, user_id: userId }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    const errorMsg = err instanceof Error ? err.message : String(err);
    return new Response(JSON.stringify({ error: errorMsg }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
