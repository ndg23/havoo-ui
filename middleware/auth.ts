// Ajouter l'interface pour le profil
interface Profile {
  id: string
  role: 'client' | 'expert' | 'admin'
}

export default defineNuxtRouteMiddleware(async (to) => {
  const user = useSupabaseUser()
  const client = useSupabaseClient()

  if (!user.value && !to.path.startsWith('/auth')) {
    return navigateTo('/auth/login')
  }

  if (user.value && to.path.startsWith('/auth')) {
    // Vérifier le rôle pour la redirection
    const { data: profile } = await client
      .from('profiles')
      .select('role')
      .eq('id', user.value.id)
      .single<Profile>()

    if (profile?.role === 'admin') {
      return navigateTo('/admin')
    }
    return navigateTo('/dashboard')
  }

  // Routes protégées admin
  if (to.path.startsWith('/admin') && (!user.value || user.value.role !== 'admin')) {
    return navigateTo('/auth/login')
  }

  // Routes protégées utilisateur
  if (to.path.startsWith('/compte') && !user.value) {
    return navigateTo('/auth/login')
  }

  // if (!user.value && to.path === '/requests/new') {
  //   return navigateTo({
  //     path: '/auth/login',
  //     query: { redirect: to.fullPath }
  //   })
  // }
}) 