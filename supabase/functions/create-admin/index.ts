import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Gérer les requêtes OPTIONS pour CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
    const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

    if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
      throw new Error('Variables d\'environnement manquantes')
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

    // Vérifier si un admin existe déjà
    const { data: existingAdmins, error: checkError } = await supabase
      .from('profiles')
      .select('id')
      .eq('role', 'admin')
      .limit(1)

    if (checkError) {
      throw checkError
    }

    if (existingAdmins && existingAdmins.length > 0) {
      return new Response(
        JSON.stringify({ error: 'Un administrateur existe déjà' }), 
        { 
          status: 403,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        }
      )
    }

    // Créer l'utilisateur admin
    const { data: { user }, error: signUpError } = await supabase.auth.admin.createUser({
      email: 'admin@havoo.fr',
      password: 'HavooAdmin2024!',
      email_confirm: true,
      user_metadata: {
        full_name: 'Admin Havoo'
      }
    })

    if (signUpError || !user) {
      throw signUpError || new Error('Erreur lors de la création de l\'utilisateur')
    }

    // Créer le profil admin
    const { error: profileError } = await supabase
      .from('profiles')
      .insert([
        {
          id: user.id,
          first_name: 'Admin',
          last_name: 'Havoo',
          role: 'admin',
          email: user.email,
          is_verified: true
        }
      ])

    if (profileError) {
      throw profileError
    }

    return new Response(
      JSON.stringify({ 
        message: 'Administrateur créé avec succès',
        user: {
          id: user.id,
          email: user.email
        }
      }),
      { 
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ 
        error: error.message || 'Une erreur est survenue' 
      }),
      { 
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )
  }
}) 