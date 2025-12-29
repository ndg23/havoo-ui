import type { Provider } from '@supabase/supabase-js'
import { useSupabaseClient } from '#imports'
import { useToast } from './useToast'
import { useUserProfileStore } from '~/stores/userProfile'

interface AuthResponse {
  success: boolean
  error?: Error | null
}

interface AuthError extends Error {
  message: string
}

export const useAuth = () => {
  const supabase = useSupabaseClient()
  const toast = useToast()
  const userProfileStore = useUserProfileStore()
  const router = useRouter()

  const signInWithProvider = async (provider: Provider): Promise<AuthResponse> => {
    try {
      const { error } = await supabase.auth.signInWithOAuth({
        provider,
        options: {
          redirectTo: `${window.location.origin}/auth/callback`,
          queryParams: {
            access_type: 'offline',
            prompt: 'consent'
          }
        }
      })

      if (error) throw error

      return { success: true }
    } catch (error) {
      const authError = error as AuthError
      console.error(`Error signing in with ${provider}:`, authError)
      return { success: false, error: authError }
    }
  }

  const signInWithEmail = async (email: string, password: string): Promise<AuthResponse> => {
    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password
      })

      if (error) throw error

      if (data.user) {
        await userProfileStore.fetchProfile()
        toast.success('Connexion réussie', 'Bienvenue sur votre espace')
        return { success: true }
      }

      return { success: false, error: new Error('No user data returned') }
    } catch (error) {
      const authError = error as AuthError
      console.error('Error signing in with email:', authError)
      let message = 'Une erreur est survenue lors de la connexion'

      if (authError.message.includes('Invalid login credentials')) {
        message = 'Email ou mot de passe incorrect'
      } else if (authError.message.includes('Email not confirmed')) {
        message = 'Veuillez confirmer votre email avant de vous connecter'
      } else if (authError.message.includes('User not found')) {
        message = 'Aucun utilisateur trouvé avec cette adresse email'
      }

      toast.error('Erreur de connexion', message)
      return { success: false, error: authError }
    }
  }

  const signUp = async (email: string, password: string, metadata?: object): Promise<AuthResponse> => {
    try {
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          emailRedirectTo: `${window.location.origin}/auth/callback`,
          data: metadata
        }
      })

      if (error) throw error

      if (data.user) {
        toast.success(
          'Inscription réussie',
          'Un email de confirmation vous a été envoyé'
        )
        return { success: true }
      }

      return { success: false, error: new Error('No user data returned') }
    } catch (error) {
      const authError = error as AuthError
      console.error('Error signing up:', authError)
      toast.error(
        'Erreur d\'inscription',
        authError.message || 'Une erreur est survenue lors de l\'inscription'
      )
      return { success: false, error: authError }
    }
  }

  const signOut = async (): Promise<AuthResponse> => {
    try {
      const { error } = await supabase.auth.signOut()
      if (error) throw error

      userProfileStore.clearProfile()
      toast.success('Déconnexion réussie', 'À bientôt !')
      router.push('/auth/login')
      return { success: true }
    } catch (error) {
      const authError = error as AuthError
      console.error('Error signing out:', authError)
      toast.error(
        'Erreur de déconnexion',
        'Une erreur est survenue lors de la déconnexion'
      )
      return { success: false, error: authError }
    }
  }

  const resetPassword = async (email: string): Promise<AuthResponse> => {
    try {
      const { error } = await supabase.auth.resetPasswordForEmail(email, {
        redirectTo: `${window.location.origin}/auth/reset-password`
      })

      if (error) throw error

      toast.success(
        'Email envoyé',
        'Consultez votre boîte mail pour réinitialiser votre mot de passe'
      )
      return { success: true }
    } catch (error) {
      const authError = error as AuthError
      console.error('Error resetting password:', authError)
      toast.error(
        'Erreur',
        'Une erreur est survenue lors de l\'envoi de l\'email'
      )
      return { success: false, error: authError }
    }
  }

  const updatePassword = async (newPassword: string): Promise<AuthResponse> => {
    try {
      const { error } = await supabase.auth.updateUser({
        password: newPassword
      })

      if (error) throw error

      toast.success(
        'Mot de passe mis à jour',
        'Votre mot de passe a été modifié avec succès'
      )
      return { success: true }
    } catch (error) {
      const authError = error as AuthError
      console.error('Error updating password:', authError)
      toast.error(
        'Erreur',
        'Une erreur est survenue lors de la modification du mot de passe'
      )
      return { success: false, error: authError }
    }
  }

  return {
    signInWithProvider,
    signInWithEmail,
    signUp,
    signOut,
    resetPassword,
    updatePassword
  }
} 