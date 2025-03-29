import { serverSupabaseClient, serverSupabaseServiceRole } from '#supabase/server'

export default defineEventHandler(async (event) => {
  // Vérifier si l'utilisateur est admin
  const client = await serverSupabaseClient(event)
  const { data: { user } } = await client.auth.getUser()
  
  const { data: profile } = await client
    .from('profiles')
    .select('is_admin')
    .eq('id', user?.id)
    .single()

  if (!profile?.is_admin) {
    throw createError({
      statusCode: 403,
      message: 'Unauthorized: Admin access required'
    })
  }

  // Récupérer les données du body
  const body = await readBody(event)
  const { userId, banDuration, reason } = body

  // Utiliser service role pour le bannissement
  const adminClient = await serverSupabaseServiceRole(event)
  
  try {
    if (banDuration === 0) {
      // Débannir
      await adminClient.auth.admin.updateUserById(userId, {
        ban_duration: '0 seconds'
      })
    } else {
      // Bannir
      await adminClient.auth.admin.updateUserById(userId, {
        ban_duration: `${banDuration} days`,
        user_metadata: {
          banned_reason: reason,
          banned_at: new Date().toISOString()
        }
      })
    }

    return { success: true }
  } catch (error) {
    throw createError({
      statusCode: 500,
      message: 'Failed to update user ban status'
    })
  }
})