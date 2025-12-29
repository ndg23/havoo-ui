import { useSupabaseClient } from '#imports'

// Ajouter l'interface pour le profil
interface Profile {
  id: string
  role: 'client' | 'expert' | 'admin'
  is_verified: boolean
}

export default defineNuxtRouteMiddleware(async (to) => {
  const user = useSupabaseUser()
  const client = useSupabaseClient()

  // Public routes that don't require authentication
  const publicRoutes = [
    '/auth/login',
    '/auth/register',
    '/auth/verify-email',
    '/auth/reset-password',
    '/auth/callback'
  ]

  // If route is public, allow access
  if (publicRoutes.includes(to.path)) {
    // Redirect logged-in users away from auth pages
    if (user.value && to.path.startsWith('/auth')) {
      const { data: profile } = await client
        .from('profiles')
        .select('role')
        .eq('id', user.value.id)
        .single<Profile>()

      return navigateTo(profile?.role === 'admin' ? '/admin' : '/dashboard')
    }
    return
  }

  // Check if user is authenticated
  if (!user.value) {
    return navigateTo({
      path: '/auth/login',
      query: { redirect: to.fullPath }
    })
  }

  // Get user profile
  const { data: profile } = await client
    .from('profiles')
    .select('role, is_verified')
    .eq('id', user.value.id)
    .single<Profile>()

  // Admin routes protection
  if (to.path.startsWith('/admin')) {
    if (!profile || profile.role !== 'admin') {
      return navigateTo('/dashboard')
    }
    return
  }

  // Expert routes protection
  if (to.path.startsWith('/expert')) {
    if (!profile || profile.role !== 'expert') {
      return navigateTo('/dashboard')
    }

    // Redirect unverified experts to verification page
    if (!profile.is_verified && !to.path.startsWith('/expert/verification')) {
      return navigateTo('/expert/verification')
    }
    return
  }

  // Client routes protection
  if (to.path.startsWith('/client')) {
    if (!profile || profile.role !== 'client') {
      return navigateTo('/dashboard')
    }
    return
  }

  // Protected routes that require any authenticated user
  const protectedRoutes = [
    '/dashboard',
    '/profile',
    '/settings',
    '/notifications'
  ]

  if (protectedRoutes.includes(to.path) && !user.value) {
    return navigateTo({
      path: '/auth/login',
      query: { redirect: to.fullPath }
    })
  }
}) 