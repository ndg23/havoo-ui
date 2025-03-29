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

  const userId = event.context.params.id

  // Utiliser service role pour récupérer les données auth
  const adminClient = await serverSupabaseServiceRole(event)
  const { data: authUser, error } = await adminClient.auth.admin.getUserById(userId)

  if (error) {
    throw createError({
      statusCode: 500,
      message: 'Failed to fetch user data'
    })
  }

  return authUser.user
})
