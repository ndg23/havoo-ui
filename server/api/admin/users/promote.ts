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
  const { userId, isAdmin } = body

  // Utiliser service role pour la mise à jour
  const adminClient = await serverSupabaseServiceRole(event)
  
  try {
    const { error } = await adminClient
      .from('profiles')
      .update({ 
        is_admin: isAdmin,
        role: isAdmin ? 'admin' : 'client'
      })
      .eq('id', userId)

    if (error) throw error

    return { success: true }
  } catch (error) {
    throw createError({
      statusCode: 500,
      message: 'Failed to update admin status'
    })
  }
})