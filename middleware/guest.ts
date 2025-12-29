export default defineNuxtRouteMiddleware((to) => {
  const user = useSupabaseUser()

  // If user is authenticated and trying to access guest routes (like login/register)
  // redirect them to dashboard
  if (user.value) {
    return navigateTo('/dashboard')
  }
}) 