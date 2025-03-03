export default defineNuxtRouteMiddleware((to) => {
  const user = useSupabaseUser()

  // Routes protégées admin
  if (to.path.startsWith('/admin') && (!user.value || user.value.role !== 'admin')) {
    return navigateTo('/connexion')
  }

  // Routes protégées utilisateur
  if (to.path.startsWith('/compte') && !user.value) {
    return navigateTo('/connexion')
  }
}) 